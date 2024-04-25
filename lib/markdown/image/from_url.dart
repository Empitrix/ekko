import 'package:ekko/markdown/image/extract.dart';
import 'package:ekko/markdown/image/frame_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:typed_data';
import 'dart:convert';


Widget fromUrlImage(Map<String, dynamic> data, TapGestureRecognizer? recognizer, BoxFit boxFit){
	return FutureBuilder(
		future: http.get(Uri.parse(data['url']!)),
		builder: (context, AsyncSnapshot<http.Response> snap){

			// Waiing for data
			if(!snap.hasData){
				return Shimmer.fromColors(
					baseColor: Colors.grey,
					highlightColor: Colors.grey.shade700,
					child: const Icon(Icons.image, color: Colors.grey),
				);}

			Widget img = SvgPicture.string(snap.data!.body.replaceAll('font-size="110"', 'font-size="12"'));
			Map<String, dynamic>? tagData = badgeData(snap.data!.body);

			// check for non-base64 URL
			bool skipped = RegExp(r'(https?:\/\/.*\.(?:png|jpg|gif))').hasMatch(data['url']);

			if(skipped){
				// non-badges images
				img = SizedBox(
					width: MediaQuery.of(context).size.width - 67,
					child: Image.memory(snap.data!.bodyBytes, fit: boxFit),
				);
			}

			// Check for badge
			if(tagData != null && !skipped){
				Uint8List memo = const Base64Decoder().convert(tagData["base64"].toString());  // bytes
				img = Stack(
					children: [
						img,
						Positioned(
							top: tagData["y"] ?? 3,
							left: tagData["x"] ?? 5,
							height: tagData["height"] ?? 14,
							width: tagData["width"] ?? 14,
							child: tagData["extention"]! == ImageType.picture ?
								Image.memory(memo, fit: BoxFit.cover):
								SvgPicture.memory(memo, fit: BoxFit.cover),
						) 
					],
				);
			} else {
				// Badges that are not base64 etc...
				Widget? newBadge = supportedBadge(img, data['url']!);
				if(newBadge != null){
					img = newBadge;
				}
			}



		// Display
			return MouseRegion(
				cursor: SystemMouseCursors.click,
				child: GestureDetector(
					child: img,
					onTap: (){
						// If image wraped in hyper-link it will open the link
						if(recognizer != null){
							recognizer.onTap!();
						}
					}
				)
			);
		},
	);
}

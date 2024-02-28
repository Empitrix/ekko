import 'dart:convert';
import 'dart:typed_data';
import 'package:ekko/backend/backend.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';


enum ImageType {
	picture,
	svg
}


Map<String, dynamic> _getImageLinkData(String input, Map variables){
	RegExp r = RegExp(r'\](\[|\()');

	String name = input.split(r)[0].trim()
		.substring(2).trim();
	try{
		if(name.split('').first == "["){
			name = name.substring(1);}
	}catch(_){
		name = "";
	}


	String link = input.split(r)[1].trim();
	link = link.substring(0, link.length - 1).trim();
	String format = link.substring(link.lastIndexOf(".") + 1);
	format = format.split("?")[0];
	format = vStr(format);

	if(link.isEmpty){
		link = name;
		bool isThere = variables.keys.toList().contains(name);
		if(isThere){
			link = variables[variables.keys.toList().firstWhere((e) => e == name)];
		}
	}

	return {
		"name": name,
		"url": link,
		"format": format == "svg" ? ImageType.svg : ImageType.picture
	};
}


Map<String, dynamic>? _imageTagData(String inputTag){
	Match? m = RegExp(r'<image(.*?)\/\>').firstMatch(inputTag);
	if(m == null){ return null; }
	Map<String, dynamic> params = {};
	m.group(0)!.splitMapJoin(RegExp(r'(x|y|height|width)\="[0-9]*"'),
		onMatch: (Match on){
			String txt = on.group(0)!;
			params[txt.split("=").first] = int.parse(txt.split("=").last.replaceAll('"', '')).toDouble();
			return "";
		}
	);
	Match? base64m = RegExp(r'href\=\".*?\"').firstMatch(m.group(0)!);
	if(base64m == null){ return null; }
	String base64 = base64m.group(0)!;
	base64 = base64.substring(base64.lastIndexOf(",") + 1, base64.length - 1).trim();
	params["base64"] = base64;
	params["extention"] = vStr(base64.substring(0, 1)) == "p" ? ImageType.svg : ImageType.picture;
	return params;
}



WidgetSpan showImageFrame(String txt, TapGestureRecognizer? recognizer, Map variables, [Map<String, dynamic> htmlData = const {}]){
	Map<String, dynamic> data = htmlData.isNotEmpty ? htmlData : _getImageLinkData(txt, variables);

	Widget child = FutureBuilder(
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
			Map<String, dynamic>? tagData = _imageTagData(snap.data!.body);
			
			bool skipped = RegExp(r'(https?:\/\/.*\.(?:png|jpg|gif))').hasMatch(data['url']);
			if(skipped){
				img = Image.memory(snap.data!.bodyBytes);
				// img = FittedBox(child: Image.memory(snap.data!.bodyBytes));
			}

			if(tagData != null){
				Uint8List memo = const Base64Decoder()
					.convert(tagData["base64"].toString());
				img = Stack(
					children: [
						img,
						Positioned(
							top: tagData["y"],
							left: tagData["x"],
							height: tagData["height"],
							width: tagData["width"],
							child: tagData["extention"]! == ImageType.picture ?
								Image.memory(memo):
								SvgPicture.memory(memo),
						) 
					],
				);
			} else if(data['url']!.toString().contains('codecov') && tagData == null){
				img = Stack(
					children: [
						img,
						Positioned(
							top: 3,
							left: 5,
							height: 14,
							width: 14,
							child: SvgPicture.network(
								'https://about.codecov.io/wp-content/themes/codecov/assets/brand/icons/codecov/codecov-circle.svg',
								height: 14, width: 14,
							),
						)
					],
				);
			}
			

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

	return WidgetSpan(
		child: Padding(
			padding: const EdgeInsets.only(right: 5, bottom: 2),
			// child: child
			child: FittedBox(child: child)
		)
	);
}


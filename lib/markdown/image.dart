import 'dart:convert';

import 'package:ekko/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;


enum ImageType {
	picture,
	svg
}


Map<String, dynamic> _getImageLinkData(String input){
	String name = input.split("](")[0]
		.substring(2).trim();
	String link = input.split("](")[1].trim();
	link = link.substring(0, link.length - 1).trim();
	String format = link.substring(link.lastIndexOf(".") + 1);
	format = format.split("?")[0];
	format = vStr(format);

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
	base64 = base64.substring(base64.lastIndexOf(",") + 1, base64.length - 1);
	params["base64"] = base64;
	// debugPrint(params.toString());  See in debug
	return params;
}



WidgetSpan showImageFrame(String txt){
	Map<String, dynamic> data = _getImageLinkData(txt);
	

	

	Widget child = FutureBuilder(
		future: http.get(Uri.parse(data['url']!)),
		builder: (context, AsyncSnapshot<http.Response> snap){
			if(!snap.hasData){ return const SizedBox(); }
			Widget img = SvgPicture.string(snap.data!.body.replaceAll('font-size="110"', 'font-size="12"'));
			// Extract Base64 image
			Map<String, dynamic>? tagData = _imageTagData(snap.data!.body);
			if(tagData != null){
				Widget stack = Stack(
					children: [
						img,
						Positioned(
							top: tagData["y"],
							left: tagData["x"],
							height: tagData["height"],
							width: tagData["width"],
							child: SvgPicture.memory(const Base64Decoder().convert(tagData["base64"].toString())),
						)
					],
				);
				return MouseRegion(cursor: SystemMouseCursors.click, child: GestureDetector(child: stack, onTap: (){}));
			}
			return img;
		},
	);

	/*
	Widget child = CachedNetworkImage(
		 // imageUrl: "http://via.placeholder.com/350x150",
		 imageUrl: data["url"]!,
		 progressIndicatorBuilder: (context, url, downloadProgress) => 
			 CircularProgressIndicator(value: downloadProgress.progress),
		 errorWidget: (context, url, error) => const Icon(Icons.error),
	);
	*/

	return WidgetSpan(child: child);

}




import 'package:ekko/backend/extensions.dart';
import 'package:ekko/markdown/image/frame_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


Map<String, dynamic> getImageLinkData(String input, Map variables){
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
	format = format.split("?")[0].mini();

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




Map<String, dynamic>? badgeData(String inputTag){
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
	params["extention"] = base64.substring(0, 1).mini() == "p" ? ImageType.svg : ImageType.picture;

	return params;
}




Widget? supportedBadge(Widget child, String url){
	Map<String, String> keywords = {
		"codecov": 'https://about.codecov.io/wp-content/themes/codecov/assets/brand/icons/codecov/codecov-circle.svg'
	};

	for(String k in keywords.keys.toList()){
		if(url.contains(k)){
			return Stack(
				children: [
					child,
					Positioned(
						top: 3,
						left: 5,
						height: 14,
						width: 14,
						child: SvgPicture.network(
							keywords[k]!,
							height: 14, width: 14,
						),
					)
				],
			);
		}
	}
	return null;
}



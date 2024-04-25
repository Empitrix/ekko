import 'dart:convert';
import 'dart:typed_data';
import 'package:ekko/markdown/image/extract.dart';
import 'package:ekko/markdown/image/from_local.dart';
import 'package:ekko/markdown/image/from_url.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';


enum ImageType {picture, svg}
enum ImageTypePath {online, local}



WidgetSpan showImageFrame(String txt, TapGestureRecognizer? recognizer, Map variables, [Map<String, dynamic> htmlData = const {}]){
	// Get Image Data (name, url, format[svg, picutre])
	Map<String, dynamic> data = htmlData.isNotEmpty ?
		htmlData :
		getImageLinkData(txt, variables);

	BoxFit? boxFit = BoxFit.fitWidth;

	// check for local file
	bool isLocalFile = !data['url']!.toString().contains(RegExp(r'http|https|www.'));

	Widget child = const SizedBox();

	if(isLocalFile){
		child = fromLocalImage(data, recognizer, boxFit);
	} else {
		child = fromUrlImage(data, recognizer, boxFit);
	}


	return WidgetSpan(
		child: Container(
			padding: const EdgeInsets.only(right: 5, bottom: 2),
			child: ClipRRect(
				child: child,
			)
		)
	);
}


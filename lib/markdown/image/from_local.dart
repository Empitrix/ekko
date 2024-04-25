
import 'dart:io';

import 'package:ekko/markdown/image/frame_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget fromLocalImage(Map<String, dynamic> data, TapGestureRecognizer? recognizer, BoxFit boxFit){
	File localImg = File(data['url']);
	Widget child = const SizedBox();
	if(localImg.existsSync()){
		if(data['format'] == ImageType.svg){
			child = SvgPicture.file(localImg);
		} else {
			child = Image.file(localImg);
		}
	}

	return MouseRegion(
		cursor: SystemMouseCursors.click,
		child: GestureDetector(
			child: child,
			onTap: (){
				// If image wraped in hyper-link it will open the link
				if(recognizer != null){
					recognizer.onTap!();
				}
			}
		)
	);
}

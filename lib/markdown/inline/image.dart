import 'package:ekko/markdown/image.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class InlineImage extends InlineModule {
	InlineImage(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		InlineSpan? outImg = runZoned((){
			return showImageFrame(txt, opt.recognizer, gOpt.variables);
		// ignore: deprecated_member_use
		}, onError: (e, s){
			debugPrint("ERROR on Loading: $e");
		});
		if(outImg != null){
			return outImg;
		}
		return TextSpan(text: txt);
	}
}


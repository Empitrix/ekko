import 'package:awesome_text_field/awesome_text_field.dart';
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

	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'\!\[([\s\S]*?)\](\(|\[)([\s\S]*?)(\)|\])'),
			style: const TextStyle(),
			action: (txt, match){
				TextStyle txtStyle = const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold);
				Match lastWhere = RegExp(r'(\)|\])(\(|\[)').allMatches(txt).last;
				List<TextSpan> parts = [];
				txt.substring(lastWhere.start).splitMapJoin(
					RegExp(r'(\(|\)|\[|\])'),
					onMatch: (Match m){
					parts.add(TextSpan(text: m.group(0)!, style: txtStyle));
						return "";
					},
					onNonMatch: (n){
						parts.add(TextSpan(text: n,
							style: const TextStyle(color: Colors.cyan,
						)));
						return "";
					}
				);
				return TextSpan(
					// style: Provider.of<ProviderManager>(context).defaultStyle,
					children: [
						TextSpan(text: txt.substring(0, 2), style: txtStyle),
						opts.reApply.parse(txt.substring(2, lastWhere.start)),
						...parts
					]
				);
			}
		);
	}
}


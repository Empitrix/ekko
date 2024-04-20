import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class InlineLink extends InlineModule {
	InlineLink(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		Match lastWhere = RegExp(r'(\)|\])(\(|\[)').allMatches(txt).last;
		String name = txt.substring(1, lastWhere.start);
		String link = txt.substring(lastWhere.end - 1);
		link = link.substring(1, link.length - 1);
		TextStyle linkStyle = const TextStyle(
			fontSize: 16,
			decorationColor: Colors.blue,
			color: Colors.blue);

		List<InlineSpan> spoon = [];
		TapGestureRecognizer rec = useLinkRecognizer(gOpt.context, link, gOpt.keyManager);

		List<InlineSpan> appliedRules = formattingTexts(
			content: name,
			gOpt: gOpt,
			recognizer: rec,
		).children!;

		for(InlineSpan span in appliedRules){
			if(span is TextSpan){
				if(span.children == null){
					// print(span.text);
					TextSpan collected = TextSpan(
						text: span.text,
						style: span.style,
						recognizer: rec 
					);
					spoon.add(collected);
					continue;
				}
			}
			spoon.add(span);
		}
		
		return TextSpan(
			children: spoon,
			recognizer: useLinkRecognizer(gOpt.context, link, gOpt.keyManager),
			style: linkStyle
		);
	}


	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'(?<!\!)\[((?:\[[^\]]*\]|[^\[\]])*)\]\(([\s\S]*?)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			style: const TextStyle(),
			action: (txt, match){
				TextStyle txtStyle = const TextStyle(color: Colors.blue);
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
							style: TextStyle(color: Colors.blue[700],
							decoration: TextDecoration.underline,
							decorationColor: Colors.blue[700])));
						return "";
					}
				);
				return TextSpan(
					// style: Provider.of<ProviderManager>(context).defaultStyle,
					children: [
						TextSpan(text: txt.substring(0, 1), style: txtStyle),
						opts.reApply.parse(txt.substring(1, lastWhere.start)),
						// TextSpan(text: txt.substring(1, lastWhere.start),
						// 	style: const TextStyle(color: Colors.white,
						// 	fontWeight: FontWeight.bold)),
						// // TextSpan(text: txt.substring(lastWhere.start), style: txtStyle),
						...parts
					]
				);
			}
		);
	}
}


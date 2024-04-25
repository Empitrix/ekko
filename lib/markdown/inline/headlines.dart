import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';


class InlineHeadline extends InlineModule {
	InlineHeadline(super.opt, super.gOpt);

	@override
	InlineSpan span(txt){
		txt = txt.trim();
		int sharpLength = RegExp(r'^\#{1,6}\s?').firstMatch(txt)!.group(0)!.trim().length;
		String content = txt.substring(sharpLength + 1);
		GlobalKey? headerKey = gOpt.keyManager.addNewKey(content);
		TextSpan span = TextSpan(
			text: content,
			style: getHeadlineStyle(gOpt.context, sharpLength)
		);
		if(sharpLength == 1 || sharpLength == 2){
			return WidgetSpan(
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						// ** GFM have this
						const SizedBox(width: double.infinity, height: 20),
						Text.rich(key: headerKey, TextSpan(children: [
							endLineChar(),
							span
						])),
						const Divider()
					],
				)
			);
		}
		return TextSpan(children: [
			WidgetSpan(child: Text.rich(key: headerKey, span)),
			const TextSpan(text: "\n")
		]);
	}



	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexGroupStyle(
			regex: RegExp(r'^#{1,6} [\s\S]*?$'),
			style: const TextStyle(fontWeight: FontWeight.bold),
			regexStyle: RegexStyle(
				regex: RegExp(r'^\#{1,6}\s?'),
				style: const TextStyle(
					color: Colors.red,
					fontWeight: FontWeight.bold
				),
			)
		);
	}
}


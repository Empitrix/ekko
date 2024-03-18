import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';


class InlineHeadline extends InlineModule {
	InlineHeadline(super.text, super.opt, super.gOpt);

	@override
	InlineSpan span() {
		String txt = text.trim();
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
		// return super.span();
	}
}


import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InlineHeaderLine extends InlineModule {
	InlineHeaderLine(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		List<String> header = txt.split("\n");
		if(header.length != 2){
			return TextSpan(text: txt, style: Provider.of<ProviderManager>(gOpt.context).defaultStyle);
		}

		// you can skip this (not rocommanded for global key detection)
		if(header.first.trim().isEmpty){
			return TextSpan(text: txt, style: Provider.of<ProviderManager>(gOpt.context).defaultStyle);
		}

		bool levlOne = header.last.replaceAll("=", "").isEmpty;
		GlobalKey? headerKey = gOpt.keyManager.addNewKey(header.first);

		return WidgetSpan(
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(header.first, style: getHeadlineStyle(gOpt.context, levlOne ? 1 : 2), key: headerKey,),
					const Divider()
				],
			)
		);
	}

	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'.+\n(\=+|\-+)(?=\s$|$)'),
			style: const TextStyle(),
			action: (txt, match){
				List<InlineSpan> spans = [];
				List<String> header = txt.split("\n");
				if(header.length != 2 || header.last.length.isOdd){
					return TextSpan(text: txt);
				}
				bool levlOne = header.last.replaceAll("=", "").isEmpty;
				spans.add(TextSpan(text: header.first, style: const TextStyle(fontWeight: FontWeight.bold)));
				spans.add(const TextSpan(text: "\n"));
				spans.add(TextSpan(text: header.last, style: TextStyle(color: levlOne ? Colors.red : Colors.blue, fontWeight: FontWeight.bold)));
				return TextSpan(children: spans);
			}
		);
	}
}

import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';


class InlineEmoji extends InlineModule{
	InlineEmoji(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return WidgetSpan(
			child: FutureBuilder(
				future: DefaultAssetBundle.of(gOpt.context)
					.loadString('assets/gemoji/data.json'),
				builder: (context, AsyncSnapshot<String> data){
					if(data.hasData){
						List<Map<String, dynamic>> emojies =
							List<Map<String, dynamic>>
							.from(json.decode(data.data!)['emoji']);
						String selected = parseEmojiString(txt, emojies);
						return Text.rich(TextSpan(
							text: selected,
							style: Provider.of<ProviderManager>(context).defaultStyle));
					} else {
						return const SizedBox();
					}
				},
			)
		);
	}


	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexGroupStyle(
			regex: RegExp(r'\:\w+\:'),
			style: const TextStyle(color: Color(0xff94b2e3)),
			regexStyle: RegexStyle(
				regex: RegExp(r':'),
				style: const TextStyle(
					color: Colors.orange,
				),
			)
		);
	}
}


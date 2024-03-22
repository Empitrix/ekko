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
}


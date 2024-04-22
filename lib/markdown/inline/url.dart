import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class InlineURL extends InlineModule{
	InlineURL(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return TextSpan(
			text: txt,
			style: Provider.of<ProviderManager>(gOpt.context).defaultStyle.copyWith(
				decorationColor: Colors.blue,
				decoration: TextDecoration.underline,
				color: Colors.blue
			),
			recognizer: useLinkRecognizer(
				gOpt.context, txt, gOpt.keyManager),
		);
	}



	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexFormattingStyle(
			regex: RegExp(r'(https\:|http\:|www)(\/\/|\.)([A-Za-z0-9@:%\.\_\+\~\#\=\/\?\-\&]*)'),
			style: const TextStyle(
				color: Colors.blue,
				decorationColor: Colors.blue,
				decoration: TextDecoration.underline)
		);
	}
}


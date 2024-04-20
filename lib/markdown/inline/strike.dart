import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';

class InlineStrike extends InlineModule {
	InlineStrike(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return TextSpan(
			text: txt.substring(2, txt.length - 2),
			recognizer: opt.recognizer,
			style: TextStyle(
				fontSize: 16,
				decorationColor: Theme.of(gOpt.context).colorScheme.inverseSurface,
				decorationStyle: TextDecorationStyle.solid,
				decoration: TextDecoration.lineThrough
			)
		);
	}



	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexFormattingStyle(
			regex: RegExp(r'~~.*~~'),
			style: TextStyle(
				decoration: TextDecoration.lineThrough,
				decorationColor: Theme.of(opts.context).colorScheme.inverseSurface
			)
		);
	}
}

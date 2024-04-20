import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/components/divider.dart';
import 'package:ekko/markdown/filed_rules.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';


class InlineDivder extends InlineModule {
	InlineDivder(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return const WidgetSpan(
			child: DividerLine(height: 3, lineSide: LineSide.none)
		);
	}


	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexFormattingStyle(
			regex: RegExp(r'^(\-\-\-|\+\+\+|\*\*\*)$'),
			style: const TextStyle(color: Colors.red),
		);
	}
}


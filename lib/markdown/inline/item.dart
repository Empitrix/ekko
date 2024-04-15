import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parser.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:flutter/material.dart';


class InlineItem extends InlineModule {
	InlineItem(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		txt = txt.replaceAll(RegExp(r'\n( )*', multiLine: true), "");

		// int iLvl = getIndentationLevel(txt);
		// int step = iLvl - lastIndent;
		// if(step != 0){
		// 	if(step < 0 && step != -1){
		// 		step ++;
		// 	}
		// 	if(step > 0 && step != 1){
		// 		step --;
		// 	}
		// }
		// indentStep += step;

		// if(iLvl != lastIndent){ lastIndent = iLvl; }
		getIlvl(txt);

		return WidgetSpan(
			child: SublistWidget(
				leading: Icon(
					indentStep == 0 ? Icons.circle:
					indentStep == 1 ? Icons.circle_outlined:
					Icons.square,
					size: 8,
				),
				indentation: indentStep * 20,
				data: TextSpan(
					children: [formattingTexts(
						gOpt: gOpt,
						content: txt.trim().substring(1).trim(),
					)]
				) 
			)
		);
	}
}


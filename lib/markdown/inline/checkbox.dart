import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parser.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';

class InlineCheckbox extends InlineModule {
	InlineCheckbox(super.opt, super.gOpt);

	@override
	InlineSpan span(txt){
		// bool isChecked = txt.trim().substring(0, 5).contains("x");

		getIlvl(txt);

		bool isChecked = txt.trim().substring(0, 5).contains("x");
		TextSpan textData = TextSpan(
			children: [formattingTexts(
				content: txt.trim().substring(5).trim(),  // Rm <whitespaces>
				gOpt: gOpt
			)]
		); 

		if(!checkListCheckable){
			return WidgetSpan(
				child: SublistWidget(
					indentation: indentStep * 20,
					type: SublistWidgetType.widget,
					leading: SizedBox(
						width: 18,
						height: 0,
						child: Transform.scale(
							scale: 0.8,
							child: IgnorePointer(
								child: Checkbox(
									value: isChecked,
									onChanged: null
								),
							),
						),
					),
					data: textData
				)
			);
		}
		
		return WidgetSpan(
			child: SublistWidget(
				iconHasAction: true,
				indentation: indentStep * 20,
				leadingOnTap: () async {
					DB db = DB();
					Note cn = await db.loadThisNote(opt.id);
					int start = opt.match.start + afterWhiteChar(
						cn.content.substring(opt.match.start, opt.match.end));
					String l = cn.content.substring(start + 3, start + 4);
					if(l == "x"){
						cn.content = cn.content.replaceRange(start + 3, start + 4, " ");
					} else {
						cn.content = cn.content.replaceRange(start + 3, start + 4, "x");
					}
					await db.updateNote(cn);
					gOpt.hotRefresh();
				},
				type: SublistWidgetType.icon,
				leading: MouseRegion(
					cursor: SystemMouseCursors.click,
					child: SizedBox(
						width: 18,
						height: 10,
						child: Transform.scale(
							// scale: 0.90,
							scale: 0.95,
							child: Checkbox(
								value: isChecked,
								onChanged: null
							),
						)
					)
				),
				data: textData 
			)
		);
	}



	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r"^\s*(-|\*|\+)\s{1}\[(\s{1}|\x)\]\s{1}"),
			style: const TextStyle(),
			action: (txt, match){
				int openingIdx = txt.split("").indexOf("[") + 1; 
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, openingIdx),
							style: const TextStyle(color: Colors.orange)),
						TextSpan(text: txt.substring(openingIdx, openingIdx + 1),
							style: const TextStyle(
								color: Colors.cyan, fontWeight: FontWeight.bold)),
						TextSpan(
							text: txt.substring(openingIdx + 1),
							style: const TextStyle(color: Colors.orange)),
					],
				);
			},
		);
	}
}


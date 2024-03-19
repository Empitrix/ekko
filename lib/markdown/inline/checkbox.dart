import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';

class InlineCheckbox extends InlineModule {
	InlineCheckbox(super.opt, super.gOpt);

	@override
	InlineSpan span(txt){
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
				leadingOnTap: () async {
					Note current = await DB().loadThisNote(opt.id);
					// debugPrint(current.content.substring(nm.match.start, nm.match.end));
					String l = current.content.substring(opt.match.start + 3, opt.match.start + 4);
					if(l == "x"){
						current.content = current.content.replaceRange(opt.match.start + 3, opt.match.start + 4, " ");
					} else {
						current.content = current.content.replaceRange(opt.match.start + 3, opt.match.start + 4, "x");
					}
					// debugPrint(current.content.substring(nm.match.start, nm.match.end));
					await DB().updateNote(current);
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
}


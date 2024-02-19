import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';

class CheckBoxSubList extends StatelessWidget {
	final String txt;
	final Function hotRefresh;
	final Map variables;
	final int noteId;
	final RuleOption nm;

	const CheckBoxSubList({
		super.key,
		required this.txt,
		required this.hotRefresh,
		required this.noteId,
		required this.variables,
		required this.nm
	});

	@override
	Widget build(BuildContext context) {
		bool isChecked = txt.trim().substring(0, 5).contains("x");
		TextSpan textData = TextSpan(
			children: [formattingTexts(
				context: context,
				variables: variables,
				id: noteId,
				hotRefresh: hotRefresh,
				content: txt.trim().substring(5).trim(),  // Rm <whitespaces>
			)]
		); 

		if(!checkListCheckable){
			return SublistWidget(
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
			);
		}
		
		return SublistWidget(
			iconHasAction: true,
			leadingOnTap: () async {
				Note current = await DB().loadThisNote(nm.id);
				// debugPrint(current.content.substring(nm.match.start, nm.match.end));
				String l = current.content.substring(nm.match.start + 3, nm.match.start + 4);
				if(l == "x"){
					current.content = current.content.replaceRange(nm.match.start + 3, nm.match.start + 4, " ");
				} else {
					current.content = current.content.replaceRange(nm.match.start + 3, nm.match.start + 4, "x");
				}
				// debugPrint(current.content.substring(nm.match.start, nm.match.end));
				await DB().updateNote(current);
				hotRefresh();
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
		);
	}
}


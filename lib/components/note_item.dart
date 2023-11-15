import 'package:ekko/config/navigator.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/modify_page.dart';
import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
	final SmallNote note;
	final Function backLoad;
	
	const NoteItem({
		super.key,
		required this.note,
		required this.backLoad
	});

	@override
	Widget build(BuildContext context) {
		if(!note.isVisible){
			return Container();
		}
		return InkWell(
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
				child: Row(
					children: [
						IconButton(
							icon: const Icon(Icons.edit),
							color: Theme.of(context).primaryColor,
							onPressed: (){
								changeView(
									context,
									ModifyPage(note: note, backLoad: backLoad),
									isPush: true
								);
							}
						),
						const SizedBox(width: 12),
						Expanded(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										note.title,
										overflow: TextOverflow.ellipsis,
										style: TextStyle(
											fontSize: 16,
											color: Theme.of(context)
												.colorScheme
												.inverseSurface,
											fontWeight: FontWeight.bold,
										),
									),
									Text(
										note.description,
										overflow: TextOverflow.ellipsis,
										style: TextStyle(
											fontSize: 14,
											color: Theme.of(context)
												.colorScheme.
												inverseSurface
												.withOpacity(0.5)
										),
									),
								],
							)
						),
						const SizedBox(width: 12),
						IconButton(
							icon: Icon(noteModeIcon(note.mode)),
							color: Theme.of(context).primaryColor,
							onPressed: (){/* Note Actons */},
						),
					],
				),
			),
			onTap: (){/* Present the Note contents */},
		);
	}
}

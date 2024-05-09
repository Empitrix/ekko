import 'package:ekko/backend/ccb.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/blur/float_menu.dart';
import 'package:ekko/components/general_widgets.dart';
import 'package:ekko/components/tag.dart';
import 'package:ekko/io/md_file.dart';
import 'package:ekko/io/share_file.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void inViewNoteSheet({
	required BuildContext context,
	required Note note,
	}){
	showDialog(
		context: context,
		builder: (_){
			return FloatMenu(
				header: Column(
					children: [
						SelectionArea(child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								SheetText(
									text: Text(
										note.title,
										style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
											fontSize: 18,
											color: Theme.of(context).colorScheme.inverseSurface
										)
									),
								),
								Padding(
									padding: const EdgeInsets.symmetric(horizontal: 12),
									child: Wrap(
										children: [
											for(String tName in note.description.split("|")) if(tName.isNotEmpty) TextTag(
												tag: tName,
												isDense: true,
											)
										],
									),
								),
								/*
								SheetText(
									text: Text(
										[for(String i in note.description.split('|')) i].join(", "),
										style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
											fontSize: 16,
											color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5)
										)
									),
								)
								*/
							],
						))
					],
				),
				actions: [
					ListTile(
						leading: const Icon(FontAwesomeIcons.solidCopy, size: 20,),
						title: const Text("Copy"),
						onTap:(){
							Navigator.pop(context);
							CCB.copy(note.content);
							SNK(context).message(const Icon(Icons.copy_rounded), "Copied!");
						}
					),
					ListTile(
						leading: const Icon(FontAwesomeIcons.fileExport, size: 20,),
						title: const Text("Export"),
						onTap:() async {
							// SNK snk = SNK(context);
							Navigator.pop(_);
							await MDFile.write(context, note.content, note.title);
							// bool isDone = await MDFile.write(context, note.content, note.title);
							// if(isDone){
							// 	snk.message(
							// 		const Icon(Icons.file_open_rounded), "File Exported!");
							// } else {
							// 	snk.message(
							// 		const Icon(Icons.cancel), "Faield To Export!");
							// }
						}
					),

					ListTile(
						leading: const Icon(FontAwesomeIcons.share, size: 20),
						title: const Text("Share"),
						onTap:() async {
							Navigator.pop(context);
							ShareNoteObj sharedNote = ShareNoteObj(context: context, note: note);
							await sharedNote.share();
						}
					),


				],
			);
		},
	);
}

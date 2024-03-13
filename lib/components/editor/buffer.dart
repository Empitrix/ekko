import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class EditorBuffer extends StatelessWidget {
	final TextEditingController controller;
	final LineStatus lineStatus;
	final SmallNote? note;
	final int folderId;
	final double lessOpt;
	const EditorBuffer({
		super.key,
		required this.controller,
		required this.lineStatus,
		this.lessOpt = -0.5,
		this.note,
		required this.folderId,
	});

	@override
	Widget build(BuildContext context) {
		return Row(
			children: [
				Expanded(
					child: Container(
						height: 20,
						color: Theme.of(context).colorScheme.secondaryContainer.aae(context, lessOpt),
						child: Row(
							children: [ const SizedBox(width: 12),
								FutureBuilder(
									future: DB().loadThisFolder(id: folderId),
									builder: (context, AsyncSnapshot<Folder> folder){
										if(folder.data != null){
											if(folder.data!.info().name == "~"){
												return const Text("~ (ROOT)");
											}
											return Text("/${folder.data!.info().name}");
										} else {
											return const Text("");
										}
									}
								),
								const SizedBox(width: 20),
								Text("Ln ${lineStatus.currentLine}, Col ${lineStatus.currentCol}"),
								const Expanded(child: SizedBox()),
								note != null ? FutureBuilder(
									future: DB().loadThisNote(note!.id),
									builder: (context, AsyncSnapshot<Note> note){
										if(!note.hasData){ return const Text("Indexing..."); }
										return Row(
											children: note.data!.content == controller.text ? [
												const Icon(Icons.circle, size: 10, color: Colors.green),
												const SizedBox(width: 5),
												const Text("Modified"),
											] : [
												const Icon(Icons.circle, size: 10, color: Colors.red),
												const SizedBox(width: 5),
												const Text("Not Modified"),
											],
										);
									}
								): const Text("NOT SAVED"),
								const SizedBox(width: 12),
							],
						),
					),
				)
			],
		);
	}
}


import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
// import 'dart:core' show abs;


class EditorBuffer extends StatelessWidget {
	final TextEditingController controller;
	final LineStatus lineStatus;
	final SmallNote? note;
	final int folderId;
	const EditorBuffer({
		super.key,
		required this.controller,
		required this.lineStatus,
		this.note,
		required this.folderId,
	});

	@override
	Widget build(BuildContext context) {


		int extendedCol = 0;
		// Try is because that if user change the text so fast don't cause any err
		try{
			// Calculate current column in line
			extendedCol = controller.value.selection.baseOffset;
			int a = controller.text.split("\n").sublist(0, lineStatus.currentLine).join("\n").length;
			int b = controller.text.split("\n")[lineStatus.currentLine - 1].length;
			extendedCol = extendedCol - (a - b);
		} catch(_){}
		if(extendedCol < 0){ extendedCol = 0; }


		return Row(
			children: [
				Expanded(
					child: Container(
						height: 20,
						color: Theme.of(context).colorScheme.secondaryContainer,
						child: Row(
							children: [ const SizedBox(width: 12),
								// const Text("~/Folder"),
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
								Text("Ln ${lineStatus.currentLine}, Col $extendedCol"),
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


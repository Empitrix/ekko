import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';


class BufferMsg{
	final String message;
	final Color color;

	BufferMsg({
		required this.message,
		required this.color
	});
}


class EditorBuffer extends StatelessWidget {
	final TextEditingController controller;
	final LineStatus lineStatus;
	final SmallNote? note;
	final int folderId;
	final double lessOpt;
	final ValueNotifier<BufferMsg> msg;

	const EditorBuffer({
		super.key,
		required this.controller,
		required this.lineStatus,
		required this.msg,
		this.lessOpt = -0.5,
		this.note,
		required this.folderId,
	});

	@override
	Widget build(BuildContext context) {
		return Row(
			children: [
				ValueListenableBuilder(
					valueListenable: msg,
					builder: (context, bmsg, child){
						if(bmsg.message == ""){
							return const SizedBox();
						}
						return Container(
							color: bmsg.color,
							child: Text(" ${bmsg.message} ",
								style: const TextStyle(color: Colors.black)),
						);
					}
				),
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
												const Text("Saved"),
											] : [
												const Icon(Icons.circle, size: 10, color: Colors.red),
												const SizedBox(width: 5),
												const Text("Not Saved"),
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


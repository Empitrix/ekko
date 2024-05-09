import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/sheets/show.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/io/md_file.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';


void generalSmallNoteSheet({
	required BuildContext context,
	required Function load,
	required SmallNote note}){
	showSheet(
		context: context,
		builder: (BuildContext ctx) => SizedBox(
			width: MediaQuery.of(ctx).size.width,
			child: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Container(
							width: double.infinity,
							margin: const EdgeInsets.symmetric(horizontal: 16),
							child: Text(
								note.title,
								style: Theme.of(ctx).primaryTextTheme.titleLarge!.copyWith(
									color: Theme.of(ctx).colorScheme.inverseSurface
								)
							),
						),
						Container(
							width: double.infinity,
							margin: const EdgeInsets.symmetric(horizontal: 12),
							child: const Divider(),
						),

						// Delete
						ListTile(
							leading: const Icon(
								Icons.delete, color: Colors.red),
							title: const Text("Delete",
								style: TextStyle(color: Colors.red)),
							onTap: (){
								Navigator.pop(ctx); // close current 
								Dialogs(ctx).ask(
									title: "Delete",
									content: "Did you want to delete this item?",
									action: () async {
										await DB().deleteNote(note.id);
										load(); // load again
									}
								);
							}
						),


						ListTile(
							// leading: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin),
							leading: Transform.rotate(
								angle: note.isPinned ? getAngle(45) : 0,
								child: const Icon(Icons.push_pin)
							), 
							title: Text(note.isPinned ? "Unpin" : "Pin"),
							onTap: () async {
								Navigator.pop(ctx);
								Note rNote = await note.toRealNote();
								rNote.isPinned = !rNote.isPinned;
								await DB().updateNote(rNote);
								load(); // load again
							}
						),

						ListTile(
							leading: const Icon(Icons.move_to_inbox), 
							trailing: const Icon(Icons.arrow_right), 
							title: const Text("Move to another folder"),
							onTap: () async {
								Navigator.pop(ctx);
								selectFolderSheet(
									context: ctx,
									noteFolderId: note.folderId,
									action: (BuildContext context, FolderInfo folder) async {
										SNK snk = SNK(context, duration: const Duration(seconds: 2));
										Note newNote = await note.toRealNote();
										newNote.folderId = folder.id;
										await DB().addNote(newNote);
										snk.message(
											const Icon(Icons.create_new_folder),
											"Added to: ${folder.name}");
										// Don't need >load();< because nothing will change in current folder
										// load(); // load again
									}
								);
							}
						),


						ListTile(
							leading: const Icon(Icons.file_open_rounded),
							title: const Text("Export Markdown"),
							onTap: () async {
								// SNK snk = SNK(context);
								Navigator.pop(ctx);
								Note realNote = await note.toRealNote();
								// ignore: use_build_context_synchronously
								await MDFile.write(context, realNote.content, realNote.title);
								// bool isDone = await MDFile.write(context, realNote.content, realNote.title);
								// if(isDone){
								// 	snk.message(
								// 		const Icon(Icons.file_open_rounded), "File Exported!");
								// } else {
								// 	snk.message(
								// 		const Icon(Icons.cancel), "Faield To Export!");
								// }
							}
						),

						// Footer
						const SizedBox(height: 12)
					],
				),
			),
		)
	);
}




typedef ContextFolderInfoAction = Function(BuildContext context, FolderInfo);

void selectFolderSheet({
	required BuildContext context,
	required int noteFolderId,
	required ContextFolderInfoAction action
	}){
	// Start future can't be inside builder because will start again
	Future<List<FolderInfo>> listFuture = DB().loadFoldersInfo();
	showSheet(
		context: context,
		builder: (context){
			return FutureBuilder<List<FolderInfo>>(
				future: listFuture,
				builder: (context, snapshot){
					if(snapshot.connectionState != ConnectionState.done){
						return const Center(child: CircularProgressIndicator());}

					if(snapshot.data!.length == 1){
						return const Center(child: Text("No Folder"));}

					return ListView.builder(
						itemCount: snapshot.data!.length,
						itemBuilder: (BuildContext context, int index) => ListTile(
							leading: const Icon(Icons.folder),
							iconColor: snapshot.data![index].id == 0 ? Colors.orange : null,
							title: Text(snapshot.data![index].name),
							enabled: noteFolderId != snapshot.data![index].id,
							onTap: (){
								action(context, snapshot.data![index]);
								Navigator.pop(context);
							},
						)
					);
				}
			);
		}
	);
}


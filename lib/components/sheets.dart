import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/ccb.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/general_widgets.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/io/md_file.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:ekko/models/folder.dart';
import 'package:flutter/material.dart';
import 'package:ekko/models/note.dart';


// Custom context builder
typedef ContextBuilder = Widget Function(BuildContext context);

// Apply options for any sheet via show function
void _showSheet({
	required BuildContext context, required ContextBuilder builder}){
	showModalBottomSheet(
		context: context,
		showDragHandle: true,
		shape: const RoundedRectangleBorder(
			borderRadius: BorderRadius.only(
				topRight: Radius.circular(12),
				topLeft: Radius.circular(12),
			)
		),
		builder: builder
	);
}


void generalSmallNoteSheet({
	required BuildContext context,
	required Function load,
	required SmallNote note}){
	_showSheet(
		context: context,
		builder: (BuildContext context) => SizedBox(
			width: MediaQuery.of(context).size.width,
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
								style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
									color: Theme.of(context).colorScheme.inverseSurface
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
								Navigator.pop(context); // close current 
								Dialogs(context).ask(
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
								Navigator.pop(context);
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
								Navigator.pop(context);
								selectFolderSheet(
									context: context,
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
								SNK snk = SNK(context);
								Note realNote = await note.toRealNote();
								await MDFile.write(realNote.content);
								snk.message(
									const Icon(Icons.file_open_rounded), "File Exported!");
								// ignore: use_build_context_synchronously
								Navigator.pop(context);
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
	_showSheet(
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
							// onTap: () => action(snapshot.data![index]),
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



void generalFolderSheet({
	required BuildContext context,
	required Function load,
	required Folder folder}){
	_showSheet(
		context: context,
		builder: (BuildContext context) => SizedBox(
			width: MediaQuery.of(context).size.width,
			child: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Container(
							width: double.infinity,
							margin: const EdgeInsets.symmetric(horizontal: 16),
							child: Text(
								folder.name,
								style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
									color: Theme.of(context).colorScheme.inverseSurface
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
								Navigator.pop(context); // close current 
								Dialogs(context).ask(
									title: "Delete",
									content: "Did you want to delete this item?",
									action: () async {
										await DB().deleteFolder(folderId: folder.id);
										load(); // load again
									}
								);
							}
						),


						// Rename
						ListTile(
							leading: const Icon(Icons.edit),
							title: const Text("Rename"),
							onTap: (){
								Navigator.pop(context); // close current 
								Dialogs(context).textFieldDialog(
									title: "New Name",
									hint: "Name",
									loadedText: folder.name,
									action: (String newName) async {
										await DB().renameFolder(folderId: folder.id, newName: newName);
										load(); // load again
									}
								);
							}
						),
						const SizedBox(height: 12)
					],
				),
			),
		)
	);
}





void selectMarkdownTheme({
	required BuildContext context,
	required ValueChanged<String> onSelect,
	}){
	_showSheet(
		context: context,
		builder: (BuildContext context) => SizedBox(
			width: MediaQuery.of(context).size.width,
			child: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						for(String name in allMarkdownThemes.keys)  ListTile(
							leading: TwoColorPalette(
								baseColor: allMarkdownThemes[name]!["root"]!.backgroundColor,
								borderColor: allMarkdownThemes[name]!["meta"]!.color!
							),
							title: Text(
								name.replaceAll("-", " ").title()),
							trailing: markdownThemeName == name ?
								const Icon(Icons.check) :
								null,
							onTap: (){
								Navigator.pop(context);
								onSelect(name);
							},
						),
						const SizedBox(height: 12)
					],
				),
			),
		)
	);
}





void inViewNoteSheet({
	required BuildContext context,
	required Note note,
	}){
	_showSheet(
		context: context,
		builder: (BuildContext context) => SizedBox(
			width: MediaQuery.of(context).size.width,
			child: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						SheetText(
							text: SelectableText(
								note.title,
								style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
									color: Theme.of(context).colorScheme.inverseSurface
								)
							),
						),
						SheetText(
							text: SelectableText(
								note.description,
								style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
									color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5)
								)
							),
						),
						const SizedBox(height: 10),
						const Divider(),
						const SizedBox(height: 10),
						ListTile(
							leading: const Icon(Icons.copy),
							title: const Text("Copy"),
							onTap:(){
								Navigator.pop(context);
								CCB.copy(note.content);
								SNK(context).message(const Icon(Icons.copy), "Copied!");
							}
						),
						const SizedBox(height: 12)
					],
				),
			),
		)
	);
}


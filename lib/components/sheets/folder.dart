import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/sheets/show.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/folder.dart';
import 'package:flutter/material.dart';


void generalFolderSheet({
	required BuildContext context,
	required Function load,
	required Folder folder}){
	showSheet(
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

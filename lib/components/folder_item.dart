import 'package:ekko/models/folder.dart';
import 'package:flutter/material.dart';

Widget folderItem({
	required BuildContext context,
	required Folder folder,
	required Function update 

	}){ return ListTile(
		leading: const Icon(Icons.folder, size: 34),
		dense: true,
		title: Text(folder.name),
		subtitle: folder.notes.isNotEmpty ?
			Text('${folder.notes.length} Item${folder.notes.length > 1 ? "s" : ""}'):
			const Text("No Item"),
		onTap:(){}
	);
}


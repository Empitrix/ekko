import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/views/land_page.dart';
import 'package:flutter/material.dart';

Widget folderItem({
	required BuildContext context,
	required Folder folder,
	required Function update 

	}){

	void longAction(){
		// NO ACTION FOR ROOT FOLDER
		if(folder.id == 0){ return; }  

		// Show general-dialog
		generalFolderSheet(
			context: context,
			load: update,
			folder: folder
		);
	}

	return Listener(
		onPointerDown: (pointer){
			if(pointer.buttons == 2 && isDesktop()){
				longAction();
			}
		},
		child: ListTile(
			leading: Icon(
				Icons.folder,
				color: folder.id != 0 ? Theme.of(context).colorScheme
					.surfaceTint.withAlpha(dMode ? 255:200): Colors.orange,
				size: 34
			),
			dense: true,
			title: Text(
				folder.name,
				overflow: TextOverflow.ellipsis,
				style: TextStyle(
					fontSize: 14,
					letterSpacing: letterSpacing,
					color: Theme.of(context)
						.colorScheme
						.inverseSurface,
					fontWeight: FontWeight.bold,
				),
			),
			subtitle: folder.notes.isNotEmpty ?
				Text('${folder.notes.length} Item${folder.notes.length > 1 ? "s" : ""}'):
				const Text("No Item"),
			onTap:(){
				changeView(
					context,
					LandPage(folderId: folder.id),
					isPush: true,
					isReplace: true
				);
			},
			onLongPress: isDesktop() ? null : longAction 
		),
	);
}


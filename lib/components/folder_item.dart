import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/models/folder.dart';
import 'package:flutter/material.dart';

Widget folderItem({
	required BuildContext context,
	required Folder folder,
	required Function update 

	}){ return Listener(
		onPointerDown: (pointer){
			if(pointer.buttons == 2 && isDesktop()){

			}
		},
		child: ListTile(
			leading: Icon(
				Icons.folder,
				color: Theme.of(context).colorScheme
					.surfaceTint.withAlpha(dMode ? 255:200),
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
			onTap:(){},
			onLongPress: isDesktop() ? (){} : null 
		),
	);
}


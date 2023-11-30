import 'package:ekko/components/dialogs.dart';
import 'package:ekko/database/database.dart';
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
						// Text(
						// 	"    ${note.title}",
						// 	style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
						// 		color: Theme.of(context).colorScheme.inverseSurface
						// 	)
						// ),
						Container(
							width: double.infinity,
							margin: const EdgeInsets.symmetric(horizontal: 12),
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
						// Sheet items
						ListTile(
							leading: const Icon(Icons.delete),
							title: const Text("Delete"),
							onTap: (){
								Navigator.pop(context); // close current 
								Dialogs(context).askDialog(
									title: "Delete",
									content: "Did you want to delete this item?",
									action: () async {
										await DB().deleteNote(note.id);
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


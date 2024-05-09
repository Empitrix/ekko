import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/blur/float_menu.dart';
import 'package:ekko/components/nf_icons.dart';
import 'package:ekko/components/sheets/select.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/utils/modes.dart';
import 'package:flutter/material.dart';


void inModifySheet({
	required BuildContext context,
	required bool editMode,
	required NoteMode mode,
	required void Function() onSubmit,
	required void Function() onImport,
	required Function(NoteMode) onModeChange
}){

	void act(Function action){
		Navigator.pop(context);
		action();
	}

	showDialog(
		context: context,
		builder: (_){
			return FloatMenu(
				// header: ,
				actions: [
					ListTile(
						leading: Icon(editMode ? Icons.edit : Icons.check, color: Colors.blue),
						title: Text(editMode ? "Edit" : "Save",
							style: const TextStyle(color: Colors.blue)),
						onTap: () => act(onSubmit)
					),
					ListTile(
						leading: NfFont(unicode: '\u2009\ue27d', size: 20).widget(),
						title: const Text("Import"),
						onTap:() => act(onImport)
					),
					ListTile(
						leading: NfFont(unicode: '\u2009\udb85\udc0b', size: 23).widget(),
						title: const Text("Set mode"),
						onTap:(){
							Navigator.pop(context);
							selectSheet(
								context: context,
								items: [
									for(NoteMode m in NoteMode.values) ListTile(
										leading: Icon(modeIcon(m)),
										title: Text(m.name.title()),
										trailing: m == mode ? const Icon(Icons.check) : null,
										onTap: (){
											Navigator.pop(context);
											onModeChange(m);
										},
									)
								] 
							);
						}
					),
				],
			);
		},
	);
}

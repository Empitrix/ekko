import 'dart:io';
import 'package:ekko/components/dialogs.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ekko/io/note_io.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ShareNoteObj{
	final BuildContext context;
	final Note note;

	ShareNoteObj({
		required this.context,
		required this.note
	});


	Future<void> share() async {
		Dialogs dialogs = Dialogs(context);
		String tempDirPath = (await getTemporaryDirectory()).absolute.path;
		debugPrint(tempDirPath);
		NoteIO noteIO = NoteIO(note: note);
		File mdFile = await noteIO.write(tempDirPath);
		debugPrint(mdFile.readAsStringSync());


		final ShareResult shareResult = await Share.shareXFiles(
			[XFile(mdFile.absolute.path)], text: note.title);

		if (shareResult.status == ShareResultStatus.success) {
			debugPrint("NICE!");
		} else {
			dialogs.okDialog("Failed", "Failed to share the file");
		}

		// Clean-up
		if(mdFile.existsSync()){ mdFile.deleteSync(); }

	}

}

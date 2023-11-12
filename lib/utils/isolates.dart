import 'package:ekko/models/note.dart';
import 'package:ekko/utils/loading.dart';
import 'dart:isolate';


class IsoImportNote {
	final SendPort port;
	final SmallNote note;
	
	IsoImportNote({
		required this.port,
		required this.note
	});
}

// Future<void> loadImportedNote(SendPort port, SmallNote note) async {
Future<void> loadImportedNote(IsoImportNote input) async {
	// RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
	// BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
	await updateDbPath();
	Note toNote = await input.note.toRealNote();
	input.port.send(LoadedNote(
		title: toNote.title,
		description: toNote.description,
		content: toNote.content,
		mode: toNote.mode,
		isPinned: toNote.isPinned
	));
	return;
}

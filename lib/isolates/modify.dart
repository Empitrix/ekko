import 'dart:isolate';
import 'package:ekko/config/public.dart';
import 'package:ekko/models/note.dart';


class ImportedToModify {
	final String path;
	final SendPort port;
	final SmallNote smallNote;
	ImportedToModify({
		required this.path,
		required this.port,
		required this.smallNote,
	});
}


Future<void> __loadModifyNote(ImportedToModify iso) async {
	Note loaded = await iso.smallNote.toRealNote(iso.path);
	iso.port.send(loaded);
}


Future<ReceivePort> loadModifyWithIsolates({required SmallNote note}) async {
	ReceivePort receivePort = ReceivePort();
	Isolate thisIso = await Isolate.spawn<ImportedToModify>(
		__loadModifyNote,
		ImportedToModify(
			path: dbPath,
			port: receivePort.sendPort,
			smallNote: note,
		)
	);
	thisIso.kill();
	return receivePort;
}


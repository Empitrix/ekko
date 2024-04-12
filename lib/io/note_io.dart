import 'dart:io';

import 'package:ekko/io/path_routing.dart';
import 'package:ekko/models/note.dart';
import 'package:path/path.dart' as path;


class NoteIO{
	final Note note;
	NoteIO({required this.note});

	Future<File> write(String dirPath) async {
		Directory dir = Directory(dirPath);
		if(!(await dir.exists())){ await dir.createTemp(); }
		String fileName = formatLocalName(note.title).trim();
		fileName.replaceAll(RegExp(r'\. *md *$', multiLine: true), "");
		fileName += ".md";
		File mdFile = File(path.join(dirPath, fileName));
		await mdFile.writeAsString(note.content);
		return mdFile;
	}

}

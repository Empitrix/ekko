import 'dart:io';

class FileOut {
	final String name;
	final File file;

	FileOut({
		required this.name,
		required this.file
	});
}

class FileContentOut {
	final String name;
	final String content;

	FileContentOut({
		required this.name,
		required this.content
	});
}


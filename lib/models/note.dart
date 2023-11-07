import 'package:intl/intl.dart';

enum NoteMode {
	copy,
	web
}

String _parseMode(NoteMode mode){
	return mode
		.toString()
		.replaceAll("NoteMode.", "");
}

NoteMode _fromNode(String modeStr){
	switch(modeStr){
		case "copy":
			return NoteMode.copy;
		case "web":
			return NoteMode.web;
		default:
			return NoteMode.copy;
	}
}

String _parseDate(DateTime date) {
	final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
	return formatter.format(date);
}

DateTime _fromDate(String dateStr) {
	try {
		final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
		return formatter.parse(dateStr);
	} catch (e) {
		return DateTime.now();
	}
}



class Note {
	final String title;
	final String description;
	final String content;
	final DateTime lastEdit;
	final bool isPinned;
	final NoteMode mode;

	// Visuals
	final bool isSelected;
	final bool isVisible;

	Note({
		required this.title,
		required this.description,
		required this.content,
		required this.lastEdit,
		required this.isPinned,
		required this.mode,
		this.isSelected = false,
		this.isVisible = true
	});

	static toNote(Map input){
		return Note(
			title: input["title"],
			description: input["description"],
			content: input["content"],
			lastEdit: _fromDate(input["lastEdit"]),
			isPinned: input["isPinned"],
			mode: _fromNode(input["mode"])
		);
	}

	Map toJson(){
		return {
			"title": title,
			"description": description,
			"content": content,
			"lastEdit": _parseDate(lastEdit),
			"isPinned": isPinned,
			"mode": _parseMode(mode)
		};
	}
}

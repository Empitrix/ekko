import 'package:ekko/database/database.dart';
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
	final int id;
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
		required this.id,
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
			id: input["id"],
			title: input["title"],
			description: input["description"],
			content: input["content"],
			lastEdit: _fromDate(input["lastEdit"]),
			isPinned: input["isPinned"] == 1,  // get bit
			mode: _fromNode(input["mode"])
		);
	}

	Map toJson(){
		return {
			// "id": id,  // SQL will create a unique one
			"title": title,
			"description": description,
			"content": content,
			"lastEdit": _parseDate(lastEdit),
			"isPinned": isPinned ? 1 : 0,  // convert to bit
			"mode": _parseMode(mode)
		};
	}
}



// Lighter version of notes without contents
class SmallNote {
	final String title;
	final String subtitle;
	final int id;
	SmallNote({
		required this.title,
		required this.subtitle,
		required this.id
	});

	toJson(){
		return {
			"title": title,
			"subtitle": subtitle,
			"id": id
		};
	}

	Future<Note> toRealNote() async {
		return (await DB().loadThisNote(id));
	}

	static SmallNote toSmallNote(Map input){
		return SmallNote(
			title: input["title"],
			subtitle: input["subtitle"],
			id: input["id"]
		);
	}
}

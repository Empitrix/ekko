import 'package:ekko/backend/extensions.dart';
import 'package:ekko/database/database.dart';
import 'package:intl/intl.dart';


enum NoteMode {
	copy,
	web,
	markdown,
	plaintext
}


NoteMode _fromNode(String modeStr){
	for(NoteMode m in NoteMode.values){
		if(m.name.mini() == modeStr.mini()){
			return m;
		}
	}
	return NoteMode.markdown;
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
	late int folderId;
	final String title;
	final String description;
	late String content;  // late beacuse of the check-box
	final DateTime lastEdit;
	late bool isPinned;
	final NoteMode mode;

	// Visuals
	late bool isSelected;
	late bool isVisible;

	Note({
		required this.id,
		required this.folderId,
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
			folderId: input["folderId"],
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
			"title": title,
			"folderId": folderId,
			"description": description,
			"content": content,
			"lastEdit": _parseDate(lastEdit),
			"isPinned": isPinned ? 1 : 0,  // convert to bit
			"mode": mode.name
		};
	}
}



// Lighter version of notes without contents
class SmallNote {
	final int id;
	final int folderId;
	final String title;
	final String description;
	final DateTime lastEdit;
	late bool isPinned;
	final NoteMode mode;

	// Visuals
	late bool isSelected;
	late bool isVisible;

	SmallNote({
		required this.id,
		required this.folderId,
		required this.title,
		required this.description,
		required this.lastEdit,
		required this.isPinned,
		required this.mode,
		this.isSelected = false,
		this.isVisible = true
	});


	Future<Note> toRealNote([String? newPath]) async {
		return (await DB().loadThisNote(id, newPath));
	}

	static toSmallNote(Map input){
		return SmallNote(
			id: input["id"],
			folderId: input["folderId"],
			title: input["title"],
			description: input["description"],
			lastEdit: _fromDate(input["lastEdit"]),
			isPinned: input["isPinned"] == 1,  // get bit
			mode: _fromNode(input["mode"])
		);
	}

	Map toJson(){
		return {
			"title": title,
			"folderId": folderId,
			"description": description,
			"lastEdit": _parseDate(lastEdit),
			"isPinned": isPinned ? 1 : 0,  // convert to bit
			"mode": mode.name
		};
	}
}



class LoadedNote {
	final String title;
	final String description;
	final String content;
	final NoteMode mode;
	final bool isPinned;

	LoadedNote({
		required this.title,
		required this.description,
		required this.content,
		required this.mode,
		required this.isPinned
	});
}


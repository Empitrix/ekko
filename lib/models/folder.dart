import 'package:ekko/models/note.dart';


class Folder {
	final int id;
	late String name;
	final List<SmallNote> notes;
	late bool isSelected;  // Visual
	Folder({required this.id, required this.name, required this.notes, this.isSelected = false});


	Future<List<Note>> allNotes() async {
		/*Get all the notes as note with content (Heavy Note)*/
		List<Note> convert = [];
		for (SmallNote nt in notes){
			convert.add(await nt.toRealNote());
		}
		return convert;
	}

	Future<Map> toJson() async {
		/*Convert all the notes to JSON with content*/
		List<Map> convertedNotes = [];
		for (SmallNote nt in notes){
			convertedNotes.add((await nt.toRealNote()).toJson());
		}
		return {
			"name": name,
			"id": id,
			// "notes": convertedNotes,
			// "notes": List<Map<String, Object?>>.from(convertedNotes),
		};
	}

	FolderInfo info(){
		return FolderInfo(name: name, id: id);
	}

	static Folder toFolder({required Map input}){
		/*Get input JSON folder and return Folder type data*/
		List<SmallNote> convertedNotes = [];
		for(Map nt in input["notes"]){
			// convertedNotes.add(Note.toNote(nt));
			convertedNotes.add(SmallNote.toSmallNote(nt));
		}
		return Folder(
			id: input["id"],
			name: input["name"],
			notes: convertedNotes
		);
	}
}




class FolderInfo{
	final String name;
	final int id;
	FolderInfo({
		required this.name,
		required this.id
	});
}



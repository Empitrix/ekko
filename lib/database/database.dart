import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/models/enums.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ekko/database/dfi.dart';


class DB {
	final String? dPath;
	DB({this.dPath});
	Future<void> init() async {
		/* Initialized database */
		Database db = await createDB(dPath: dPath);
		await db.execute("""
			CREATE TABLE IF NOT EXISTS local (
				darkMode BIT,
				acrylicMode BIT,
				wrapCodeMode BIT,
				editorWrapMode BIT,
				checkableCheckList BIT,
				plainBionicMode BIT,
				acrylicOpacity FLOAT,
				fontFamily TEXT,
				plainFontFamily TEXT,
				fontSize FLOAT,
				tabSize INT,
				renderMode INT,
				fontWeight INT,
				fontHeight FLOAT,
				letterSpacing FLOAT,
				markdownThemeName TEXT
			)
		""");
		
		// FOLDERS
		await db.execute("""
			CREATE TABLE IF NOT EXISTS folders (
				id INTEGER PRIMARY KEY,
				name TEXT
			)
		""");

		await db.execute("""
			CREATE TABLE IF NOT EXISTS notes (
				id INTEGER PRIMARY KEY,
				title TEXT,
				description TEXT,
				content TEXT,
				lastEdit Text,
				isPinned BIT,
				mode Text,
				folderId INTEGER,
				FOREIGN KEY (folderId) REFERENCES folders(id)
			)
		""");

		Map<String, List> initData = {
			"darkMode": ["BIT", 1],
			"acrylicMode": ["BIT", 0],
			"wrapCodeMode": ["BIT", 0],
			"editorWrapMode" : ["BIT", 0],
			"checkableCheckList": ["BIT", 0],
			"plainBionicMode": ["BIT", 0],
			"acrylicOpacity": ["FLOAT", 1.0],
			"markdownThemeName": ["TEXT", "gruvbox-dark"],
			"fontFamily": ["TEXT", "Rubik"],
			"plainFontFamily": ["TEXT", "RobotoMono"],
			"fontSize": ["FLOAT", 16],
			"tabSize": ["INT", 2],
			"renderMode": ["INT", 0],
			"fontWeight": ["INT", 400],
			"fontHeight": ["FLOAT", 1.4],
			"letterSpacing": ["FLOAT", 0.7],
		};  // Init table

		// Map<String, Object?> extracted = initData.map((key, value) => MapEntry(key, value.last));
		// print(extracted);
		// print("0000");

		if(List.from(await db.query("local")).isEmpty){

			// Map<String, Object?> extracted = initData.map(convert);
			// print(extracted)
			// Set parameters on db 
			// await db.insert("local", initData);
			await db.insert("local", initData.map((key, value) => MapEntry(key, value.last)));
			
			await DB().createFolder(folderName: "~", isPrime: true);  // Root Folder

			debugPrint("[DATABASE INITIALIZED]");
		} else {
			// debugPrint(initData.toString());
			Map<String, Object?> fromLocal = (await db.query('local'))[0];
			for(String par in initData.keys.toList()){
				if(fromLocal[par] == null){
					// print(par);
					// print(initData[par].runtimeType);
					// debugPrint('''ALTER TABLE local ADD $par ${initData[par]!.last};''');
					// db.execute('''ALTER TABLE local ADD IF NOT EXISTS $par ${initData[par]!.first};''');
					// await db.execute('''ALTER TABLE local ADD COLUMN $par ${initData[par]!.first};''');
					try{
						await db.execute('''ALTER TABLE local ADD COLUMN $par ${initData[par]!.first} DEFAULT ${initData[par]!.last};''').then((_){});
					}catch(_){}
				}
			}

			debugPrint("[RUNNING DATABASE]");
		}
		await db.close();
	}


	// R/W/U for boolean variables
	Future<bool> readBool(String name) async {
		Map data = await getQuery("local");
		return data[name] == 1;
	}

	Future<void> writeBool(String name, bool value) async {
		await updateTable('local', {name: value ? 1 : 0});
	}


	Future<int> readInt(String name) async {
		Map data = await getQuery("local");
		return data[name] as int;
	}
	Future<void> writeInt(String name, int value) async {
		await updateTable('local', {name: value});
	}

	/* Acrylic Opacity */ 
	Future<double> readAcrylicOpacity() async {
		Map data = await getQuery("local");
		return data["acrylicOpacity"];
	}

	Future<void> updateAcrylicOpacity(double newValue) async {
		try{
			await updateTable('local',
				{"acrylicOpacity": newValue});
		}catch(_){/**/}
	}

	/* Notes CRUD */
	Future<void> addNote(Note note) async {
		Database db = await createDB(dPath: dPath);
		await db.insert(
			"notes",
			Map<String, Object?>.from(note.toJson())
		);
		await db.close();
	}

	Future<List<Note>> getNotes({required int folderId}) async {
		List<Note> other = [];
		List<Note> pinned = [];
		Database db = await createDB(dPath: dPath);
		List<Map<String, Object?>> data = await db.query("notes");
		for(Map note in data){
			if(note["folderId"] != folderId){ continue; }
			if(note["isPinned"] == 1){
				pinned.add(Note.toNote(note));
			} else {
				other.add(Note.toNote(note));
			}
		}
		await db.close();
		return [...pinned, ...other];
	}

	Future<List<SmallNote>> getSmallNotes({required int folderId}) async {
		List<SmallNote> otherNotes = [];
		List<SmallNote> pinnedNotes = [];
		Database db = await createDB(dPath: dPath);
		List<Map<String, Object?>> data = await db.query("notes");
		for(Map note in data){
			if(note["folderId"] != folderId){ continue; }
			if(note["isPinned"] == 1){
				pinnedNotes.add(SmallNote.toSmallNote(note));
			} else {
				otherNotes.add(SmallNote.toSmallNote(note));
			}
		}
		await db.close();
		return [...pinnedNotes, ...otherNotes];
	}

	Future<void> updateNote(Note newOne) async {
		Database db = await createDB(dPath: dPath);
		await db.update(
			'notes', 
			Map<String, Object?>.from(newOne.toJson()),
			where: "id = ?",
			whereArgs: [newOne.id]
		);
		await db.close();
	}

	Future<void> deleteNote(int noteId) async {
		Database db = await createDB(dPath: dPath);
		await db.delete(
			'notes',
			where: "id = ?",
			whereArgs: [noteId]
		);
		await db.close();
	}

	Future<Note> loadThisNote(int id, [String? newPath]) async {
		Database db = await createDB(dPath: newPath);
		List<Map> noteJson = await db.query(
			'notes',
			where: "id = ?",
			whereArgs: [id]
		);
		await db.close();
		return Note.toNote(noteJson.first);
	}


	/* FOLDER */
	Future<void> createFolder({required String folderName, bool isPrime = false}) async {
		Database db = await createDB(dPath: dPath);
		Map data = {"name": folderName};
		if(isPrime){ data["id"] = 0; }  // Check for prime folder
		await db.insert(
			"folders",
			Map<String, Object?>.from(data)
		);
		await db.close();
	}


	Future<void> deleteFolder({required int folderId}) async {
		/* Remove the folder if it's not the PRIME folder*/
		if(folderId == 0 ){ return; }
		
		// Delete all the folder's items
		List<Folder> folders = await DB().loadFolders();
		for(Folder f in folders){
			if(f.id == folderId){
				for(SmallNote n in f.notes){
					await DB().deleteNote(n.id);
				}
			}
		}
		
		Database db = await createDB(dPath: dPath);
		// Delete folder
		await db.delete(
			"folders",
			where: "id = ?",
			whereArgs: [folderId]
		);
		await db.close();
	}

	Future<void> renameFolder({required int folderId, required String newName}) async {
		Folder currentFolder = await loadThisFolder(id: folderId);
		currentFolder.name = newName;
		// Convert folder to json
		Map data = await currentFolder.toJson();
		
		Database db = await createDB(dPath: dPath);
		await db.update(
			'folders', 
			Map<String, Object?>.from(data),
			where: "id = ?",
			whereArgs: [folderId]
		);
		await db.close();
	}

	Future<Folder> loadThisFolder({required int id}) async {
		List<Folder> folders = await DB().loadFolders();
		for(Folder f in folders){
			if(f.id == id){
				return f;
			}
		}
		return folders.first;  // Root
	}


	Future<String> getFolderName({required int id}) async {
		if(id == 0){ return "Notes"; }
		Database db = await createDB(dPath: dPath);
		List<Map<String, Object?>> folders = await db.query("folders");
		for(Map f in folders){
			if(f["id"] == id){
				return f["name"];
			}
		}
		return "";
	}

	Future<List<Folder>> loadFolders() async {
		Database db = await createDB(dPath: dPath);
		List<Folder> folders = [];
		List<Map<String, Object?>> fs = await db.query("folders");

		for(Map<String, dynamic> folder in fs){
			
			List<SmallNote> folderNote = [];
			folderNote = await DB().getSmallNotes(folderId: folder["id"]);

			folders.add(
				Folder(
					id: folder["id"],
					name: folder["name"],
					isSelected: false,
					notes: folderNote
				)
			);
		}
		await db.close();
		return folders;
	}


	Future<List<FolderInfo>> loadFoldersInfo() async {
		Database db = await createDB(dPath: dPath);
		List<FolderInfo> folders = [];
		List<Map<String, Object?>> fs = await db.query("folders");

		for(Map<String, dynamic> folder in fs){
			folders.add(
				FolderInfo(
					id: folder["id"],
					name: folder["name"],
				)
			);
		}
		await db.close();
		return folders;
	}


	// Makrdown themes
	Future<String> readMarkdownTheme() async {
		Map data = await getQuery("local");
		return data["markdownThemeName"];
	}

	/* Acrylic Opacity */ 
	Future<void> updateMarkdownTheme(String newName) async {
		await updateTable('local',
			{"markdownThemeName": newName});
	}


	// {{ STRING }}
	Future<String> readString(String name) async {
		Map data = await getQuery("local");
		return data[name] as String;
	}

	Future<void> updateString(String name, String value) async {
		await updateTable('local', {name: value});
	}


	// Future<void> updateTextStyle(TextStyle style) async {
	Future<void> updateTextStyle(BuildContext ctx) async {
		TextStyle style = Provider.of<ProviderManager>(ctx, listen: false).defaultStyle;
		Map<String, dynamic> data = {
			"fontFamily": style.fontFamily,
			"fontSize": style.fontSize!.toDouble(),
			"fontWeight": style.fontWeight!.value,
			// "fontWeight": int.parse(
			// 	style.fontWeight.toString().replaceAll("FontWeight.w", "")),
			"fontHeight": style.height!.toDouble(),
			"letterSpacing": style.letterSpacing!.toDouble(),
		};
		await updateTable('local', data);
	}

	Future<TextStyle> readTextStyle() async {
		Map data = await getQuery("local");
		return TextStyle(
			fontSize: data["fontSize"],
			letterSpacing: data["letterSpacing"],
			fontFamily: data["fontFamily"],
			fontWeight: fontWeightParser(data["fontWeight"]),
			height: data["fontHeight"]
		);
	}


	/* Render Mode */
	Future<RenderMode> getRenderMode() async {
		Map data = await getQuery("local");
		return numToRMode(data["renderMode"]);
	}

	Future<void> setRenderMode(int numMode) async {
		await updateTable('local', { "renderMode": numMode });
	}

}

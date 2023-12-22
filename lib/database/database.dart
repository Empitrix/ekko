import 'package:ekko/models/folder.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
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
				acrylicOpacity FLOAT
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


		// await db.execute("""
		// 	CREATE TABLE IF NOT EXISTS folder_items (
		// 		id INTEGER PRIMARY KEY,
		// 		title TEXT,
		// 		description TEXT,
		// 		content TEXT,
		// 		lastEdit Text,
		// 		isPinned BIT,
		// 		mode Text,
		// 		folderId INTEGER,
		// 		FOREIGN KEY (folderId) REFERENCES folders(id)
		// 	)
		// """);


		if(List.from(await db.query("local")).isEmpty){
			Map<String, Object?> initData = {
				"darkMode": 0,
				"acrylicMode": 0,
				"wrapCodeMode": 1,
				"acrylicOpacity": 1.0,
			};  // Init table
			// Set parameters on db 
			await db.insert("local", initData);
			
			await DB().createFolder(folderName: "~", isPrime: true);  // Root Folder

			debugPrint("[DATABASE INITIALIZED]");
		}{
			debugPrint("[RUNNING DATABASE]");
		}
		await db.close();
	}


	/* Theme Mode */
	Future<ThemeMode> readTheme() async {
		Map data = await getQuery("local");
		return data["darkMode"] == 1 ?
			ThemeMode.dark : ThemeMode.light;
	}

	Future<void> updateTheme(ThemeMode newMode) async {
		await updateTable('local',
			{"darkMode": newMode == ThemeMode.dark ? 1 : 0});
	}

	/* Acrylic Mode */
	Future<bool> readAcrylicMode() async {
		Map data = await getQuery("local");
		return data["acrylicMode"] == 1;
	}

	/* Wrap Mode */
	Future<void> updateWrapCodeMode(bool newMode) async {
		await updateTable('local',
			{"wrapCodeMode": newMode == true ? 1 : 0});
	}

	/* Acrylic Mode */
	Future<bool> readWrapCodeMode() async {
		Map data = await getQuery("local");
		return data["wrapCodeMode"] == 1;
	}

	Future<void> updateAcrylicMode(bool newMode) async {
		await updateTable('local',
			{"acrylicMode": newMode ? 1 : 0});
	}

	/* Acrylic Opacity */ 
	Future<double> readAcrylicOpacity() async {
		Map data = await getQuery("local");
		return data["acrylicOpacity"];
	}

	Future<void> updateAcrylicOpacity(double newValue) async {
		await updateTable('local',
			{"acrylicOpacity": newValue});
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


	// Future<void> createNoteFolder({required Folder folder, required Note note}) async {
	// 	Database db = await createDB(dPath: dPath);
	// 	Map<String, Object?> data = Map<String, Object?>.from(note.toJson());
	// 	// Setup folder-id that are note in <NOTES> by default
	// 	data["folderId"] = folder.id;
	// 	await db.insert(
	// 		"folder_items",
	// 		Map<String, Object?>.from(data)
	// 	);
	// 	await db.close();
	// }

	// Future<void> updateFolder({required Folder folder}) async {
	// 	Database db = await createDB(dPath: dPath);
	// 	await db.update(
	// 		"folders",
	// 		Map<String, Object?>.from({"name": folder.name}),
	// 		where: "id = ?",
	// 		whereArgs: [folder.id]
	// 	);
	// 	await db.close();
	// }



}

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
		await db.execute("""
			CREATE TABLE IF NOT EXISTS notes (
				id INTEGER PRIMARY KEY,
				title TEXT,
				description TEXT,
				content TEXT,
				lastEdit Text,
				isPinned BIT,
				mode Text
			)
		""");
		if(List.from(await db.query("local")).isEmpty){
			Map<String, Object?> initData = {
				"darkMode": 0,
				"acrylicMode": 0,
				"wrapCodeMode": 1,
				"acrylicOpacity": 1.0,
			};  // Init table
			// Set parameters on db 
			await db.insert("local", initData);
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

	Future<List<Note>> getNotes() async {
		List<Note> other = [];
		List<Note> pinned = [];
		Database db = await createDB(dPath: dPath);
		List<Map<String, Object?>> data = await db.query("notes");
		for(Map note in data){
			if(note["isPinned"] == 1){
				pinned.add(Note.toNote(note));
			} else {
				other.add(Note.toNote(note));
			}
		}
		await db.close();
		return [...pinned, ...other];
	}

	Future<List<SmallNote>> getSmallNotes() async {
		List<SmallNote> otherNotes = [];
		List<SmallNote> pinnedNotes = [];
		Database db = await createDB(dPath: dPath);
		List<Map<String, Object?>> data = await db.query("notes");
		for(Map note in data){
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

}

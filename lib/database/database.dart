import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ekko/database/dfi.dart';


class DB {
	Future<void> init() async {
		/* Initialized database */
		Database db = await createDB();
		await db.execute("""
			CREATE TABLE IF NOT EXISTS local (
				darkMode BIT,
				acrylicMode BIT
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
				"acrylicMode": 0
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

	Future<void> updateAcrylicMode(bool newMode) async {
		await updateTable('local',
			{"acrylicMode": newMode ? 1 : 0});
	}


	/* Notes CRUD */
	Future<void> addNote(Note note) async {
		Database db = await createDB();
		await db.insert(
			"notes",
			Map<String, Object?>.from(note.toJson())
		);
		await db.close();
	}

	Future<List<Note>> getNotes() async {
		List<Note> notes = [];
		Database db = await createDB();
		List<Map<String, Object?>> data = await db.query("notes");
		for(Map note in data){
			notes.add(Note.toNote(note));
		}
		await db.close();
		return notes;
	}

	Future<void> updateNote(Note old, Note newOne) async {
		Database db = await createDB();
		await db.update(
			'notes', 
			Map<String, Object?>.from(newOne.toJson()),
			where: "id = ?",
			whereArgs: [old.id]
		);
		await db.close();
	}

	Future<void> deleteNote(Note note) async {
		Database db = await createDB();
		await db.delete(
			'notes',
			where: "id = ?",
			whereArgs: [note.id]
		);
		await db.close();
	}

}
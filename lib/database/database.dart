import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sq;
import 'package:sqflite/sqflite.dart';
import 'dart:io';


/* Create, Read, Update, Delete */
Future<Database> _createDB() async {
	Database? db;
	if(Platform.isWindows || Platform.isLinux){
		sq.sqfliteFfiInit();
		db = await sq.databaseFactoryFfi.openDatabase(dbPath);
	} else {
		db = await sq.openDatabase(dbPath);
	}
	return db;
}


class DB {
	Future<void> init() async {
		/* Initialized database */
		Database db = await _createDB();
		await db.execute("""
			CREATE TABLE IF NOT EXISTS local (
				darkMode bit
			)
		""");
		
		if(List.from(await db.query("local")).isEmpty){
			Map<String, Object?> initData = {
				"darkMode": 0
			};  // Init table

			// Set parameters on db 
			await db.insert("local", initData);
			debugPrint("[DATABASE INITIALIZED]");
		}{
			debugPrint("[RUNNING DATABASE]");
		}
		await db.close();
	}


	Future<ThemeMode> readTheme() async {
		Database db = await _createDB();
		List<Map> data = await db.query("local");
		await db.close();
		return data[0]["darkMode"] == 1 ?
			ThemeMode.dark : ThemeMode.light;
	}

	Future<void> updateTheme(ThemeMode newMode) async {
		Database db = await _createDB();
		await db.update('local', {
			"darkMode": newMode == ThemeMode.dark ? 1 : 0
		});
		await db.close();
	}


}
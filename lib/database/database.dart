import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ekko/database/dfi.dart';


class DB {
	Future<void> init() async {
		/* Initialized database */
		Database db = await createDB();
		await db.execute("""
			CREATE TABLE IF NOT EXISTS local (
				darkMode bit,
				acrylicMode bit
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


	Future<ThemeMode> readTheme() async {
		Map data  = await getQuery("local");
		return data["darkMode"] == 1 ?
			ThemeMode.dark : ThemeMode.light;
	}

	Future<void> updateTheme(ThemeMode newMode) async {
		await updateTable('local',
			{"darkMode": newMode == ThemeMode.dark ? 1 : 0});
	}


}

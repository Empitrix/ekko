/* Database Functions Interface */
import 'dart:convert';

import 'package:ekko/config/public.dart';
import 'package:ekko/models/enums.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sq;
import 'package:sqflite/sqflite.dart';
import 'dart:io';

Future<Database> createDB({String? dPath}) async {
	dPath ??= dbPath;
	Database? db;
	if(Platform.isWindows || Platform.isLinux){
		sq.sqfliteFfiInit();
		db = await sq.databaseFactoryFfi.openDatabase(dPath);
	} else {
		db = await openDatabase(dPath);
	}
	return db;
}

Future<Map> getQuery(String tName) async {
	Map data = {};
	Database db = await createDB();
	data = (await db.query(tName)).first;
	await db.close();
	return data;
}

Future<void> updateTable(String tName, Map<String, Object?> data) async {
	Database db = await createDB();
	await db.update(tName, data);
	await db.close();
}


class TempOffice{
	File tempDb = File(tempDbPath);
	Future<void> write(Map data) async {
		tempDb.writeAsStringSync(const JsonEncoder().convert(data));
	}
	Future<Map> read() async {
		return const JsonDecoder().convert(tempDb.readAsStringSync());
	}
}


RenderMode numToRMode(int num){
	late RenderMode mode;
	switch(num){
		case 0:{
			mode = RenderMode.fancy;
			break;
		}
		case 1:{
			mode = RenderMode.fast;
			break;
		}
		default: {
			mode = RenderMode.fancy;
			break;
		}
	}
	return mode;
}

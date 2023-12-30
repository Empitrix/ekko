/* Database Functions Interface */
import 'package:ekko/config/public.dart';
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


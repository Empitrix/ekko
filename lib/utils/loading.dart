import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

DB _db = DB();

Future<void> updateDbPath() async {
	dbPath = p.join(
		(await getApplicationSupportDirectory()).absolute.path,
		"ekko.db"
	);
}

Future<void> essentialLoading(BuildContext context)async{
	/* Load all the essentials */
	await updateDbPath();
	await _db.init();
	dMode = (await _db.readTheme()) == ThemeMode.dark;
	acrylicMode = await _db.readAcrylicMode();
	// ignore: use_build_context_synchronously
	Provider.of<ProviderManager>(context, listen: false).changeTmode(
		dMode ? ThemeMode.dark : ThemeMode.light
	);
}

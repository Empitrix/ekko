import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
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
	double opacity = await _db.readAcrylicOpacity();
	// ignore: use_build_context_synchronously
	Provider.of<ProviderManager>(context, listen: false).changeTmode(
		dMode ? ThemeMode.dark : ThemeMode.light
	);
	// ignore: use_build_context_synchronously
	Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(
		opacity
	);
	if(acrylicMode){
		await Window.setEffect(
			effect: WindowEffect.acrylic,
			// ignore: use_build_context_synchronously
			color: const Color(0xff17212b).aae(context)
		);
	} else {
		// ignore: use_build_context_synchronously
		Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(1);
	}


}

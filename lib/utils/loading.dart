import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/database/latex_temp_db.dart';
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
	tempDbPath = p.join(
		(await getApplicationSupportDirectory()).absolute.path,
		"temp.json"
	);
	tempFolder = p.join(
		(await getApplicationSupportDirectory()).absolute.path,
		"temp/"
	);
}

Future<void> essentialLoading(BuildContext context)async{

	// if (await Permission.manageExternalStorage.request().isDenied) {
	// 	openAppSettings();
	// }

	/* Load all the essentials */
	await updateDbPath();
	await _db.init();

	await TempDB().init();  // innit temp db

	settingModes['dMode'] = await _db.readBool("darkMode");
	settingModes['markdownThemeName'] = await _db.readMarkdownTheme();
	settingModes['acrylicMode'] = await _db.readBool("acrylicMode");
	settingModes['wrapCodeMode'] = await _db.readBool("wrapCodeMode");
	settingModes['editorWrapMode'] = await _db.readBool("editorWrapMode");
	settingModes['checkListCheckable'] = await _db.readBool("checkableCheckList");
	settingModes['tabSize'] = await _db.readInt('tabSize');
	settingModes['plainFontFamily'] = await _db.readString('plainFontFamily');

	double opacity = await _db.readAcrylicOpacity();

	// Text-Style
	TextStyle userStyle = await _db.readTextStyle();



	// ignore: use_build_context_synchronously
	// Provider.of<ProviderManager>(context, listen: false).changeDefaultTextStyle(
	// 	userStyle
	// );
	// ignore: use_build_context_synchronously
	Provider.of<ProviderManager>(context, listen: false).changeDefaultTextStyle(
		letterSpacing: userStyle.letterSpacing,
		height: userStyle.height,
		fontWeight: userStyle.fontWeight,
		fontFamily: userStyle.fontFamily,
		fontSize: userStyle.fontSize
	);

	// ignore: use_build_context_synchronously
	Provider.of<ProviderManager>(context, listen: false).changeTmode(
		settingModes['dMode'] ? ThemeMode.dark : ThemeMode.light
	);
	// ignore: use_build_context_synchronously
	Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(
		opacity
	);
	if(settingModes['acrylicMode']){
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

import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
	const SettingsPage({super.key});

	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
	
	DB db = DB();
	
	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				changeView(context, const HomePage(), isPush: false);
				return false;
			},
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("Settings"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: () => changeView(context, const HomePage(), isPush: false),
					),
				),
				body: ListView(
					children: [

						SwitchTile(
							leading: const Icon(Icons.dark_mode),
							title: const Text("Dark Mode",
								style: TextStyle(fontWeight: FontWeight.bold)),
							value: dMode,
							onChange: (bool value) async {
								setState(() { dMode = value; });
								Provider.of<ProviderManager>(context, listen: false).changeTmode(
									dMode ? ThemeMode.dark : ThemeMode.light);
								await db.updateTheme(dMode ? ThemeMode.dark : ThemeMode.light);
							}
						), // Dark mode

						if(isDesktop()) SwitchTile(
							leading: const Icon(Icons.window),
							title: const Text("Acrylic Mode",
								style: TextStyle(fontWeight: FontWeight.bold)),
							value: acrylicMode,
							onChange: (bool value) async {
								if(value){
									await Window.setEffect(
										effect: WindowEffect.acrylic,
										color: const Color(0xff17212b).aae(context)
										// color: const Color(0xCC222222),
									);
									// Window.addToolbar();
								} else {
									// Provider.of<ProviderManager>(context, listen: false).changeTmode(
									// 	dMode ? ThemeMode.dark : ThemeMode.light
									// );
									Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(1);
									await Window.setEffect(
										effect: WindowEffect.disabled,
										// color: const Color(0xff17212b).aae()
										color: const Color(0xff17212b).aae(context)
										// color: const Color(0xCC222222),
									);
									// // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
									// Provider.of<ProviderManager>(context, listen: false).notifyListeners();
									// ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
									// Provider.of<ProviderManager>(context, listen: false).changeTmode(
									// 	dMode ? ThemeMode.dark : ThemeMode.light
									// );
									
								}
								setState(() { acrylicMode = value; });
								await db.updateAcrylicMode(value);
							}
						),  // Acrylic mode

					],
				),
			),
		);
	}
}
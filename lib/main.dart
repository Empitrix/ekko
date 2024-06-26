import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/toolbar.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/views/land_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';


Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	if(isDesktop()){
		// WidgetsFlutterBinding.ensureInitialized();
		await Window.initialize();  // Acrylic Window
		await windowManager.ensureInitialized();  // Window manager

		// To remove toolbar
		windowManager.waitUntilReadyToShow(
			const WindowOptions(titleBarStyle: TitleBarStyle.hidden), (){});

		doWhenWindowReady(() async {
			appWindow.minSize = const Size(500, 450);
			appWindow.size = const Size(580, 700);
			appWindow.title = "Ekko";
			appWindow.show();
		});
	}  // isDesktop

	runApp(const EkkoApp());
}

class EkkoApp extends StatefulWidget {
	const EkkoApp({super.key});

	@override
	State<EkkoApp> createState() => _EkkoAppState();
}

class _EkkoAppState extends State<EkkoApp> {
	@override
	Widget build(BuildContext context) {
		
		return MultiProvider(
			providers: [
				ChangeNotifierProvider(
					create: (_) => ProviderManager(),
					builder: (BuildContext context, Widget? child){
						return MaterialApp(
							title: "Ekko",
							debugShowCheckedModeBanner: false,
							themeMode: Provider.of<ProviderManager>(context).tMode,
							theme: Provider.of<ProviderManager>(context).lightTheme(context),
							darkTheme: Provider.of<ProviderManager>(context).darkTheme(context),
							home: isDesktop(['linux']) ?
								const ToolbarView(view: LandPage(folderId: 0)):
								const LandPage(folderId: 0),
						);
					},
				)
			],
		);
	}
}


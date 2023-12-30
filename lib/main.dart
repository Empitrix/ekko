import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/views/land_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
// import 'package:window_manager/window_manager.dart';


Future<void> main() async {
	if(isDesktop()){
		WidgetsFlutterBinding.ensureInitialized();
		await Window.initialize();  // Acrylic Window
		// await windowManager.ensureInitialized();  // Window manager

		// WindowOptions windowOptions = WindowOptions(
		// 	// size: const Size(800, 600),
		// 	size: const Size(600, 500),
		// 	center: true,
		// 	backgroundColor: Colors.transparent.withOpacity(1),
		// 	// skipTaskbar: true,
		// 	titleBarStyle: TitleBarStyle.normal,
		// );
		// windowManager.waitUntilReadyToShow(windowOptions, () async {
		// 	await windowManager.show();
		// 	await windowManager.focus();
		// });

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
							home: const LandPage(folderId: 0),
							// home: const LoadingPage(),
						);
					},
				)
			],
		);
	}
}


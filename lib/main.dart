import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';


Future<void> main() async {
	if(isDesktop()){
		WidgetsFlutterBinding.ensureInitialized();
		await Window.initialize();
	}
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
							theme: Provider.of<ProviderManager>(context).lightTheme,
							darkTheme: Provider.of<ProviderManager>(context).darkTheme,
							home: const HomePage(),
							// home: const LoadingPage(),
						);
					},
				)
			],
		);
	}
}

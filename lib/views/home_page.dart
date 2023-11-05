import 'package:ekko/database/database.dart';
import 'package:ekko/utils/loading.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	
	
	Future<void> init() async {
		// Just for testing
		await updateDbPath();
		await DB().init();
		ThemeMode mode = await DB().readTheme();
		debugPrint("Mode: $mode");
	}
	
	
	@override
	void initState() {
		init();
		super.initState();
	}
	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async { return false; },
			child: const Scaffold(
				body: Center(child: Text("Awesome")),
			),
		);
	}
}
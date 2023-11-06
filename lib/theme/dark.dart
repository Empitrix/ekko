import 'package:flutter/material.dart';

ThemeData dark(){
	return ThemeData(
		useMaterial3: true,
		fontFamily: "Rubik",
		// scaffoldBackgroundColor: const Color(0xff17212b),
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.cyan,
			brightness: Brightness.dark,
		)
	);
}
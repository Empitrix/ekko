import 'package:flutter/material.dart';

ThemeData dark(){
	return ThemeData(
		useMaterial3: true,
    fontFamily: "Rubik",
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.cyan,
			brightness: Brightness.dark
		)
	);
}
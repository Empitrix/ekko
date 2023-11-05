import 'package:flutter/material.dart';

ThemeData dark(){
	return ThemeData(
		useMaterial3: true,
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.cyan,
			brightness: Brightness.dark
		)
	);
}
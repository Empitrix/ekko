import 'package:flutter/material.dart';

ThemeData ligth(){
	return ThemeData(
		useMaterial3: true,
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.blue,
			brightness: Brightness.light
		)
	);
}
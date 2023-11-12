import 'package:flutter/material.dart';

Color _bgColor = const Color(0xffffffff);
Color _pColor = const Color(0xff517da2);

ThemeData light(){
	return ThemeData(
		useMaterial3: true,
		fontFamily: "Rubik",
		scaffoldBackgroundColor: _bgColor,
		primaryColor: _pColor,
		colorScheme: ColorScheme.fromSeed(
			seedColor: _pColor,
			brightness: Brightness.light,
		),
		appBarTheme: AppBarTheme(
			backgroundColor: _bgColor
		),
		drawerTheme: DrawerThemeData(
			backgroundColor: _bgColor
		),
	);
}

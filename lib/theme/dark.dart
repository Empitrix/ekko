import 'package:flutter/material.dart';

Color _bgColor = const Color(0xff17212b);
Color _pColor = const Color(0xff00bbd4);

ThemeData dark(){
	return ThemeData(
		useMaterial3: true,
		fontFamily: "Rubik",
		scaffoldBackgroundColor: _bgColor,
		primaryColor: _pColor,
		colorScheme: ColorScheme.fromSeed(
			seedColor: _pColor,
			brightness: Brightness.dark,
		),
		appBarTheme: AppBarTheme(
			backgroundColor: _bgColor
		),
		drawerTheme: DrawerThemeData(
			backgroundColor: _bgColor
		),
	);
}

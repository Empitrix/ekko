import 'package:flutter/material.dart';

Color _bgColor = const Color(0xff17212b);
Color _pColor = const Color(0xff00bbd4);
Color _navBgColor = const Color(0xff242f3d);

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
			backgroundColor: _navBgColor,
			titleTextStyle: const TextStyle(
				fontFamily: "Rubik",
				fontWeight: FontWeight.bold,
				letterSpacing: 0.3,
				fontSize: 20
			),
			iconTheme: const IconThemeData(
				color: Colors.white
			),
			surfaceTintColor: Colors.transparent
		),
		drawerTheme: DrawerThemeData(
			backgroundColor: _bgColor
		),
	);
}

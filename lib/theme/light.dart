import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';

Color _bgColor = const Color(0xffffffff);
Color _pColor = const Color(0xff517da2);
Color _navBgColor = const Color(0xff517da2);

ThemeData light(BuildContext context){
	return ThemeData(
		useMaterial3: true,
		fontFamily: "Rubik",
		scaffoldBackgroundColor: _bgColor.aae(context),
		primaryColor: _pColor,
		colorScheme: ColorScheme.fromSeed(
			seedColor: _pColor,
			brightness: Brightness.light,
		),
		appBarTheme: AppBarTheme(
			backgroundColor: _navBgColor.aae(context),
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
			// backgroundColor: _bgColor.aae()
			backgroundColor: _bgColor
		),
	);
}

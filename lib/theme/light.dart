import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';


ThemeData light(BuildContext context){
	Color bgColor = const Color(0xffffffff);
	Color pColor = const Color(0xff517da2);
	Color navBgColor = const Color(0xff517da2);
	return ThemeData(
		useMaterial3: true,
		fontFamily: "Rubik",
		scaffoldBackgroundColor: bgColor.aae(context),
		primaryColor: pColor,
		colorScheme: ColorScheme.fromSeed(
			seedColor: pColor,
			brightness: Brightness.light,
		),
		appBarTheme: AppBarTheme(
			backgroundColor: navBgColor.aae(context),
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
			backgroundColor: bgColor
		),
	);
}

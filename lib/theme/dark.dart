import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';


ThemeData dark(BuildContext context){
	Color bgColor = const Color(0xff17212b);
	Color pColor = const Color(0xff00bbd4);
	Color navBgColor = const Color(0xff242f3d);
	return ThemeData(
		useMaterial3: true,
		fontFamily: "Rubik",
		scaffoldBackgroundColor: bgColor.aae(context),
		primaryColor: pColor,
		colorScheme: ColorScheme.fromSeed(
			seedColor: pColor,
			brightness: Brightness.dark,
			outline: Colors.transparent
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

		outlinedButtonTheme: OutlinedButtonThemeData(
			style: ButtonStyle(
				side: MaterialStatePropertyAll(
					BorderSide(
						color: pColor
					)
				)
			)
		),


	);
}

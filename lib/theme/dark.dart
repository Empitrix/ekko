import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';

// Color _bgColor = const Color(0xff17212b);
// Color _pColor = const Color(0xff00bbd4);
// Color _navBgColor = const Color(0xff242f3d);

ThemeData dark(BuildContext context){
	Color bgColor = const Color(0xff17212b);
	Color pColor = const Color(0xff00bbd4);
	Color navBgColor = const Color(0xff242f3d);
	return ThemeData(
		useMaterial3: true,
		fontFamily: "Rubik",
		// fontFamily: "SauceCodeProNerdFont",
		scaffoldBackgroundColor: bgColor.aae(context),
		primaryColor: pColor,
		colorScheme: ColorScheme.fromSeed(
			seedColor: pColor,
			brightness: Brightness.dark,
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
			// backgroundColor: _bgColor.aae()
			backgroundColor: bgColor
		),
	);
}

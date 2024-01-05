import 'package:ekko/theme/light.dart';
import 'package:ekko/theme/dark.dart';
import 'package:flutter/material.dart';

class ProviderManager extends ChangeNotifier {
	ThemeMode tMode = ThemeMode.system;
	double acrylicOpacity = 1;

	// Text
	TextStyle defaultStyle = const TextStyle(
		fontSize: 16,
		letterSpacing: 0.7,
		fontFamily: "Rubik",
		fontWeight: FontWeight.normal,
		height: 1.4
	);

	ThemeData lightTheme(BuildContext context){
		return light(context);
	}
	ThemeData darkTheme(BuildContext context){
		return dark(context);
	}
	
	void changeTmode(ThemeMode newMode){
		tMode = newMode;
		notifyListeners();
	}

	void changeAcrylicOpacity(double data){
		acrylicOpacity = data;
		notifyListeners();
	}


	void changeDefaultTextStyle(TextStyle newStyle){
		defaultStyle = newStyle;
		notifyListeners();
	}

}


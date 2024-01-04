import 'package:ekko/theme/light.dart';
import 'package:ekko/theme/dark.dart';
import 'package:flutter/material.dart';

class ProviderManager extends ChangeNotifier {
	ThemeMode tMode = ThemeMode.system;
	double acrylicOpacity = 1;

	ThemeData lightTheme(BuildContext context){
		return light(context, );
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
}

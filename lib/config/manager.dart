import 'package:ekko/theme/light.dart';
import 'package:ekko/theme/dark.dart';
import 'package:flutter/material.dart';

class ProviderManager extends ChangeNotifier {
	ThemeMode tMode = ThemeMode.system;
	ThemeData lightTheme = light();
	ThemeData darkTheme = dark();

	void changeTmode(ThemeMode newMode){
		tMode = newMode;
		notifyListeners();
	}
}
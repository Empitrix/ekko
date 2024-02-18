
// Metadata
import 'package:flutter/material.dart';

String appVersion = "4.20.0";

// Will update when app started
String dbPath = "";
// Dark mode
bool dMode = false;
// Acrylic Mode
bool acrylicMode = false;
// Wrap code Mode
bool wrapCodeMode = false;
// Check-List Checkable
bool checkListCheckable = false;
// Wait for loading size (Page Navigator Loadings)
int waitForLoading = 420;
int waitLoadingSize = 300; // ms

String markdownThemeName = "gruvbox-dark";

// double textHeight = 1.4;
// double letterSpacing = 0.7;

// TextStyle defaultStyle = TextStyle(
// 	fontSize: 16,
// 	fontWeight: FontWeight.w500,
// 	height: textHeight
// );
// // Acyrlic Opacity
// double acrylicOpacity = 0.5;

Map<String, FocusNode> screenShortcutFocus = <String, FocusNode>{
	"LandPage": FocusNode(),
	"ModifyPage": FocusNode(),
	"DisplayPage": FocusNode(),
};


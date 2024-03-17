import 'package:flutter/material.dart';

// Application Public version
String appVersion = "4.20.0";

// Tab-Size for Syntax-Highlighting block
int tabSize = 2;

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

// Wait for loading size (Page Navigator Loadings) (ms)
int waitForLoading = 420;
int waitLoadingSize = 300;

// Syntax-Highlighting theme
String markdownThemeName = "gruvbox-dark";

Map<String, FocusNode> screenShortcutFocus = <String, FocusNode>{
	"LandPage": FocusNode(),
	"ModifyPage": FocusNode(),
	"DisplayPage": FocusNode(),
};


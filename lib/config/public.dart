import 'package:flutter/material.dart';

// Application Public version
String appVersion = "4.20.0";

// Will update when app started
String dbPath = "";

// temp
String tempDbPath = "";
String tempFolder = "";


Map<String, dynamic> settingModes = {
	"dMode": false,
	"acrylicMode": false,
	"wrapCodeMode": false,
	"editorWrapMode": false,
	"checkListCheckable": false,
	"markdownThemeName": "gruvbox-dark",
	"tabSize": 2
};

// Wait for loading size (Page Navigator Loadings) (ms)
int waitForLoading = 420;
int waitLoadingSize = 300;

Map<String, FocusNode> screenShortcutFocus = <String, FocusNode>{
	"LandPage": FocusNode(),
	"ModifyPage": FocusNode(),
	"DisplayPage": FocusNode(),
};


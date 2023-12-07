import 'package:flutter/material.dart';

// Will update when app started
String dbPath = "";
// Dark mode
bool dMode = false;
// Acrylic Mode
bool acrylicMode = false;
// Wrap code Mode
bool wrapCodeMode = false;
// Wait for loading size (Page Navigator Loadings)
int waitForLoading = 420;
int waitLoadingSize = 300; // ms

double textHeight = 1.4;

TextStyle defaultStyle = TextStyle(
	fontSize: 16,
	// fontSize: 16 * 1.5,
	// shadows: const [BoxShadow(offset: Offset(1, 1), blurRadius: 2)],
	// shadows: const [BoxShadow(offset: Offset(0.5, 0.5), blurRadius: 100)],
	fontWeight: FontWeight.w500,
	height: textHeight
);
// // Acyrlic Opacity
// double acrylicOpacity = 0.5;

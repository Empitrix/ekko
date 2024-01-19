import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:math' as math;


String vStr(String input){
	return input.toLowerCase().trim();
}

class TxtCtrl{
	final TextEditingController a;
	final TextEditingController b;
	final TextEditingController c;
	TxtCtrl(
		this.a,
		this.b,
		this.c
	);

	bool isAllFilled(){
		if(vStr(a.text) == ""){ return false;}
		if(vStr(b.text) == ""){ return false;}
		if(vStr(c.text) == ""){ return false;}
		return true;
	}

	bool isAllEmpty(){
		if(vStr(a.text) != ""){ return false;}
		if(vStr(b.text) != ""){ return false;}
		if(vStr(c.text) != ""){ return false;}
		return true;
	}
}


bool isDesktop([List<String>? platforms]){
	// Behave with web like non-desktop (acrylic etc.. error)
	if(kIsWeb){ return false; }
	if(Platform.isAndroid){ return false; }
	if(Platform.isIOS){ return false; }
	if(platforms != null){
		for(String p in platforms){
			if(p == "linux"){ if(Platform.isLinux){ return false; } }
			if(p == "windows"){ if(Platform.isWindows){ return false; } }
			if(p == "macos"){ if(Platform.isMacOS){ return false; } }
		}
	}
	return true;
}

double getAngle(int d){
	return (d / (180 / math.pi));
}


FontWeight fontWeightParser(int input){
	return FontWeight.values[input ~/ 100.toInt() - 1];
}

TextSelectionControls getSelectionControl(){
	if(isDesktop()){
		return DesktopTextSelectionControls();
	} else {
		return MaterialTextSelectionControls();
	}
}

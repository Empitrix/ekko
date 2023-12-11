import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math' as math;


String vStr(String input){
	return input.toLowerCase().trim();
}

class TxtCtrl{
	static bool isAllFilled(TextEditingController a, b, c){
		if(vStr(a.text) == ""){ return false;}
		if(vStr(b.text) == ""){ return false;}
		if(vStr(c.text) == ""){ return false;}
		return true;
	}

}


bool isDesktop([List<String>? platforms]){
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

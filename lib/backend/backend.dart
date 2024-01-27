import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:math' as math;


String vStr(String input){
	return input.toLowerCase().trim();
}

class TxtCtrl{
	final TextEditingController a;
	final TextEditingController? b;
	final TextEditingController c;
	TxtCtrl(
		this.a,
		this.b,
		this.c
	);

	bool isAllFilled(){
		if(vStr(a.text) == ""){ return false;}
		if(b != null){
			if(vStr(b!.text) == ""){ return false;}
		}
		if(vStr(c.text) == ""){ return false;}
		return true;
	}

	bool isAllEmpty(){
		if(vStr(a.text) != ""){ return false;}
		if(b != null){
			if(vStr(b!.text) != ""){ return false;}
		}
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


String _getNumAs(int num, String type){
	return "$num $type${num == 1 ? '' : 's'} ago";
}

/* Difference between date time from now */
String differenceFromNow(DateTime input){
	Duration duration = DateTime.now().difference(input);
	String fromNow = "";
	List<Map<String, int>> timeData = [
		{ "day": duration.inDays },
		{ "hour": duration.inHours },
		{ "minute": duration.inMinutes },
		{ "second": duration.inSeconds },
	];

	for(Map type in timeData){
		String key = type.keys.toList().first;
		if(type[key] != 0){
				fromNow = _getNumAs(type[key], key);
		}
		if(fromNow.isNotEmpty){
			break;
		} else {
			if(key == "second"){
				fromNow = "Now";
			}
		}
	}

	return fromNow;
}


String formatizeVDate(String input){
	/* Minimalist text (valid date[VDate]) formatting */
	return input
		.replaceAll(RegExp(r'(days|day)'), "d")
		.replaceAll(RegExp(r'(hours|hour)'), "h")
		.replaceAll(RegExp(r'(minutes|minute)'), "m")
		.replaceAll(RegExp(r'(seconds|second)'), "s")
		.replaceAll("ago", "")
		.replaceAll(" ", "");
}

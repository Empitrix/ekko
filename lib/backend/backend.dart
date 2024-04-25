import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart';



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
		if(a.text.mini() == ""){ return false;}
		if(b != null){
			if(b!.text.mini() == ""){ return false;}
		}
		if(c.text.mini() == ""){ return false;}
		return true;
	}

	bool isAllEmpty(){
		if(a.text.mini() != ""){ return false;}
		if(b != null){
			if(b!.text.mini() != ""){ return false;}
		}
		if(c.text.mini() != ""){ return false;}
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
		{ "month": duration.inDays ~/ 30 },
		{ "day": duration.inDays },
		{ "hour": duration.inHours },
		{ "minute": duration.inMinutes },
		{ "second": duration.inSeconds },
	];

	for(Map type in timeData){
		String key = type.keys.toList().first;
		// find the biggest that is not a 0 (empty)
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
		.replaceAll(RegExp(r'(month|month)'), "mo")  // find a better short (mo/mos)
		.replaceAll(RegExp(r'(days|day)'), "d")
		.replaceAll(RegExp(r'(hours|hour)'), "h")
		.replaceAll(RegExp(r'(minutes|minute)'), "m")
		.replaceAll(RegExp(r'(seconds|second)'), "s")
		.replaceAll("ago", "")
		.replaceAll(" ", "");
}



String getUniqueFileName(String path, String input, [int counting = 0]){
	/* Get Unique name if file exsits */
	bool isThere = false;
	List<FileSystemEntity> files = Directory(path).listSync().toList();
	for(FileSystemEntity file in files){
		if(basename(file.absolute.path) == basename(input)){
			counting ++;
			isThere = true;
			List<String> parts = input.split('.');
			parts = parts.sublist(0, parts.length - 1);
			// Remove the last num if exsits
			parts.last = parts.last.replaceAll(RegExp(r'\([0-9]*\)'), "");
			input = "${parts.join()}($counting).md";
			break;
		}
	}
	if(!isThere){ return input; }
	// Re-call the function and try again
	return getUniqueFileName(path, input, counting);
}


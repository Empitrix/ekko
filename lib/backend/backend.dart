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


bool isDesktop(){
	if(Platform.isAndroid){ return false; }
	if(Platform.isIOS){ return false; }
	return true;
}

double getAngle(int d){
	return (d / (180 / math.pi));
}

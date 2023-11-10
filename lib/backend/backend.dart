import 'package:flutter/material.dart';

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
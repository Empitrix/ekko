import 'package:flutter/material.dart';


bool isTagEmpty(Map input){
	bool status = false;
	if(input['text'] != null){
		if((input['text'] as String).isEmpty){
			status = true;
		}
	} else {
		if((input['children'] as List).isEmpty){
			if((input['attributes'] as Map).isEmpty){
				status = true;
			}
		}
	}
	return status;
}



class HtmlCalculator {
	final BuildContext context;

	HtmlCalculator({
		required this.context
	});

	double? value(String input){
		try{
			return double.parse(input);
		} catch(_){
			return null;
		}
	}


	BorderRadiusGeometry borderRadius(String input){
		return BorderRadius.circular(0);
	}

}


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

	double? value(String? input){
		if(input == null){ return null; }
		try{
			return double.parse(input);
		} catch(_){
			return null;
		}
	}


	BorderRadiusGeometry borderRadius(String? input){
		if(input == null){ return BorderRadius.zero; }

		return BorderRadius.circular(20);
	}

}




String textTrimLeft(String? input){
	if(input == null){ return ""; }
	List<String> txt = [];
	for(String idx in input.split('\n')){
		txt.add(idx.trimLeft());
	}
	return txt.join("\n");
}



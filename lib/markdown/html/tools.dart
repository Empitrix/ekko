import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/public.dart';
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
		return BorderRadius.circular(0);
	}


	MainAxisAlignment align(String? input){
		if(input == null){ return MainAxisAlignment.start; }
		input = input.mini();
		late MainAxisAlignment align;
		switch(input){
			case "left": { align = MainAxisAlignment.start; break; }
			case "right": { align = MainAxisAlignment.end; break; }
			case "center": { align = MainAxisAlignment.center; break; }
			case "justify": { align = MainAxisAlignment.spaceEvenly; break; }
			default: { align = MainAxisAlignment.start; break; }
		}
		return align;
	}

	CrossAxisAlignment alignCross(String? input){
		if(input == null){ return CrossAxisAlignment.start; }
		input = input.mini();
		late CrossAxisAlignment align;
		switch(input){
			case "left": { align = CrossAxisAlignment.start; break; }
			case "right": { align = CrossAxisAlignment.end; break; }
			case "center": { align = CrossAxisAlignment.center; break; }
			case "justify": { align = CrossAxisAlignment.stretch; break; }
			default: { align = CrossAxisAlignment.start; break; }
		}
		return align;
	}

	Alignment alignment(String? input){
		if(input == null){ return Alignment.centerLeft; }
		input = input.mini();
		late Alignment align;
		switch(input){
			case "left": { align = Alignment.centerLeft; break; }
			case "right": { align = Alignment.centerRight; break; }
			case "center": { align = Alignment.center; break; }
			case "justify": { align = Alignment.center; break; }
			default: { align = Alignment.centerLeft; break; }
		}
		return align;
	}

}

/*
/* Alignment */
enum HtmlAlignment {left, right, center, justify}

HtmlAlignment getHtmlAlignment(String input){
	/* Get HTML alignemt value and turn it to enum for html-aligment */
	input = input.mini();
	late HtmlAlignment align;
	switch(input){
		case "left": { align = HtmlAlignment.left; }
		case "right": { align = HtmlAlignment.right; }
		case "center": { align = HtmlAlignment.center; }
		case "justify": { align = HtmlAlignment.justify; }
		case _: { align = HtmlAlignment.left; }  // Default (like text)
	}
	return align;
}

Alignment htmlToFlutterAlign(HtmlAlignment alignment){
	/* convert to html alignment ( not for justify ) */
	late Alignment align;
	switch(alignment){
		case HtmlAlignment.left: { align = Alignment.centerLeft; }
		case HtmlAlignment.right: { align = Alignment.centerRight; }
		case HtmlAlignment.center: { align = Alignment.center; }
		case _: { align = Alignment.centerLeft; }
	}
	return align;
}
*/


String textTrimLeft(String? input){
	if(input == null){ return ""; }
	List<String> txt = [];
	for(String idx in input.split('\n')){
		txt.add(idx.trimLeft());
	}
	return txt.join("\n");
}





double? getHtmlSize(BuildContext ctx, String? attr, String type){
	if(attr == null){ return null; }
	if(attr.replaceAll(RegExp(r'[0-9]+'), "").trim().isEmpty){
		// This is just num
		return int.parse(attr).toDouble();
	} else if(attr.contains("%")){
		// Calc persent
		if(type == "h"){
			return int.parse(attr.replaceAll("%", "").trim()) * MediaQuery.sizeOf(ctx).height / 100;
		} else {
			return int.parse(attr.replaceAll("%", "").trim()) * MediaQuery.sizeOf(ctx).width / 100;
		}
	} else if(attr.contains("px")){
		return int.parse(attr.replaceAll("px", "").trim()).toDouble();
	}
	return null;
}



bool checkSourceMedia(String? op){
	if(op == null){ return false; }
	op = op.replaceAll(RegExp(r'\(|\)'), "");
	String k = op.split(':').first.mini();
	String v = op.split(':').last.mini();

	if(k == "prefers-color-scheme"){
		return (v == "dark") == settingModes['dMode'];
	}

	return false;
}




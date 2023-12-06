import 'package:flutter/material.dart';

/*
Using nerd-font icons
widget method is not selectable text
but span can be selectable 
Issue: widget cna't add as textSpan
*/

TextSpan __span(String unicode, double? size, Color? color){
	return TextSpan(
		text: "$unicode ", // half-space: U+2009
		style: TextStyle(
			fontFamily: "SauceCodeProNerdFont",
			fontSize: size,
			color: color,
		),
	);
}


class NfFont {
	final String unicode;
	final double? size;
	final Color? color;
	
	NfFont({
		required this.unicode,
		this.size,
		this.color});

	Widget widget(){
		return RichText(text: __span(unicode, size, color));
	}

	// TextSpan span({bool selectable = true}){
	TextSpan span({bool selectable = true}){
		return __span(unicode, size, color);
	}
}


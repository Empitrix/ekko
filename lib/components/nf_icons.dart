import 'package:flutter/material.dart';


TextSpan __span(String unicode, double? size, Color? color, bool format){
	return TextSpan(
		text: format ? "$unicode " : unicode, // half-space: U+2009
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
	final bool format;
	
	NfFont({
		required this.unicode,
		this.size,
		this.format = true,
		this.color});

	Widget widget(){
		return RichText(text: __span(unicode, size, color, format));
	}

	TextSpan span({bool selectable = true}){
		return __span(unicode, size, color, format);
	}
}


import 'package:flutter/material.dart';


TextSpan __span(String unicode, double? size, Color? color, bool format, [int f = 0]){
	return TextSpan(
		text: format ? "$unicode${'\u2009' * f}" : unicode, // half-space: U+2009
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
	final int f;
	
	NfFont({
		required this.unicode,
		this.size,
		this.f = 1,
		this.format = true,
		this.color});

	Widget widget(){
		return RichText(text: __span(unicode, size, color, format, f));
	}

	TextSpan span({bool selectable = true}){
		return __span(unicode, size, color, format, f);
	}
}


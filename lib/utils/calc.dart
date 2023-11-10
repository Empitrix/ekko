import 'package:flutter/material.dart';

/* Calculate text size */
Size calcTextSize(
	BuildContext context, String text, style){
	return (TextPainter(
		text: TextSpan(text: text, style: style),
		maxLines: 1,
		textScaleFactor: MediaQuery.of(context).textScaleFactor,
		textDirection: TextDirection.ltr)..layout()).size;
}

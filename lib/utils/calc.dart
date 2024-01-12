import 'package:ekko/config/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/* Calculate text size */
Size calcTextSize(
	BuildContext context, String text, [TextStyle? style]){
	return (TextPainter(
		text: TextSpan(
			text: text,
			style: style ?? Provider.of<ProviderManager>(context, listen: false).defaultStyle
		),
		maxLines: 1,
		textScaler: MediaQuery.of(context).textScaler,
		textDirection: TextDirection.ltr)..layout()).size;
}

import 'package:flutter/material.dart';


TextSpan formatTableBorder(TextSpan input, TextStyle borderStyle, [bool only = false]){
	// if(input.text == null){
	// 	return TextSpan(text: input.toPlainText(), style: borderStyle);
	// }
	List<TextSpan> spans = [];
	input.toPlainText().splitMapJoin(
		only ?
			RegExp(r'\|', multiLine: true):
			RegExp(r'(\||\-|\-*\:|\:\-*|\:\-*\:)', multiLine: true),
		onMatch: (Match m){
			spans.add(TextSpan(text: m.group(0)!, style: borderStyle));
			return "";
		},
		onNonMatch: (n){
			spans.add(TextSpan(text: n, style: input.style));
			return "";
		}
	);
	return TextSpan(children: spans);
}


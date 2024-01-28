import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';


List<RegexFormattingStyle> allFieldRules(BuildContext context){
	return <RegexFormattingStyle>[

		// {@Syntax}
		RegexActionStyle(
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?'),
			style: TextStyle(
				color: dMode ? Colors.cyan: Colors.indigo
			),
			action: (String txt, Match match){
				Match fM = RegExp(r'\s?```').firstMatch(txt)!;  // First Match
				Match lM = RegExp(r'```\s?').allMatches(txt).last;  // Last
				Match? nM;
				try{
					nM = RegExp(r'(?<=(?:```))\s*\w+').firstMatch(txt)!;  // Name
				} catch(_) {}
				TextStyle store = const TextStyle(
					color: Colors.purpleAccent, fontWeight: FontWeight.bold);
				List<TextSpan> spans = (nM != null) ? [
					// First Part
					TextSpan(
						text: txt.substring(fM.start, fM.end),
						style: store),
					// Name Part
					TextSpan(
						text: txt.substring(nM.start, nM.end),
						style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
					// Content Part
					TextSpan(
						text: txt.substring(nM.end, lM.start),
						style: TextStyle(color: dMode ? Colors.cyan: Colors.indigo)),
					// End Part
					TextSpan(
						text: txt.substring(lM.start, lM.end),
						style: store),
				] : [
						TextSpan(text: txt)
				];
				return TextSpan(children: spans);
			}
		),

		// {@Headline}
		RegexGroupStyle(
			regex: RegExp(r'^#{1,6} [\s\S]*?$'),
			style: const TextStyle(fontWeight: FontWeight.bold),
			regexStyle: RegexStyle(
				regex: RegExp(r'^\#{1,6}\s?'),
				style: const TextStyle(
					color: Colors.red,
					fontWeight: FontWeight.bold
				),
			)
		),
		
		// {@Divider}
		RegexFormattingStyle(
			regex: RegExp(r'^(\-\-\-|\+\+\+|\*\*\*)$'),
			style: const TextStyle(color: Colors.red),
		),

		// {@Monospace}
		RegexGroupStyle(
			regex: RegExp(r'\`.*?\`'),
			style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
			regexStyle: RegexStyle(
				regex: RegExp(r'\`'),
				style: const TextStyle(
					color: Colors.orange,
				),
			)
		),




		// Check-Box
		// RegexPatternTextStyle(
		// 	// regexPattern: r"^\s*\-\s{1}\[(\s{1}|\x)\]\s{1}",
		// 	regexPattern: r"^\s*(-|\*|\+)\s{1}\[(\s{1}|\x)\]\s{1}",
		// 	action: (txt, match){
		// 		int openingIdx = txt.split("").indexOf("[") + 1; 
		// 		return TextSpan(
		// 			children: [
		// 				TextSpan(
		// 					text: txt.substring(0, openingIdx),
		// 					style: const TextStyle(color: Colors.orange)),
		// 				TextSpan(text: txt.substring(openingIdx, openingIdx + 1)),
		// 				TextSpan(
		// 					text: txt.substring(openingIdx + 1),
		// 					style: const TextStyle(color: Colors.orange)),
		// 			],
		// 		);
		// 	},
		// ),
		// 
		// // Headline 1..6
		// RegexPatternTextStyle(
		// 	regexPattern: r"^#{1,6} [\s\S]*?$",
		// 	action: (txt, match){
		// 		int end = "#$txt".lastIndexOf("## ") + 1;
		// 		return TextSpan(
		// 			children: [
		// 				TextSpan(
		// 					text: txt.substring(0, end),
		// 					style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900)
		// 				),
		// 				TextSpan(
		// 					text: txt.substring(end),
		// 					style: const TextStyle(fontWeight: FontWeight.w900)
		// 				),
		// 			],
		// 		);
		// 	},
		// ),

	];
}

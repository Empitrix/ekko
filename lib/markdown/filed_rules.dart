import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';


List<RegexGroupStyle> allFieldRules(BuildContext context){
	return <RegexGroupStyle>[
		// {@Syntax}
		RegexGroupStyle(
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?'),
			style: TextStyle(
				// fontWeight: FontWeight.bold,
				color: dMode ? Colors.cyan: Colors.indigo
			),
			regexStyles: [
				RegexStyle(
					regex: RegExp(r'\`\`\`'),
					style: const TextStyle(
						color: Colors.deepOrange,
						// fontWeight: FontWeight.bold
					),
				),
				// RegexStyle(
				// 	regex: RegExp(r'```\s*\w+'),
				// 	style: const TextStyle(
				// 		color: Colors.blue,
				// 		fontWeight: FontWeight.bold
				// 	),
				// ),
			]
		),

		// {@Headline}
		RegexGroupStyle(
			regex: RegExp(r'^#{1,6} [\s\S]*?$'),
			style: const TextStyle(fontWeight: FontWeight.bold),
			regexStyles: [
				RegexStyle(
					regex: RegExp(r'^\#{1,6}\s?'),
					style: const TextStyle(
						color: Colors.red,
						fontWeight: FontWeight.bold
					),
				)
			]
		),
		
		// {@Divider}
		RegexGroupStyle(
			regex: RegExp(r'^(\-\-\-|\+\+\+|\*\*\*)$'),
			style: const TextStyle(color: Colors.red),
			regexStyles: []
		),

		// {@Monospace}
		RegexGroupStyle(
			regex: RegExp(r'\`.*?\`'),
			style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
			regexStyles: [
				RegexStyle(
					regex: RegExp(r'\`'),
					style: const TextStyle(
						color: Colors.orange,
					),
				),
			]
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

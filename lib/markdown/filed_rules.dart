import 'package:flutter/material.dart';
import 'package:regex_pattern_text_field/regex_pattern_text_field.dart';

List<RegexPatternTextStyle> allFieldRules(BuildContext context){
	return <RegexPatternTextStyle>[
		// Check-Box
		RegexPatternTextStyle(
			regexPattern: r"^\s*\-\s{1}\[(\s{1}|\x)\]\s{1}",
			action: (txt, match){
				int openingIdx = txt.split("").indexOf("[") + 1; 
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, openingIdx),
							style: const TextStyle(color: Colors.orange)),
						TextSpan(text: txt.substring(openingIdx, openingIdx + 1)),
						TextSpan(
							text: txt.substring(openingIdx + 1),
							style: const TextStyle(color: Colors.orange)),
					],
				);
			},
		),
		
		// Headline 1..6
		RegexPatternTextStyle(
			regexPattern: r"^#{1,6} [\s\S]*?$",
			action: (txt, match){
				int end = "#$txt".lastIndexOf("## ") + 1;
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, end),
							style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900)
						),
						TextSpan(
							text: txt.substring(end),
							style: const TextStyle(fontWeight: FontWeight.w900)
						),
					],
				);
			},
		),

	];
}

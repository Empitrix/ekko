import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/table_field.dart';
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
		
		// {@Table}
		RegexActionStyle(
			regex: RegExp(r'(?!smi)(\|[\s\S]*?)\|(?:\n)$'),
			style: const TextStyle(),
			action: (String txt, _){
				TextStyle borderStyle = const TextStyle(color: Colors.orange);
				if(txt.trim().split("\n").length < 3){
					return TextSpan(text: txt);}
				List<String> lines = txt.split('\n');
				return TextSpan(children: [
					formatTableBorder(
						TextSpan(text: "${lines[0]}\n",
							style: const TextStyle(
								fontWeight: FontWeight.bold, color: Colors.cyan)),
						borderStyle),
					formatTableBorder(
						TextSpan(text: "${lines[1]}\n"), borderStyle),
					formatTableBorder(
						TextSpan(text: lines.sublist(2).join("\n")), borderStyle, true)
				]);
			}
		),

		// {@CheckBox}
		RegexActionStyle(
			regex: RegExp(r"^\s*(-|\*|\+)\s{1}\[(\s{1}|\x)\]\s{1}"),
			style: const TextStyle(),
			action: (txt, match){
				int openingIdx = txt.split("").indexOf("[") + 1; 
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, openingIdx),
							style: const TextStyle(color: Colors.orange)),
						TextSpan(text: txt.substring(openingIdx, openingIdx + 1),
							style: const TextStyle(
								color: Colors.cyan, fontWeight: FontWeight.bold)),
						TextSpan(
							text: txt.substring(openingIdx + 1),
							style: const TextStyle(color: Colors.orange)),
					],
				);
			},
		),

		// {@Italic-Bold-Italic&Bold}
		RegexActionStyle(
			regex: RegExp(r"\*\*\*.*?\*\*\*|\*\*.*?\*\*|\*.*?\*"),
			style: const TextStyle(),
			action: (txt, match){
				int asteriskNum = RegExp(r'\*').allMatches(txt).length;
				if(asteriskNum % 2 != 0){ asteriskNum--; }
				asteriskNum = asteriskNum ~/ 2;
				const TextStyle asteriskStyle = TextStyle(
					color: Colors.deepOrange, fontWeight: FontWeight.w500);
				// Get plain text style
				TextStyle plainStyle = 
					asteriskNum == 3 ? const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic):
					asteriskNum == 2 ? const TextStyle(fontWeight: FontWeight.bold):
					const TextStyle(fontStyle: FontStyle.italic);
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, asteriskNum),
							style: asteriskStyle
						),
						TextSpan(
							text: txt.substring(asteriskNum, txt.length - asteriskNum),
							style: plainStyle,
						),
						TextSpan(
							text: txt.substring(txt.length - asteriskNum),
							style: asteriskStyle
						),
					]
				);
			},
		),



	];
}

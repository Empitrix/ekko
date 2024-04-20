import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:ekko/markdown/table_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:path/path.dart';


List<RegexFormattingStyle> allFieldRules(BuildContext context){

	TextStyle reApplyStyle = Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(
		color: Theme.of(context).colorScheme.inverseSurface,
		fontFamily: "RobotoMono"
	);
	ReApplyFieldRules reApply = ReApplyFieldRules(context: context, style: reApplyStyle);


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
						style: TextStyle(color: dMode ? Colors.grey : Colors.grey[700])),
					// Content Part
					/*
					TextSpan(
						text: txt.substring(nM.end, lM.start),
						style: TextStyle(color: dMode ? Colors.cyan: Colors.indigo)),
					*/
					HighlightView(
						txt.substring(nM.end, lM.start),
						language: txt.substring(nM.start, nM.end).trim().toLowerCase(),
						tabSize: 2,
						theme: allMarkdownThemes['atom-one-${dMode ? "dark" : "light"}']!,
					).getSpan(style: const TextStyle(fontFamily: "SauceCodeProNerdFont")),

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

		/*
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
		*/
		
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

		// {@Item}
		RegexActionStyle(
			regex: RegExp(r'^\s*(-|\+|\*)\s+.+$'),
			style: const TextStyle(),
			action: (txt, match){
				RegExpMatch char = RegExp(r'(-|\+|\*)').firstMatch(txt)!;
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, char.end),
							style: const TextStyle(
								color: Colors.deepOrange, fontWeight: FontWeight.bold)
						),
						reApply.parse(txt.substring(char.end)),
						// TextSpan(text: txt.substring(char.end))
					]
				);
			},
		),

		// {@Hyper-Link}
		RegexActionStyle(
			regex: RegExp(r'(?<!\!)\[((?:\[[^\]]*\]|[^\[\]])*)\]\(([\s\S]*?)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			style: const TextStyle(),
			action: (txt, match){
				TextStyle txtStyle = const TextStyle(color: Colors.blue);
				Match lastWhere = RegExp(r'(\)|\])(\(|\[)').allMatches(txt).last;
				List<TextSpan> parts = [];
				txt.substring(lastWhere.start).splitMapJoin(
					RegExp(r'(\(|\)|\[|\])'),
					onMatch: (Match m){
					parts.add(TextSpan(text: m.group(0)!, style: txtStyle));
						return "";
					},
					onNonMatch: (n){
						parts.add(TextSpan(text: n,
							style: TextStyle(color: Colors.blue[700],
							decoration: TextDecoration.underline,
							decorationColor: Colors.blue[700])));
						return "";
					}
				);
				return TextSpan(
					// style: Provider.of<ProviderManager>(context).defaultStyle,
					children: [
						TextSpan(text: txt.substring(0, 1), style: txtStyle),
						reApply.parse(txt.substring(1, lastWhere.start)),
						// TextSpan(text: txt.substring(1, lastWhere.start),
						// 	style: const TextStyle(color: Colors.white,
						// 	fontWeight: FontWeight.bold)),
						// // TextSpan(text: txt.substring(lastWhere.start), style: txtStyle),
						...parts
					]
				);
			}
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


		// {@Latex}
		RegexActionStyle(
			regex: RegExp(r'\$\$(.|\n)*?\$\$|\$(.|\n)*?\$'),
			style: const TextStyle(color: Colors.brown),
			action: (txt, match){
				List<TextSpan> spans = [];
				txt.splitMapJoin(
					RegExp(r'^(\$\$|\$)|(\$\$|\$)$', multiLine: true),
					onMatch: (Match end){
						spans.add(TextSpan(text: end.group(0)!, style: TextStyle(color: Colors.pink[600])));
						return "";
					},
					onNonMatch: (n){
						n.splitMapJoin(
							RegExp(r'(\\(\w+|\W))|(?<=\{)\w+(?=\})'),
							onMatch: (Match word){
								String m = word.group(0)!;
								if(m.replaceAll(RegExp(r'(?<!\\|\s)\w+'), "").isEmpty){
									// spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.cyan)));
									spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.green)));
								} else {
									if(m.contains(RegExp(r'\\\W'))){
										spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.red)));
									} else {
										spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.blue)));
									}
								}
								return "";
							},
							onNonMatch: (non){
								// spans.add(TextSpan(text: non, style: const TextStyle(fontStyle: FontStyle.italic)));
								spans.add(TextSpan(text: non));
								return "";
							}
						);
						return "";
					}
				);
				return TextSpan(children: spans);
			}
		),


		// {@Emoji}
		RegexGroupStyle(
			regex: RegExp(r'\:\w+\:'),
			style: const TextStyle(color: Color(0xff94b2e3)),
			regexStyle: RegexStyle(
				regex: RegExp(r':'),
				style: const TextStyle(
					color: Colors.orange,
				),
			)
		),

		// {@Italic-Bold-Italic&Bold}
		RegexActionStyle(
			regex: RegExp(r'(\*\*\*|\_\_\_).*?(\*\*\*|\_\_\_)|(\*\*|\_\_).*?(\*\*|\_\_)|(\*|\_).*?(\*|\_)'),
			style: const TextStyle(),
			action: (txt, match){
				int specialChar = RegExp(r'(\*|\_)').allMatches(txt).length;
				if(specialChar % 2 != 0){ specialChar--; }
				specialChar = specialChar ~/ 2;
				const TextStyle asteriskStyle = TextStyle(
					color: Colors.deepOrange, fontWeight: FontWeight.w500);
				// Get plain text style
				TextStyle plainStyle = 
					specialChar == 3 ? const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic):
					specialChar == 2 ? const TextStyle(fontWeight: FontWeight.bold):
					const TextStyle(fontStyle: FontStyle.italic);
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, specialChar),
							style: asteriskStyle),
						TextSpan(
							text: txt.substring(specialChar, txt.length - specialChar),
							style: plainStyle),
						TextSpan(
							text: txt.substring(txt.length - specialChar),
							style: asteriskStyle),
					]
				);
			},
		),

		// {@Strike}
		RegexFormattingStyle(
			regex: RegExp(r'~~.*~~'),
			style: TextStyle(
				decoration: TextDecoration.lineThrough,
				decorationColor: Theme.of(context).colorScheme.inverseSurface
			)
		),


		// {@Backqoute}
		RegexActionStyle(
			regex: RegExp(r'^>\s+.*(?:\n>\s+.*)*'),
			style: const TextStyle(),
			action: (txt, match){
				TextStyle style = const TextStyle(fontStyle: FontStyle.italic);
				List<String> lines = txt.split("\n");
				String firstLineTxt = "${lines.first}\n";
				bool firstLineHasMatch = false;

				// Not Enough
				if(lines.length == 1){
					return TextSpan(text: txt, style: style);
				}

				if(firstLineTxt.contains(RegExp(r'\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]'))){
					firstLineHasMatch = true;
				}

				List<TextSpan> spans = [];
				firstLineTxt.splitMapJoin(
					RegExp(r'\w+| +'),
					onMatch: (Match match){
						String i = match.group(0)!;
						if(i.contains(RegExp(r'(NOTE|TIP|IMPORTANT|WARNING|CAUTION)'))){
							spans.add(TextSpan(text: i, style: TextStyle(
								color: Colors.red,
								decoration: TextDecoration.underline,
								decorationThickness: 0.5,
								fontStyle: FontStyle.italic,
								decorationColor: Theme.of(context).colorScheme.inverseSurface
							)));
						}else {
							spans.add(TextSpan(text: i, style: style));
						}
						return "";
					},
					onNonMatch: (n){
					 if(n.contains(RegExp(r'\[|\]')) && firstLineHasMatch){
							spans.add(TextSpan(text: n, style: TextStyle(
								color: Colors.pink,
								decoration: TextDecoration.underline,
								decorationThickness: 0.5,
								fontWeight: FontWeight.bold,
								decorationColor: Theme.of(context).colorScheme.inverseSurface
							)));
						} else {
							spans.add(TextSpan(text: n, style: style));
						}
						return "";
					}
				);

				return TextSpan(
					children: [
						TextSpan(children: spans),
						TextSpan(text: lines.sublist(1).join("\n"), style: style),
					]
				);

			},
		),




		// {@HTML}
		RegexActionStyle(
			regex: RegExp(r'( )*(<.*>\s*)+?(?=\s$|$)|<.*>.*?<\/\w+>', multiLine: true),
			style: const TextStyle(),
			action: (String txt, Match match){
				List<TextSpan> spans = [];
				txt.splitMapJoin(
					RegExp(r'''(<\w+|\w+=(".*?"|'.*?')|>|\/>|<\/\w+>)''', multiLine: true),
					onMatch: (Match m){
						String txt = m.group(0)!;
						if(txt.contains(RegExp(r'''\w+=(".*?"|'.*?')'''))){
							txt.splitMapJoin(
								RegExp(r'\='),
								onMatch: (Match e){
									spans.add(TextSpan(
										text: e.group(0)!,
										style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface)
									));
									return "";
								},
								onNonMatch: (String non){
									if(non.contains(RegExp('''("|')'''))){
										spans.add(TextSpan(
											text: non,
											style: const TextStyle(color: Color(0xff719E07))
										));
									} else {
										spans.add(TextSpan(
											text: non,
											style: const TextStyle(color: Color(0xff268BD2))
										));
									}
									return "";
								}
							);
						} else {
							txt.splitMapJoin(
								RegExp(r'\w+'),
								onMatch: (Match m){
									spans.add(TextSpan(
										text: m.group(0)!,
										style: const TextStyle(color: Colors.green)
									));
									return "";
								},
								onNonMatch: (n){
									spans.add(TextSpan(
										text: n,
										style: const TextStyle(color: Colors.red)
									));
									return "";
								}
							);
						}
						return "";
					},
					onNonMatch: (String n){
						spans.add(TextSpan(text: n));
						return "";
					}
				);
				return TextSpan(children: spans);
			}
		),


	];
}



class ReApplyFieldRules {
	final BuildContext context;
	final TextStyle style;
	ReApplyFieldRules({required this.context, required this.style});

	TextSpan parse(String input){
		return ApplyRegexFormattingStyle(
			content: input,
			rules: allFieldRules(context),
			textStyle: style
		).build();
	}
}


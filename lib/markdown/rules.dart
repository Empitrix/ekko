import 'package:ekko/backend/launcher.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/monospace.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regex_pattern_text_field/regex_pattern_text_field.dart';


List<HighlightRule> allSyntaxRules(BuildContext context){
	List<HighlightRule> rules = [
		// Markdown
		HighlightRule(
			label: "markdown",
			action: (String text) => WidgetSpan(
				child: MarkdownWidget(
					content: text,
					height: Provider.of<ProviderManager>(context).defaultStyle.height!,
				)
			),
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
		),

		// Headline 6
		HighlightRule(
			label: "headline6",
			action: (txt) => TextSpan(
				text: txt.substring(7),
				style: getHeadlineStyle(context, 6)
			),
			regex: RegExp(r'^###### [\s\S]*?$'),
		),

		// Headline 5
		HighlightRule(
			label: "headline5",
			action: (txt) => TextSpan(
				text: txt.substring(6),
				style: getHeadlineStyle(context, 5)
			),
			regex: RegExp(r'^##### [\s\S]*?$'),
		),

		// Headline 4
		HighlightRule(
			label: "headline4",
			action: (txt) => TextSpan(
				text: txt.substring(5),
				style: getHeadlineStyle(context, 4)
			),
			regex: RegExp(r'^#### [\s\S]*?$'),
		),

		// Headline 3
		HighlightRule(
			label: "headline3",
			action: (txt) => TextSpan(
				text: txt.substring(4),
				style: getHeadlineStyle(context, 3)
			),
			regex: RegExp(r'^### [\s\S]*?$'),
		),
		
		// Headline 2
		HighlightRule(
			label: "headline2",
			action: (txt) => TextSpan(
				text: txt.substring(3),
				style: getHeadlineStyle(context, 2)
			),
			regex: RegExp(r'^## [\s\S]*?$'),
		),

		// Headline 1
		HighlightRule(
			label: "headline1",
			action: (txt) => TextSpan(
				text: txt.substring(2),
				style: getHeadlineStyle(context, 1)
			),
			regex: RegExp(r'^# [\s\S]*?$'),
		),

		// Divider
		HighlightRule(
			label: "divider",
			trimNext: true,
			action: (_) => const WidgetSpan(
				child: Divider(height: 1)
			),
			regex: RegExp(r'^\s*---\s*$'),
		),

		// Sublist CheckedBox
		HighlightRule(
			label: "checkbox",
			action: (txt){
				bool isChecked = 
					txt.trim().substring(0, 5).contains("x");
				Widget leading = onLeadingText(
					topMargin: 11,
					leading: SizedBox(
						width: 18,
						height: 0,
						child: Transform.scale(
							scale: 0.8,
							// scale: 1,
							child: IgnorePointer(
								child: Checkbox(
									value: isChecked,
									onChanged: null
								),
							),
						) ,
					),
					text: TextSpan(
						children: formattingTexts(
							context: context,
							content: txt.trim().substring(5).trim(),  // Rm <whitespaces>
						)
					)
				);
				return WidgetSpan(child: leading);
			},
			regex: RegExp(r'^-\s{1}(\[ \]|\[x\])\s+(.*)$'),
		),

		// Sublist - Item
		HighlightRule(
			label: "item",
			action: (txt){
				int indentedLvl = (tillFirstLetter(txt) / 2).floor();
				Widget leading = onLeadingText(
					leading: Icon(
						indentedLvl == 0 ? Icons.circle :
						indentedLvl == 2 ? Icons.circle_outlined :
						Icons.square,
						size: 10),
					spacing: (indentedLvl ~/ 2) * 20,
					topMargin: 7,
					text: TextSpan(
						children: formattingTexts(
							context: context,
							content: txt.trim().substring(1).trim(),
						)
					)
				);
				return WidgetSpan(child: leading);
			},
			regex: RegExp(r'^\s*-\s+.+$'),
		),


		// Monospace
		HighlightRule(
			label: "monospace",
			action: (txt) => getMonospaceTag(
				txt.substring(1, txt.length - 1)
			),
			regex: RegExp(r'\`.*?\`', multiLine: true),
		),


		// Links
		HighlightRule(
			label: "links",
			regex: RegExp(r'\[.*\]\(.*\)'),
			action: (txt){
				String name = txt.split("](")[0]
					.substring(1).trim();
				String link = txt.split("](")[1].trim();
				link = link.substring(0, link.length - 1).trim();
				TextStyle linkStyle = const TextStyle(
					fontSize: 16,
					decoration: TextDecoration.underline,
					decorationColor: Colors.blue,
					color: Colors.blue,
				);
				return TextSpan(
					children: formattingTexts(
						context: context,
						content: name,
						recognizer: TapGestureRecognizer()..onTap = () async {
							await launchThis(
								context: context, url: link);
							debugPrint("Opening: $link"); 
						},
						mergeStyle: linkStyle,
					),
				);
			}
		),

		// URL
		HighlightRule(
			label: "url",
			action: (txt) => TextSpan(
				text: txt,
				style: const TextStyle(
					color: Colors.blue,
					decorationColor: Colors.blue,
					decoration: TextDecoration.underline
				),
				recognizer: TapGestureRecognizer()..onTap = () async {
					await launchThis(
						context: context, url: txt);
					debugPrint("Opening: $txt"); 
				},
			),
			regex: RegExp(r'(https?://\S+)'),
		),

		// Italic & Bold
		HighlightRule(
			label: "italic_bold",
			action: (txt) => TextSpan(
				text: txt.substring(3, txt.length - 3),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold,
					fontStyle: FontStyle.italic
				)
			),
			regex: RegExp(r'\*\*\*(.*?)\*\*\*'),
		),

		// Bold
		HighlightRule(
			label: "boldness",
			action: (txt) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold
				)
			),
			regex: RegExp(r'\*\*(.*?)\*\*'),
		),

		// Italic
		HighlightRule(
			label: "italic",
			action: (txt) => TextSpan(
				text: txt.substring(1, txt.length - 1),
				style: const TextStyle(
					fontSize: 16,
					fontStyle: FontStyle.italic
				)
			),
			regex: RegExp(r'\*(.*?)\*'),
		),

		HighlightRule(
			label: "strike",
			action: (txt) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				style: TextStyle(
					fontSize: 16,
					decorationColor: Theme.of(context).colorScheme.inverseSurface,
					decorationStyle: TextDecorationStyle.solid,
					decoration: TextDecoration.lineThrough
				)
			),
			regex: RegExp(r'~~.*~~'),
		),

		// Backqoute
		HighlightRule(
			label: "backqoute",
			action: (txt){
				txt = txt.trim().substring(1);
				return WidgetSpan(
					child: Column(
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Row(
								children: [
									const SizedBox(
										height: 30,
										child: VerticalDivider()),
									const SizedBox(width: 10),
									Expanded( child: SingleChildScrollView(
										controller: ScrollController(),
										scrollDirection: Axis.horizontal,
										child: Column(
											children: [
												Text(
													txt,
													style: const TextStyle(
														fontStyle: FontStyle.italic),
												)
											],
										),
									))
								],
							),
						],
					)
				);
			},
			regex: RegExp(r'^\s*>\s+.+$'),
		),
	];

	return rules;
}


List<RegexPatternTextStyle> allFieldRules(BuildContext context){
	return <RegexPatternTextStyle>[
		// Check-Box
		RegexPatternTextStyle(
			regexPattern: r"^\s*\-\s{1}\[(\s{1}|\x)\]",
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



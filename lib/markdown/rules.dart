import 'package:ekko/backend/launcher.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

List<HighlightRule> allSyntaxRules({
	required BuildContext context,
	required double textHeight,
	required TextStyle defaultStyle,
}){
	List<HighlightRule> rules = [
		// Markdown
		HighlightRule(
			tag: "markdown",
			action: (String text) => MarkdownWidget(
				content: text, height: textHeight),
			regex: RegExp(r'\s```([\s\S]*?)```\s'),
			style: const TextStyle(color: Colors.cyan)
		),


		// Links
		HighlightRule(
			tag: "links",
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


				TextSpan linkSpan = TextSpan(
					children: formattingTexts(
						context: context,
						content: name,
						recognizer: TapGestureRecognizer()..onTap = () async {
							await launchThis(
								context: context, url: link);
							debugPrint("Opening: $link"); 
						},
						mergeStyle: linkStyle,
						defaultStyle: defaultStyle,
					),
				);

				return Row(
					children: [
						Expanded(
							child: Text.rich(linkSpan)
							// Text.rich(
							// 	TextSpan(
							// 		children: [linkSpan], 
							// 		recognizer: TapGestureRecognizer()..onTap = () async {
							// 			await launchThis(
							// 				context: context, url: link);
							// 			debugPrint("Opening: $link"); 
							// 		},
							// 	)
							// )
						)
					],
				);
			},
			regex: RegExp(r'^\[.*\]\(.*\)$'),
			style: const TextStyle(
				fontSize: 16,
				decoration: TextDecoration.underline,
				color: Colors.blue
			)
		),



		// URL
		HighlightRule(
			tag: "url",
			regex: RegExp(r'(https?://\S+)'),
			style: const TextStyle(
				color: Colors.blue,
				decorationColor: Colors.blue,
				decoration: TextDecoration.underline
			)
		),

		// Headlines
		HighlightRule(
			tag: "headline6",
			action: (_) => const SizedBox(),
			regex: RegExp(r'^###### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w100,
				fontSize: 13.6
			),
		),
		HighlightRule(
			tag: "headline5",
			action: (_) => const SizedBox(),
			regex: RegExp(r'^##### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w200,
				fontSize: 14
			),
		),
		HighlightRule(
			tag: "headline4",
			action: (_) => const SizedBox(),
			regex: RegExp(r'^#### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w300,
				fontSize: 16
			),
		),
		HighlightRule(
			tag: "headline3",
			action: (_) => const SizedBox(),
			regex: RegExp(r'^### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w400,
				fontSize: 20
			),
		),
		HighlightRule(
			tag: "headline2",
			action: (_) => const SizedBox(),
			regex: RegExp(r'^## [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w500,
				fontSize: 24
			),
		),
		HighlightRule(
			tag: "headline1",
			action: (_) => const SizedBox(),
			regex: RegExp(r'^# [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w600,
				fontSize: 32
			)
		),

		// Divider
		HighlightRule(
			tag: "divider",
			action: (_) => const Divider(height: 1),
			regex: RegExp(r'^\s*---\s*$'),
			style: const TextStyle()
		),
		

		// Sublist CheckedBox
		HighlightRule(
			tag: "checkbox",
			action: (txt){
				bool isChecked = 
					txt.trim().substring(0, 5).contains("x");
				return onLeadingText(
					leading: SizedBox(
						width: 15,
						child: Transform.scale(
							scale: 0.8,
							child: IgnorePointer(
								child: Checkbox(
									value: isChecked,
									onChanged: (_){} 
								),
							),
						) ,
					),
					text: TextSpan(
						text: txt.trim().substring(5),
						style: defaultStyle
					)
				);
			},
			regex: RegExp(r'^-\s{1}(\[ \]|\[x\])\s+(.*)$'),
			style: const TextStyle()
		),

		// Sublist - Item
		HighlightRule(
			tag: "item",
			action: (txt){
				int indentedLvl = (tillFirstLetter(txt) / 2).floor();
				return onLeadingText(
					leading: Icon(
						indentedLvl == 0 ? Icons.circle :
						indentedLvl == 2 ? Icons.circle_outlined :
						Icons.square,
						size: 10),
					spacing: (indentedLvl ~/ 2) * 20,
					text: TextSpan(
						children: formattingTexts(
							context: context,
							content: txt.trim().substring(1),
							defaultStyle: defaultStyle
						)
					)
				);
			},
			// regex: RegExp(r'^-\s.+$'),
			regex: RegExp(r'^\s*-\s+.+$'),
			style: const TextStyle()
		),
		


		// Italic & Bold
		HighlightRule(
			tag: "italic_bold",
			regex: RegExp(r'\*\*\*(.*?)\*\*\*'),
			style: const TextStyle(
				fontSize: 16,
				fontWeight: FontWeight.bold,
				fontStyle: FontStyle.italic
			)
		),

		// Bold
		HighlightRule(
			tag: "boldness",
			regex: RegExp(r'\*\*(.*?)\*\*'),
			// regex: RegExp(r'\*\*(\w+)\*\*'),
			style: const TextStyle(
				fontSize: 16,
				fontWeight: FontWeight.bold
			)
		),

		// Italic
		HighlightRule(
			tag: "italic",
			regex: RegExp(r'\*(.*?)\*'),
			style: const TextStyle(
				fontSize: 16,
				fontStyle: FontStyle.italic
			)
		),







	];

	return rules;
}

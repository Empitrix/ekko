import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';

List<HighlightRule> allSyntaxRules({
	required BuildContext context,
}){
	List<HighlightRule> rules = [
		// Markdown
		HighlightRule(
			tag: "markdown",
			action: (String text) => MarkdownWidget(
				content: text, height: textHeight),
			// regex: RegExp(r'\s```([\s\S]*?)```\s'),
			// regex: RegExp(r'\s*```\s*\w+\n*([\s\S]*?)\n\s*```\s*', multiLine: true),
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
			style: const TextStyle(color: Colors.teal)
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
				fontWeight: FontWeight.bold,
				letterSpacing: 0.9,
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
				letterSpacing: 0.9,
				fontSize: 32
			)
		),

		// Divider
		HighlightRule(
			tag: "divider",
			action: (_) => const Divider(height: 1),
			regex: RegExp(r'^\s*---\s*$'),
			style: const TextStyle(color: Colors.red)
		),
		

		// Sublist CheckedBox
		HighlightRule(
			tag: "checkbox",
			action: (txt){
				bool isChecked = 
					txt.trim().substring(0, 5).contains("x");
				return onLeadingText(
					leading: SizedBox(
						// width: 15,
						width: 18,
						height: 0,
						child: Transform.scale(
							scale: 0.8,
							// scale: 1,
							child: IgnorePointer(
								child: Checkbox(
									value: isChecked,
									// onChanged: (_){} 
									onChanged: null
								),
							),
						) ,
					),
					// text: TextSpan(
					// 	text: txt.trim().substring(5),
					// 	style: defaultStyle
					// ),
					text: TextSpan(
						children: formattingTexts(
							context: context,
							// content: txt.trim().substring(5),
							content: txt.trim().substring(5).trim(),  // Rm <whitespaces>
							defaultStyle: defaultStyle
						)
					)
				);
			},
			regex: RegExp(r'^-\s{1}(\[ \]|\[x\])\s+(.*)$'),
			style: const TextStyle(color: Colors.indigoAccent)
		),

		// Sublist - Item
		HighlightRule(
			tag: "item",
			action: (txt){
				int indentedLvl = (tillFirstLetter(txt) / 2).floor();
				// // int indentedLvl = (tillFirstLetter(txt) / 2).ceil();
				// int indentedLvl = (tillFirstLetter(txt) / 2).toInt();
				// print(indentedLvl);
				return onLeadingText(
					leading: Icon(
						indentedLvl == 0 ? Icons.circle :
						indentedLvl == 2 ? Icons.circle_outlined :
						Icons.square,
						size: 10),
					// spacing: (indentedLvl ~/ 2) * 20,
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
			style: const TextStyle(color: Colors.deepOrange)
		),
		

		// Links
		HighlightRule(
			tag: "links",
			// regex: RegExp(r'^\[.*\]\(.*\)$'),
			regex: RegExp(r'\[.*\]\(.*\)'),
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

		HighlightRule(
			tag: "strike",
			regex: RegExp(r'~~.*~~'),
			style: TextStyle(
				fontSize: 16,
				decorationColor: Theme.of(context).colorScheme.inverseSurface,
				decorationStyle: TextDecorationStyle.solid,
				decoration: TextDecoration.lineThrough
			),
		),

		HighlightRule(
			tag: "backqoute",
			action: (txt){
				txt = txt.trim().substring(1);
				return Column(
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
										children: [ Text(txt) ],
									),
								))
							],
						),
					],
				);
			},
			regex: RegExp(r'^\s*>\s+.+$'),
			style: const TextStyle(fontStyle: FontStyle.italic)
		),



	];

	return rules;
}

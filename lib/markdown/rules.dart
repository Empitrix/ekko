import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';

List<HighlightRule> allSyntaxRules({
	required BuildContext context,
	required double textHeight,
	required TextStyle defaultStyle,
}){
	return [
		// Markdown
		HighlightRule(
			tag: "markdown",
			action: (String text) => MarkdownWidget(
				content: text, height: textHeight),
			regex: RegExp(r'\s```([\s\S]*?)```\s'),
			style: const TextStyle(color: Colors.cyan)
		),

		// URL
		HighlightRule(
			tag: "url",
			action: null,
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
			action: null,
			regex: RegExp(r'^###### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w100,
				fontSize: 13.6
			),
		),
		HighlightRule(
			tag: "headline5",
			action: null,
			regex: RegExp(r'^##### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w200,
				fontSize: 14
			),
		),
		HighlightRule(
			tag: "headline4",
			action: null,
			regex: RegExp(r'^#### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w300,
				fontSize: 16
			),
		),
		HighlightRule(
			tag: "headline3",
			action: null,
			regex: RegExp(r'^### [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w400,
				fontSize: 20
			),
		),
		HighlightRule(
			tag: "headline2",
			action: null,
			regex: RegExp(r'^## [\s\S]*?$'),
			style: TextStyle(
				color: Theme.of(context).colorScheme.inverseSurface,
				fontWeight: FontWeight.w500,
				fontSize: 24
			),
		),
		HighlightRule(
			tag: "headline1",
			action: null,
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

		// Italic & Bold
		HighlightRule(
			tag: "italic_bold",
			action: (_) => const SizedBox(),
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
			action: (_) => const SizedBox(),
			regex: RegExp(r'\*\*(.*?)\*\*'),
			style: const TextStyle(
				fontSize: 16,
				fontWeight: FontWeight.bold
			)
		),

		// Italic
		HighlightRule(
			tag: "italic",
			action: (_) => const SizedBox(),
			regex: RegExp(r'\*(.*?)\*'),
			style: const TextStyle(
				fontSize: 16,
				fontStyle: FontStyle.italic
			)
		),

		// Sublist - Item
		HighlightRule(
			tag: "item",
			action: (txt) => Row(
				children: [
					const Icon(Icons.circle, size: 10),
					const SizedBox(width: 12),
					Expanded(
						child: Text.rich(
							TextSpan(
								text: txt.trim().substring(1),
								// text: "\n" + txt.substring(1),
								// text: txt.trim().replaceRange(0, 1, "•").trim(),
								style: defaultStyle
							)
						)
					)
				],
			),
			regex: RegExp(r'^-\s.+$'),
			style: const TextStyle()
		),


	];
}

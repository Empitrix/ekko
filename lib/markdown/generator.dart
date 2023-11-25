import 'package:ekko/backend/launcher.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart' as htmlWidget;

class MDGenerator extends StatelessWidget {
	final String content;
	final double textHeight;
	const MDGenerator({
		super.key,
		required this.content,
		this.textHeight = 0.0
	});

	@override
	Widget build(BuildContext context) {
		/* All the regex rules */
		
		
		TextStyle defaultStyle = TextStyle(
			fontSize: 16,
			fontWeight: FontWeight.w500,
			height: textHeight
		);
		
		
		List<HighlightRule> rules = [
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
			HighlightRule(
				tag: "divider",
				action: (_) => const Divider(height: 1),
				regex: RegExp(r'^\s*---\s*$'),
				style: const TextStyle()
			),
			HighlightRule(
				tag: "italic_bold",
				action: (_) => const SizedBox(),
				regex: RegExp(r'\*\*\*(.*?)\*\*\*'),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold,
					fontStyle: FontStyle.italic
				)),
			HighlightRule(
				tag: "boldness",
				action: (_) => const SizedBox(),
				regex: RegExp(r'\*\*(.*?)\*\*'),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold
				)
			),
			HighlightRule(
				tag: "italic",
				action: (_) => const SizedBox(),
				regex: RegExp(r'\*(.*?)\*'),
				style: const TextStyle(
					fontSize: 16,
					fontStyle: FontStyle.italic
				)
			),
			HighlightRule(
				tag: "item",
				action: (txt) => Row(
					children: [
						const Icon(Icons.circle, size: 10),
						const SizedBox(width: 12),
						Expanded(
							child: Text.rich(
								TextSpan(
									text: txt.trim().substring(1).trim(),
									// text: txt.trim().replaceRange(0, 1, "•").trim(),
									style: defaultStyle
								)
							)
						)
					],
				),
				regex: RegExp(r'^-\s.+$'),
				// regex: RegExp(r'\s^-\s.+$\s'),
				style: const TextStyle()
			),
		];

		
		List<Widget> widgetTree = [];
		List<TextSpan> spans = [];
		
		bool inOrderColumn = false;
		
		
		void updateSpans(){
			if(spans.isNotEmpty){
				widgetTree.add(Text.rich(TextSpan(children: spans)));
				spans = [];
			}
		}


		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
			onMatch: (match) {
				String matchedText = match.group(0)!;
				HighlightRule matchingRule = rules.firstWhere((rule) => rule.regex.hasMatch(matchedText));
				inOrderColumn = false;
				switch (matchingRule.tag) {
					case 'markdown': {
						updateSpans();
						widgetTree.add(matchingRule.action!(matchedText));
						break;
					}
					case 'url': {
						spans.add(
							TextSpan(
								text: matchedText,
								style: matchingRule.style.merge(defaultStyle),
								recognizer: TapGestureRecognizer()..onTap = () async {
									await launchThis(
										context: context, url: matchedText);
									debugPrint(matchedText); 
								},
							)
						);
						break;
					}
					case 'headline1': {
						inOrderColumn = true;
						spans.add(
							TextSpan(
								text: matchedText.substring(2),
								style: matchingRule.style));
						break;
					}
					case 'headline2': {
						spans.add(
							TextSpan(
								text: matchedText.substring(3),
								style: matchingRule.style));
						break;
					}
					case 'headline3': {
						spans.add(
							TextSpan(
								text: matchedText.substring(4),
								style: matchingRule.style));
						break;
					}
					case 'headline4': {
						spans.add(
							TextSpan(
								text: matchedText.substring(5),
								style: matchingRule.style));
						break;
					}
					case 'headline5': {
						spans.add(
							TextSpan(
								text: matchedText.substring(6),
								style: matchingRule.style));
						break;
					}
					case 'headline6': {
						spans.add(
							TextSpan(
								text: matchedText.substring(7),
								style: matchingRule.style));
						break;
					}
					case 'divider': {
						updateSpans();
						widgetTree.add(matchingRule.action!(""));
						break;
					}
					case 'boldness': {
						spans.add(
							TextSpan(
								text: matchedText.substring(2, matchedText.length - 2),
								style: matchingRule.style
							)
						);
						break;
					} 
					case 'italic_bold': {
						spans.add(
							TextSpan(
								text: matchedText.substring(3, matchedText.length - 3),
								style: matchingRule.style
							)
						);
						break;
					}
					case 'italic': {
						spans.add(
							TextSpan(
								text: matchedText.substring(1, matchedText.length - 1),
								style: matchingRule.style
							)
						);
						break;
					}

					case 'item': {
						updateSpans();
						inOrderColumn = true;
						widgetTree.add(matchingRule.action!(matchedText));
						break;
					}


				}  // Switch
				
				// updateColumnTree();
				
				return matchedText;
			},
			onNonMatch: (nonMatchedText) {
				// columnSplinter = false;
				if(nonMatchedText == "\n" && inOrderColumn) return "";
				inOrderColumn = false;
				spans.add(TextSpan(text: nonMatchedText, style: defaultStyle));
				return nonMatchedText;
			},
		);

		// Remaining Spans
		if(spans.isNotEmpty){
			updateSpans();}

		return Container(
			margin: const EdgeInsets.all(0),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: widgetTree,
			),
		);
	}
}

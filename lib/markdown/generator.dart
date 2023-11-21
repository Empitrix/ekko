import 'package:ekko/backend/launcher.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
				regex: RegExp(r'(###### \w+)(..)'),
				style: TextStyle(
					color: Theme.of(context).colorScheme.inverseSurface,
					fontWeight: FontWeight.w100,
					fontSize: 13.6
				),
			),
			HighlightRule(
				tag: "headline5",
				action: null,
				regex: RegExp(r'(##### \w+)(..)'),
				style: TextStyle(
					color: Theme.of(context).colorScheme.inverseSurface,
					fontWeight: FontWeight.w200,
					fontSize: 14
				),
			),
			HighlightRule(
				tag: "headline4",
				action: null,
				regex: RegExp(r'(#### \w+)(..)'),
				style: TextStyle(
					color: Theme.of(context).colorScheme.inverseSurface,
					fontWeight: FontWeight.w300,
					fontSize: 16
				),
			),
			HighlightRule(
				tag: "headline3",
				action: null,
				regex: RegExp(r'(### \w+)(..)'),
				style: TextStyle(
					color: Theme.of(context).colorScheme.inverseSurface,
					fontWeight: FontWeight.w400,
					fontSize: 20
				),
			),
			HighlightRule(
				tag: "headline2",
				action: null,
				regex: RegExp(r'(## \w+)(..)'),
				style: TextStyle(
					color: Theme.of(context).colorScheme.inverseSurface,
					fontWeight: FontWeight.w500,
					fontSize: 24
				),
			),
			HighlightRule(
				tag: "headline1",
				action: null,
				regex: RegExp(r'(# \w+)(..)'),
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
		];

		List<Widget> widgetTree = [];
		List<TextSpan> spans = [];

		void updateSpans(){
			widgetTree.add(Text.rich(TextSpan(children: spans)));
			spans = [];
		}

		TextStyle defaultStyle = TextStyle(
			fontSize: 16,
			fontWeight: FontWeight.w500,
			height: textHeight
		);

		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
			onMatch: (match) {
				String matchedText = match.group(0)!;
				HighlightRule matchingRule = rules.firstWhere((rule) => rule.regex.hasMatch(matchedText));

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
				}  // Switch

				return matchedText;
			},
			onNonMatch: (nonMatchedText) {
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

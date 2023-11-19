import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';

class MDGenerator extends StatelessWidget {
	final String content;
	const MDGenerator({
		super.key,
		required this.content
	});

	@override
	Widget build(BuildContext context) {
		/* All the regex rules */
		List<HighlightRule> rules = [
			HighlightRule(
				tag: "markdown",
				// action: (_){return Container();},
				action: (String text){
					// return Container(
					// 	width: double.infinity,
					// 	decoration: BoxDecoration(
					// 		borderRadius: BorderRadius.circular(5),
					// 		color: Colors.purple,
					// 	),
					// 	child: Text.rich(TextSpan(text: text)),
					// );
					// return MarkdownWidget(content: content);
					return MarkdownWidget(content: text);
				},
				regex: RegExp(r'```([^`]+)```'),
				style: const TextStyle(color: Colors.cyan)
			),

		];

		List<Widget> widgetTree = [];
		List<TextSpan> spans = [];

		TextStyle defaultStyle = TextStyle(
			fontSize: Theme.of(context)
				.primaryTextTheme.bodyLarge!.fontSize,
			fontWeight: FontWeight.w500,
			height: 0
		);

		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|')),
			onMatch: (match) {
				String matchedText = match.group(0)!;
				HighlightRule matchingRule = rules.firstWhere((rule) => rule.regex.hasMatch(matchedText));

				switch (matchingRule.tag) {
					case 'markdown': {
						// Add collected spans
						widgetTree.add(Text.rich(TextSpan(children: spans)));
						spans = [];
						// Add current widget
						widgetTree.add(matchingRule.action(matchedText));
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
			widgetTree.add(Text.rich(TextSpan(children: spans)));
			spans = [];
		}

		return Container(
			margin: const EdgeInsets.all(0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: widgetTree,
			),
		);
	}
}

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
				tag: "",
				action: (_){return Container();},
				regex: RegExp(r'```([^`]+)```'),
				style: const TextStyle()
			),

		];

		List<Widget> widgetTree = [];
		List<TextSpan> spans = [];


		// return Text(
		// 	content,
		// 	style: TextStyle(
		// 		fontSize: Theme.of(context)
		// 			.primaryTextTheme.bodyLarge!.fontSize,
		// 		fontWeight: FontWeight.w500,
		// 		height: 0
		// 	),
		// );

		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|')),
			onMatch: (match) {
				final matchedText = match.group(0)!;
				final matchingRule = rules.firstWhere((rule) => rule.regex.hasMatch(matchedText));

				switch (matchingRule.tag) {
					case 'id1':
						// spans.add(TextSpan(text: matchedText, style: matchingRule.style));
						break;
					case 'id2':
						// spans.add(TextSpan(text: matchedText, style: matchingRule.style));
						break;
				}

				spans.add(TextSpan(text: matchedText, style: matchingRule.style));
				return matchedText;
			},
			onNonMatch: (nonMatchedText) {
				spans.add(TextSpan(text: nonMatchedText, style: const TextStyle()));
				return nonMatchedText;
			},
		);

		return Container(
			margin: const EdgeInsets.all(0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text.rich(TextSpan(children: spans))
				],
			),
		);

	}
}

/*
import 'package:flutter/material.dart';

class HighlightRule {
	final RegExp pattern;
	final TextStyle style;
	final String id;

	HighlightRule({required this.pattern, required this.style, required this.id});
}


TextSpan highlightText(String text) {
	List<HighlightRule> rules = [
		HighlightRule(
			pattern: RegExp(r'\bkeyword\b'),
			style: const TextStyle(color: Colors.blue),
			id: 'keyword',
		),
		HighlightRule(
			pattern: RegExp(r'\B(#[a-zA-Z]+\b)(?!;)'),
			style: const TextStyle(color: Colors.deepPurpleAccent),
			id: 'hashtag',
		),
		HighlightRule(
			pattern: RegExp(r'data'),
			style: const TextStyle(color: Colors.cyan),
			id: 'markdown',
		),
	];
	List<TextSpan> spans = [];

	text.splitMapJoin(
		RegExp(rules.map((rule) => rule.pattern.pattern).join('|')),
		onMatch: (match) {
			final matchedText = match.group(0)!;
			final matchingRule = rules.firstWhere((rule) => rule.pattern.hasMatch(matchedText));

			switch (matchingRule.id) {
				case 'id1':
					// spans.add(TextSpan(text: matchedText, style: matchingRule.style));
					break;
				case 'id2':
					// spans.add(TextSpan(text: matchedText, style: matchingRule.style));
					break;
			}

			spans.add(TextSpan(text: matchedText, style: matchingRule.style));
			return matchedText;
		},
		onNonMatch: (nonMatchedText) {
			spans.add(TextSpan(text: nonMatchedText, style: const TextStyle()));
			return nonMatchedText;
		},
	);

	return TextSpan(children: spans);
}


*/
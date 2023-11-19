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
				regex: RegExp(r'```([^`]+)```'),
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
			)

		];

		List<Widget> widgetTree = [];
		List<TextSpan> spans = [];

		void _updateSpans(){
			widgetTree.add(Text.rich(TextSpan(children: spans)));
			spans = [];
		}

		TextStyle defaultStyle = TextStyle(
			fontSize: Theme.of(context)
				.primaryTextTheme.bodyLarge!.fontSize,
			fontWeight: FontWeight.w500,
			height: textHeight
		);

		content.splitMapJoin(
			RegExp(rules.map((rule) => rule.regex.pattern).join('|')),
			onMatch: (match) {
				String matchedText = match.group(0)!;
				HighlightRule matchingRule = rules.firstWhere((rule) => rule.regex.hasMatch(matchedText));

				switch (matchingRule.tag) {
					case 'markdown': {
						_updateSpans();
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
			_updateSpans();}

		return Container(
			margin: const EdgeInsets.all(0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: widgetTree,
			),
		);
	}
}

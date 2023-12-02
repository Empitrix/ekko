import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


List<TextSpan> formattingTexts({
	required BuildContext context,
	required String content,
	TextStyle? mergeStyle,
	TapGestureRecognizer? recognizer,
	required TextStyle defaultStyle}){

	List<TextSpan> spans = [];

	List<InnerHighlightRule> innerRules = [
		// Italic & Bold
		InnerHighlightRule(
			tag: "italic_bold",
			regex: RegExp(r'\*\*\*(.*?)\*\*\*'),
			innerMethod: InnerMethod.both,
			innerNum: 3,
			style: const TextStyle(
				fontSize: 16,
				fontWeight: FontWeight.bold,
				fontStyle: FontStyle.italic
			).merge(mergeStyle),
		),
	
		// Bold
		InnerHighlightRule(
			tag: "boldness",
			innerMethod: InnerMethod.both,
			innerNum: 2,
			regex: RegExp(r'\*\*(.*?)\*\*'),
			style: const TextStyle(
				fontSize: 16,
				fontWeight: FontWeight.bold
			).merge(mergeStyle),
		),
	
		// Italic
		InnerHighlightRule(
			tag: "italic",
			innerMethod: InnerMethod.both,
			innerNum: 1,
			regex: RegExp(r'\*(.*?)\*'),
			style: const TextStyle(
				fontSize: 16,
				fontStyle: FontStyle.italic
			).merge(mergeStyle),
		),

		InnerHighlightRule(
			tag: "strike",
			innerMethod: InnerMethod.both,
			innerNum: 2,
			regex: RegExp(r'~~.*~~'),
			style: TextStyle(
				fontSize: 16,
				decoration: TextDecoration.lineThrough,
				decorationColor: Theme.of(context).colorScheme.inverseSurface,
			).merge(mergeStyle),
		),
	];

	content.splitMapJoin(
		RegExp(innerRules.map(
			(rule) => rule.regex.pattern).join('|'), multiLine: true),
		onMatch: (match) {
			String mText = match.group(0)!;
			InnerHighlightRule mRule = innerRules
				.firstWhere((rule) => rule.regex.hasMatch(mText));

			// cases
			if(mRule.action == null){
				spans.add(
					TextSpan(
						recognizer: recognizer,
						text: mRule.getContext(mText),
						style: mRule.style
					)
				);
			}

			return mText;
		},
		onNonMatch: (nonMatchedText) {
			spans.add(
				TextSpan(
					text: nonMatchedText,
					recognizer: recognizer,
					style: defaultStyle.merge(mergeStyle))
			);
			return nonMatchedText;
		},
	);

	return spans;
}

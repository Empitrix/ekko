import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';


List<TextSpan> formattingTexts({
	required BuildContext context,
	required String content,
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
			),
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
			)
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
			)
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
					text: nonMatchedText, style: defaultStyle)
			);
			return nonMatchedText;
		},
	);

	return spans;
}

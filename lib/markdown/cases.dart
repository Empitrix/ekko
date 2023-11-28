import 'package:ekko/backend/launcher.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


List<Widget> applyRules({
	required BuildContext context,
	required String content,
	required TextStyle defaultStyle,
	required List<HighlightRule> rules,
	}){
	
	bool inOrderColumn = false;
	List<Widget> widgetTree = [];
	List<TextSpan> spans = [];
	
	// Updates Spans
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
			return matchedText;
		},
		onNonMatch: (nonMatchedText) {
			if(inOrderColumn){
				nonMatchedText = nonMatchedText.replaceFirst("\n", "");
				if(nonMatchedText.isEmpty) return "";
			}
			inOrderColumn = false;
			spans.add(TextSpan(text: nonMatchedText, style: defaultStyle));
			return nonMatchedText;
		},
	);

	// Add remaining spans
	if(spans.isNotEmpty){
		updateSpans();}

	return widgetTree;
}

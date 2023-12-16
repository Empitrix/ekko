import 'package:ekko/backend/launcher.dart';
import 'package:ekko/markdown/formatting.dart';
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

			// Initial for loop
			inOrderColumn = false;
			// inOrderColumnTween = false;

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
								debugPrint("Opening: $matchedText"); 
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
					updateSpans();
					widgetTree.add(const Divider());
					break;
				}
				case 'headline2': {
					inOrderColumn = true;
					spans.add(
						TextSpan(
							text: matchedText.substring(3),
							style: matchingRule.style));
					updateSpans();
					widgetTree.add(const Divider());
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
					inOrderColumn = true;
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

				// Checkbox
				case 'checkbox': {
					updateSpans();
					inOrderColumn = true;
					widgetTree.add(matchingRule.action!(matchedText));
					break;
				}

				case 'links': {
					String name = matchedText.split("](")[0]
						.substring(1).trim();
					String link = matchedText.split("](")[1].trim();
					link = link.substring(0, link.length - 1).trim();
					
					TextStyle linkStyle = const TextStyle(
						fontSize: 16,
						decorationColor: Colors.blue,
						color: Colors.blue,
					);
					TextSpan linkSpan = TextSpan(
						children: formattingTexts(
							context: context,
							content: name,
							recognizer: TapGestureRecognizer()..onTap = () async {
								await launchThis(
									context: context, url: link);
								debugPrint("Opening: $link"); 
							},
							mergeStyle: linkStyle,
							defaultStyle: defaultStyle,
						),
					);
					spans.add(linkSpan);
					// updateSpans();
					// inOrderColumn = true;
					// widgetTree.add(matchingRule.action!(matchedText));
					break;
				}


				case 'backqoute': {
					updateSpans();
					inOrderColumn = true;
					widgetTree.add(matchingRule.action!(matchedText));
					break;
				}

				case 'strike': {
					spans.add(
						TextSpan(
							text: matchedText.substring(2, matchedText.length - 2),
							style: matchingRule.style
						)
					);
					break;
				}

			}  // Switch
			return matchedText;
		},
		onNonMatch: (nonMatchedText) {
			if(inOrderColumn){
				nonMatchedText = nonMatchedText.replaceFirst("\n", "");
				// if(nonMatchedText.isEmpty) return "";
				TextSpan endLine = const TextSpan(text: "\u000A", style:TextStyle(fontSize: 1.44763171673));
				// TextSpan endLine = const TextSpan(text: "\u000A", style:TextStyle(fontSize: 0.44763171673));
				spans.add(endLine);
			}
			spans.add(TextSpan(text: nonMatchedText, style: defaultStyle));
			return nonMatchedText;
		},
	);

	// Add remaining spans
	if(spans.isNotEmpty){
		updateSpans();}

	return widgetTree;
}

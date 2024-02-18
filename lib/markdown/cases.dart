import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/models/note_match.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


TextSpan applyRules({
	required BuildContext context,
	required String content,
	required List<HighlightRule> rules,
	required int id,
	// required Map<String, String> variables,
	// Map<String, String> variables = const {},
	TapGestureRecognizer? recognizer
	}){
	
	List<InlineSpan> spans = [];
	TextSpan nl = const TextSpan(text: "\n");
	//** bool trimNext = false;

	content.splitMapJoin(
		RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
		onMatch: (match) {
			String mText = match.group(0)!;
			HighlightRule mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));
			if(mRule.label == "markdown"){ spans.add(nl); }
			// {@Re-Count}
			if(mRule.label != "item"){
				lastIndent = 0;
				indentStep = 0;}
			// Add Widgets
			spans.add(mRule.action(mText, recognizer, NoteMatch(id: id, match: match)));
			if(mRule.label == "markdown"){ spans.add(nl); }

			return mText;
		},
		onNonMatch: (nonMatchedText) {
			spans.add(
				TextSpan(
					text: nonMatchedText,
					style: Provider.of<ProviderManager>(context).defaultStyle
				)
			);
			return nonMatchedText;
		},
	);

	return TextSpan(children: spans);
}

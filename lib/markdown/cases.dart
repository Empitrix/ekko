import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


TextSpan applyRules({
	required BuildContext context,
	required String content,
	required List<HighlightRule> rules,
	required int id,
	TapGestureRecognizer? recognizer,
	TextStyle? forceStyle
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
			RuleOption opt = RuleOption(
				id: id,
				recognizer: recognizer,
				match: match,
				forceStyle: forceStyle
			);

			spans.add(mRule.action(mText, opt));
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

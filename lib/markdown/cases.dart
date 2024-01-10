import 'package:ekko/config/manager.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


TextSpan applyRules({
	required BuildContext context,
	required String content,
	required List<HighlightRule> rules,
	}){
	
	List<InlineSpan> spans = [];
	TextSpan nl = const TextSpan(text: "\n");
	//** bool trimNext = false;

	content.splitMapJoin(
		RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
		onMatch: (match) {
			String mText = match.group(0)!;
			HighlightRule mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));
			//** trimNext = mRule.trimNext;
			if(mRule.label == "markdown"){ spans.add(nl); }
			spans.add(mRule.action(mText));
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

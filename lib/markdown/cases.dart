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
	//** bool trimNext = false;

	content.splitMapJoin(
		RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
		onMatch: (match) {
			// Capture rules
			String mText = match.group(0)!;
			HighlightRule mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));

			// {@Re-Count for Sub-list}
			if(mRule.label != "item"){ lastIndent = 0; indentStep = 0; }

			// Add Widgets
			RuleOption opt = RuleOption(
				id: id,
				recognizer: recognizer,
				match: match,
				forceStyle: forceStyle
			);


			// content.splitMapJoin(
			// 	RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>', multiLine: true),
			// 	onMatch: (Match m){
			// 		// print(m.group(0)!);
			// 		return "";
			// 	},
			// 	onNonMatch: (n){
			// 		return "";
			// 	}
			// );

			spans.add(mRule.action(mText, opt));  // Add the releated rule

			return "";
		},
		onNonMatch: (n) {
			spans.add(
				TextSpan(
					// text: nonMatchedText,
					// text: n != "\n" ? n.replaceAll(RegExp(r'\n(?!\n)'), "") : n,
					// text: n.replaceAll("\n", "").isNotEmpty ? n.replaceAll(RegExp(r'\n(?!\n)'), "") : n,

					// text: n.replaceAll("\n", "").isNotEmpty ? n.replaceAll(RegExp(r'\n(?!\n)[^$]'), "") : n,
					text: n.replaceAll("\n", "").isNotEmpty ? n.replaceAll(RegExp(r'\n(?!\n)(?!$)'), "") : n,
					style: Provider.of<ProviderManager>(context).defaultStyle
				)
			);
			return "";
		},
	);

	return TextSpan(children: spans);
}

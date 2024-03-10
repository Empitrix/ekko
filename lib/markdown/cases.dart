import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/markdown/tools/key_manager.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


TextSpan applyRules({
	required BuildContext context,
	required String content,
	required GlobalKeyManager keyManager,
	required List<HighlightRule> rules,
	required int id,
	TapGestureRecognizer? recognizer,
	TextStyle? forceStyle
	}){
	
	List<InlineSpan> spans = [];

	content.splitMapJoin(
		RegExp(rules.map((rule) => rule.regex.pattern).join('|'), multiLine: true),
		onMatch: (match) {
			// Capture rules

			String mText = match.group(0)!;


			// if(mText.contains('What is the best prompt')){
			// 	debugPrint("${match.group(0)}\n${'- ' * 20}");
			// }
		

			HighlightRule mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));
			// HighlightRule mRule;
			// try{
			// 	mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));
			// }catch(_){
			// 	mRule = rules.where((e) => e.label == "item").first;
			// 	return "";
			// }


			// HighlightRule? mRule;
			// try{
			// 	mRule = rules.firstWhere((rule) => rule.regex.hasMatch(mText));
			// }catch(_){
			// 	return "";
			// }

			// {@Re-Count for Sub-list}
			if(mRule.label != "item"){ lastIndent = 0; indentStep = 0; }

			// Add Widgets
			RuleOption opt = RuleOption(
				id: id,
				recognizer: recognizer,
				match: match,
				forceStyle: forceStyle
			);

			spans.add(mRule.action(mText, opt));  // Add the releated rule
			return "";
		},
		onNonMatch: (n) {
			spans.add(
				TextSpan(
					text: n,
					style: Provider.of<ProviderManager>(context).defaultStyle
				)
			);
			return "";
		},
	);

	return TextSpan(children: spans);
}


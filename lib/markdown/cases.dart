import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/inline_html/models.dart';
import 'package:ekko/markdown/inline_html/parser.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/markdown/tools/key_manager.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


TextSpan __applyRules({
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




TextSpan applyRules({
	required BuildContext context,
	required String content,
	required GlobalKeyManager keyManager,
	required List<HighlightRule> rules,
	required int id,
	TapGestureRecognizer? recognizer,
	TextStyle? forceStyle
}){

	String textData = "";
	int endIdx = 0;



	/* Remove HTML */
	List<Range> htmlRange = detectRawHtml(content);
	if(htmlRange.isNotEmpty){
		for(Range r in htmlRange){
			debugPrint(r.toString());
			textData += content.substring(endIdx, r.start);
			debugPrint("CUT: [$endIdx, ${r.start}]");
			endIdx = r.end;
		}
	} else {
		textData = content;
	}







	// debugPrint("${'- ' * 20}\n\n\n$textData\n\n\n${'- ' * 20}");


	return __applyRules(
		context: context,
		// content: content,
		content: textData,
		keyManager: keyManager,
		rules: rules,
		id: id,
		recognizer: recognizer,
		forceStyle: forceStyle
	);

}


import 'package:ekko/markdown/html/html_parser.dart';
import 'package:ekko/models/html_rule.dart';
import 'package:flutter/material.dart';



InlineSpan htmlFormatting({
	required BuildContext context,
	required String content,
	required Map variables,
	required int id,
	required Function hotRefresh,
	required HtmlRuleOption option,
}){

	// content = content.trim();

	// debugPrint(content);

	/*
	RegExp htmlR = RegExp(r'<([a-zA-Z]+)(\s+[^>]*)?>([\s\S]*?)<\/\1>|<\/\1>|<(\w+)[^>]*\s*\/?>');
	List<RegExpMatch> matches = RegExp(r'<([a-zA-Z]+)(\s+[^>]*)?>([\s\S]*?)<\/\1>|<\/\1>|<(\w+)[^>]*\s*\/?>').allMatches(content).toList();

	if(matches.length >= 2){
		List<String> extracted = [];
		List<InlineSpan> spoon = [];

		content.splitMapJoin(
			htmlR,
			onMatch: (Match m){
				extracted.add(m.group(0)!);
				return "";
			},
			onNonMatch: (n){
				// extracted.add(n);
				return "";
			}
		);

		for(String i in extracted){
			if(htmlR.hasMatch(i)){
				spoon.add(
				applyHtmlRules(
						context: context,
						txt: i,
						variables: variables,
						noteId: id,
						hotRefresh: hotRefresh,
						forceStyle: option.forceStyle,
						recognizer: option.recognizer
					)
				);
			} else {
				spoon.add(TextSpan(text: i));
			}
		}
		// return TextSpan(children: spoon);
	}
	*/

	// print(option.recognizer);
	// print(content);
	// content = content.trim();

	return applyHtmlRules(
		context: context,
		txt: content,
		variables: variables,
		noteId: id,
		hotRefresh: hotRefresh,
		forceStyle: option.forceStyle,
		recognizer: option.recognizer
	);

}

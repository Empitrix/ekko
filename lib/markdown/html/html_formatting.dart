import 'package:ekko/markdown/html/html_parser.dart';
import 'package:ekko/markdown/html/html_utils.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/models/html_rule.dart';
import 'package:flutter/material.dart';



InlineSpan htmlFormatting({
	required String content,
	required HtmlRuleOption option,
	required GeneralOption gOpt,
}){

	// content = content.trim();

	// debugPrint(content);

	// RegExp htmlR = RegExp(r'<([a-zA-Z0-9]+)(\s+[^>]*?)?>([\s\S]*?)<\/\1>|<(\w+)[^>]*\s*\/?>');
	// RegExp htmlR = RegExp(r'<([a-zA-Z]+)(\s+[^>]*)?>([\s\S]*?)<\/\1>|<\/\1>|<(\w+)[^>]*\s*\/?>');
	RegExp htmlR = RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>');

	List<RegExpMatch> matches = htmlR.allMatches(content).toList();
	// debugPrint("Length: ${matches.length}");
	

	if(matches.length >= 2){
		List<String> extracted = [];
		List<InlineSpan> spoon = [];

		content.splitMapJoin(
			htmlR,
			onMatch: (Match m){
				// print(m.group(0)!);
				extracted.add(m.group(0)!);
				return "";
			},
			onNonMatch: (n){
				// print(">$n<");
				// extracted.add(n);
				return "";
			}
		);

		// print(extracted);

		for(String i in extracted){
			if(htmlR.hasMatch(i)){
				// debugPrint("${'- ' * 20}\n$i\n${'- ' * 20}");
				spoon.add(
				/*
				applyHtmlRules(
					context: context,
					txt: i,
					variables: variables,
					noteId: id,
					hotRefresh: hotRefresh,
					forceStyle: option.forceStyle,
					recognizer: option.recognizer
				)
				*/

					WidgetSpan(
						child: ApplyHtmlAlignment(
							alignment: getHtmlAlignment(
								option.data.attributes['align']!),
							children: [
								Text.rich(htmlFormatting(
									content: i.trim(),  // IDK about triming
									gOpt: gOpt,
									option: option
								))
							],
						)
					)

				);
			} else {
				spoon.add(TextSpan(text: i));
			}
		}
		return TextSpan(children: spoon);
	}

	return applyHtmlRules(
		txt: content,
		gOpt: gOpt,
		forceStyle: option.forceStyle,
		recognizer: option.recognizer,
		option: option
	);

}

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
	// TextStyle? forceStyle,
	// HTMLParser? htmlParser,
	// TapGestureRecognizer? recognizer
}){


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

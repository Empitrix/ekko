import 'package:ekko/markdown/html/html_formatting.dart';
import 'package:ekko/markdown/html/html_parser.dart';
import 'package:ekko/models/html_rule.dart';
import 'package:flutter/material.dart';


List<HtmlHighlightRule> allHtmlRules(BuildContext context, Map variables, int noteId, Function hotRefresh, TextStyle? forceStyle){
	return [

		// {@Headlines}
		HtmlHighlightRule(
			label: "headlines",
			tag: HTMLTag.h1,
			action: (_, opt){
				return htmlFormatting(
					context: context,
					content: _,
					variables: variables,
					id: noteId,
					hotRefresh: hotRefresh,
					option: opt
				);
				// return const TextSpan();
			},
		),
		
		// @{a-TAG}
		HtmlHighlightRule(
			label: "headlines",
			tag: HTMLTag.a,
			action: (_, opt){
				return htmlFormatting(
					context: context,
					content: _,
					variables: variables,
					id: noteId,
					hotRefresh: hotRefresh,
					option: opt
				);
			},
		),
		// etc..


	];
}

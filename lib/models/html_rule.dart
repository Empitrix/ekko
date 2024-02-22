import 'package:ekko/markdown/html/html_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HtmlRuleOption {
	final int id;
	late TextStyle? forceStyle;
	final HTMLParser data;
	late TapGestureRecognizer? recognizer;

	HtmlRuleOption({
		required this.id,
		required this.forceStyle,
		required this.data,
		this.recognizer
	});
}

typedef HTMLRuleWidget = InlineSpan Function(String inner, HtmlRuleOption option);

/* Rules for HTML */
class HtmlHighlightRule {
	final String label;
	final HTMLTag tag;
	final HTMLRuleWidget action;
	// final bool trimNext; 

	HtmlHighlightRule({
		required this.label,
		required this.tag,
		required this.action,
		// this.trimNext = false
	});
}


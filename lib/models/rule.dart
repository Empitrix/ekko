import 'package:flutter/material.dart';
typedef RuleAction = Widget Function(String input);

class HighlightRule {
	final String tag;
	final RuleAction action;
	final RegExp regex;
	final TextStyle style;

	HighlightRule({
		required this.tag,
		required this.action,
		required this.regex,
		required this.style
	});
}

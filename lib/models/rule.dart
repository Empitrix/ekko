import 'package:flutter/material.dart';

typedef RuleAction = Widget Function(String input);

class HighlightRule {
	final String tag;
	final RuleAction action;
	final String regex;

	HighlightRule({
		required this.tag,
		required this.action,
		required this.regex,
	});
}

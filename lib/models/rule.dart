import 'package:flutter/material.dart';

typedef RuleWidget = InlineSpan Function(String input);


class HighlightRule {
	final String label;
	final RegExp regex;
	final RuleWidget action;
	final bool trimNext; 

	HighlightRule({
		required this.label,
		required this.action,
		required this.regex,
		this.trimNext = false
	});
}

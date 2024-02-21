import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class RuleOption {
	final int id;
	final Match match;
	final TextStyle? forceStyle;
	final TapGestureRecognizer? recognizer;

	RuleOption({
		required this.id,
		required this.forceStyle,
		required this.match,
		required this.recognizer
	});
}

 
typedef RuleWidget = InlineSpan Function(String input, RuleOption option);


class HighlightRule {
	final String label;
	final RegExp regex;
	final RuleWidget action;
	final bool trimNext; 

	HighlightRule({
		required this.label,
		required this.regex,
		required this.action,
		this.trimNext = false
	});
}


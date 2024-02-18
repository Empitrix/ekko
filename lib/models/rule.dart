import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// class Recognizer {
// 	final TapGestureRecognizer recognizer;
// 	final TextStyle style;
// 
// 	Recognizer({
// 		required this.recognizer,
// 		required this.style
// 	});
// }

class RuleOption {
	final int id;
	final Match match;
	final TapGestureRecognizer? recognizer;

	RuleOption({
		required this.id,
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
		required this.action,
		required this.regex,
		this.trimNext = false
	});
}


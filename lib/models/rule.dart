import 'package:ekko/models/note_match.dart';
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
 
typedef RuleWidget = InlineSpan Function(
	String input, TapGestureRecognizer? recognizer, NoteMatch noteMatch);
// typedef RuleWidget = InlineSpan Function(String input, Recognizer? recognizer);


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

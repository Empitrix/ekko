import 'package:flutter/material.dart';

// class WidgetBox {
// 	final bool isRenderable;
// 	final Widget? widget;
// 	final TextSpan? span;
// 
// 	WidgetBox({
// 		required this.isRenderable,
// 		this.widget,
// 		this.span
// 	});
// }

// typedef RuleAction = WidgetBox Function(String input);
typedef RuleAction = Widget Function(String input);

class HighlightRule {
	final String tag;
	final RuleAction? action;
	final RegExp regex;
	final TextStyle style;

	HighlightRule({
		required this.tag,
		this.action,
		required this.regex,
		required this.style
	});
}

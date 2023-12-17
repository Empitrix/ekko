import 'package:ekko/components/editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:regex_pattern_text_field/models/regex_pattern_text_style.dart';

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
	
	TextPartStyleDefinition getDefinition(){
		return TextPartStyleDefinition(pattern: regex.pattern, style: style);
	}
	RegexPatternTextStyle getTextStyle(){
		return RegexPatternTextStyle(regexPattern: regex.pattern, textStyle: style);
	}
}

enum InnerMethod {
	both,
	right,
	left,
	custom
}

typedef InnerAction = String Function(String input, int n);

typedef InnerSpan = TextSpan Function(String input);

class InnerHighlightRule extends HighlightRule {
	// final InnerAction innerAction;
	final int innerNum;
	final InnerMethod innerMethod;
	final InnerSpan? innerSpan;

	InnerHighlightRule({
		// required String tag,
		// required String tag,
		required super.tag,
		required super.regex,
		required super.style,
		// required TextStyle style,
		// required RegExp regex,
		RuleAction? acton,
		// required this.innerAction,
		required this.innerNum,
		required this.innerMethod,
		this.innerSpan
	}): super(
		// style: style,
		// regex: regex,
		// tag: tag
	);
	
	// String getMiddle(String txt, int n){
	String getContext(String txt){
		if(innerMethod == InnerMethod.custom){ return ""; }

		if(innerMethod == InnerMethod.right){
			return txt.substring(innerNum, txt.length);
		} else if(innerMethod == InnerMethod.left){
			return txt.substring(0, txt.length - innerNum);
		} else {
			return txt.substring(innerNum, txt.length - innerNum);
		}
	}


	TextSpan getSpan(String txt){
		if(innerMethod == InnerMethod.custom){
			return innerSpan!(txt);
		}
		return const TextSpan();
	}
}


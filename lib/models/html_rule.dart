import 'package:ekko/markdown/html/html_parser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum HtmlAlignment{
	left, right, center, justify
}

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

	HtmlRuleOption merge(HtmlRuleOption? mergeOpt){
		/* Merge the given option with the corrent one */
		if(mergeOpt == null){ return this; }
		// **Merge only if the value is null
		Map<String, String> atrr = {};
		atrr.addAll(data.attributes);
		/* FORCE: atrr.addAll(mergeOpt.data.attributes); */
		for(String key in mergeOpt.data.attributes.keys.toList()){
			if(!atrr.containsKey(key)){
				atrr[key] = mergeOpt.data.attributes[key]!;
			}
		}
		data.attributes = atrr;
		return this;
	}
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


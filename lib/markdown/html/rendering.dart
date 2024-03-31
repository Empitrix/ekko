import 'package:ekko/markdown/html/parser.dart';
// import 'package:ekko/markdown/html/tools.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';



InlineSpan renderCurrentTag({
	required Map tag,
	required RuleOption opt,
	required GeneralOption gOpt
}){
	List<InlineSpan> spans = [];

	for(Map child in tag['children']){
		// print(child['text']);
		spans.add(TextSpan(text: child['text']));
	}


	return TextSpan(children: spans);
}




InlineSpan htmlRendering({
	required String content,
	required RuleOption opt,
	required GeneralOption gOpt
}){

	List<InlineSpan> spans = [];
	Map htmlData = htmlToJson(content);

	for(Map raw in htmlData['children']){
		// if(raw['text'] != null){ return TextSpan(text: raw['text']); }
		// if(raw['text'] != null){ spans.add(TextSpan(text: raw['text'])); }

		// if(isTagEmpty(raw)){ continue; }

		switch (raw['tag']) {
			case 'p': {
				spans.add(renderCurrentTag(tag: raw, opt: opt, gOpt: gOpt));
				break;
			}


			default: {
				if(raw['text'] != null){
					spans.add(TextSpan(text: raw['text']));
				}
			}
		} // Switch

	}

	return TextSpan(children: spans);
}


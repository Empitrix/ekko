/*
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/html/html_rules.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/models/html_rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/*
a -> link
p -> Apply ALIGNMENT
center -> ALIGNMENT:CENTER
img -> image
*/


class HTMLParser {
	final HTMLTag tag;
	late Map<String, String> attributes;
	final String innerHTML;

	HTMLParser({
		required this.tag,
		required this.attributes,
		required this.innerHTML
	});
}


enum HTMLTag {
	a,
	p,
	img,
	h1, h2, h3, h4, h5, h6,
	center,
	picture,
	source,
	div,
	u,
}


HTMLTag _getEnumTag(String tName){
	/* Return an enum by given HTML tag */
	tName = tName.trim().toLowerCase();
	HTMLTag tag;
	switch(tName){
		case "a": { tag = HTMLTag.a; }
		case "p": { tag = HTMLTag.p; }
		case "img": { tag = HTMLTag.img; }
		case "center": { tag = HTMLTag.center; }
		case "h1": { tag = HTMLTag.h1; }
		case "h2": { tag = HTMLTag.h2; }
		case "h3": { tag = HTMLTag.h3; }
		case "h4": { tag = HTMLTag.h4; }
		case "h5": { tag = HTMLTag.h5; }
		case "h6": { tag = HTMLTag.h6; }
		case "picture": { tag = HTMLTag.picture; }
		case "source": { tag = HTMLTag.source; }
		case "div": { tag = HTMLTag.div; }
		case "u": { tag = HTMLTag.u; }
		case _:{ tag = HTMLTag.p; }  // Default
	}
	return tag;
}


HTMLParser? getTagNameProperty(String txt){
	// get the first html tag <\w....>
	RegExpMatch? firstTag = RegExp(r'<\w*\s*(\w+\s*=\s*\".*?\")*\s*\/?\s*>').firstMatch(txt);
	// get tag name h1, p ..
	RegExpMatch? tagName = RegExp(r'<(\w+)(.*)>').firstMatch(txt);
	if(firstTag == null){ return null; }
	// searching for properties of html like href src ect...
	List<RegExpMatch>? rawAttributes = RegExp(r'\w+\s*\=\s*\".*?\"').allMatches(firstTag.group(0)!).toList();
	// Inner HTML
	RegExpMatch? inlineHTML = RegExp(r'(>)([\s\S]*)(<)').firstMatch(txt);

	
	Map<String, String> attributes = {};
	for(RegExpMatch attr in rawAttributes){
		String key = attr.group(0)!.split(RegExp(r'(\"|'r"\').*(\1)")).first.trim();
		key = key.substring(0, key.length - 1);
		String value = attr.group(0)!.split(RegExp(r'^\w+\s*\=\s*')).last.trim();
		value = value.substring(1, value.length - 1);
		// debugPrint("key: $key, value: $value");
		attributes[key] = value;
	}

	return HTMLParser(
		tag: _getEnumTag(tagName!.group(1)!),
		attributes: attributes,
		innerHTML: inlineHTML == null ? "" : inlineHTML.group(2)!
	);
}




InlineSpan applyHtmlRules({
		required String txt,
		required TextStyle? forceStyle,
		required GeneralOption gOpt,
		TapGestureRecognizer? recognizer,
		HtmlRuleOption? option
	}){

	HTMLParser? data = getTagNameProperty(txt);


	// print(txt);
	// print("-------------------------\n\n\n\n\n\n\n\n\n\n\n");
	// print(recognizer);

	// Normal Text (NON-HTML)
	if(data == null){
		
		if(forceStyle != null && forceStyle.compareTo(const TextStyle()) != RenderComparison.identical){
			if(forceStyle.fontSize == null){
				forceStyle = forceStyle
					.copyWith(fontSize: Provider.of<ProviderManager>
					(gOpt.context).defaultStyle.fontSize);
			}
			return TextSpan(
				text: txt,
				style: forceStyle,
				recognizer: recognizer
			);
		}

		return formattingTexts(
			content: txt,
			recognizer: recognizer,
			forceStyle: forceStyle,
			gOpt: gOpt
		);
	}

	List<HtmlHighlightRule> rules = allHtmlRules(gOpt: gOpt, forceStyle: forceStyle);

	HtmlHighlightRule? currentRule;
	try{
	 currentRule = rules.firstWhere((e) => e.tag == data.tag);
	}catch(_){}



	if(currentRule == null){
		return TextSpan(text: data.innerHTML);
	}


	HtmlRuleOption ruleOpt = HtmlRuleOption(id: gOpt.noteId, forceStyle: forceStyle, recognizer: recognizer, data: data);

	// Merge the current one with it's parrents
	if(option != null){ ruleOpt = ruleOpt.merge(option); }
	// print("#/${data.innerHTML}/#");
	return currentRule.action(data.innerHTML, ruleOpt);

}


*/

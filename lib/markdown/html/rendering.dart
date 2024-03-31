import 'package:ekko/markdown/html/parser.dart';
import 'package:ekko/markdown/html/tools.dart';
import 'package:ekko/markdown/html/widgets/html_block.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*


InlineSpan renderCurrentTag({
	required Map tag,
	required RuleOption opt,
	required GeneralOption gOpt,
	required TextStyle fs
}){
	List<InlineSpan> spans = [];

	for(Map child in tag['children']){
		if(child['text'] != null){
			spans.add(TextSpan(text: child['text']));
			break;
		}

		if(child['tag'] != null){

		}

	
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
	TextStyle fs = const TextStyle();  // Force Style

	for(Map raw in htmlData['children']){

		switch (raw['tag']) {
			case 'p': {
				spans.add(
					WidgetSpan(child: HtmlBlock(
						attr: raw['attributes'],
						child: renderCurrentTag(tag: raw, opt: opt, gOpt: gOpt, fs: fs)
					))
				);
				break;
			}
			case 'div': {
				spans.add(
					WidgetSpan(child: HtmlBlock(
						attr: raw['attributes'],
						child: renderCurrentTag(tag: raw, opt: opt, gOpt: gOpt, fs: fs)
					))
				);
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
*/



/*
class HtmlRenderingParams{
	final RuleOption opt;
	final GeneralOption gOpt;
	final TextStyle style;

	HtmlRenderingParams({
		required this.opt,
		required this.gOpt,
		required this.style,
	});
}
*/




InlineSpan htmlRendering({
	required String content,
	required RuleOption opt,
	required GeneralOption gOpt,
	required TextStyle style,
	Map? rawInput,
	GestureRecognizer? recognizer,
}){

	List<InlineSpan> spans = [];
	Map raw = rawInput ?? htmlToJson(content);

	// debugPrint("${'-' * 10}Raw${'-' * 10}\n\n$raw\n\n${'-' * 10}END${'-' * 10}");
	// try{ print(raw['tag']); }catch(_){}


	if(raw['children'] == null){
		if(raw['text'] != null){
			spans.add(TextSpan(
				text: textTrimLeft(raw['text'].toString()),
				style: style,
				recognizer: recognizer
			));
		}
	} else {
		switch(raw['tag']){
			case 'p': {
				for(Map itm in raw['children']){
					spans.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						style: style,
						rawInput: itm,
						recognizer: recognizer
					));
				}
				break;
			}

			case 'a': {
				style = style.merge(const TextStyle(color: Colors.blue));
				GestureRecognizer rec = useLinkRecognizer(gOpt.context, raw['attributes']['href'] ?? "", gOpt.keyManager);
				for(Map itm in raw['children']){
					spans.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						style: style,
						rawInput: itm,
						recognizer: rec
					));
				}
				break;
			}

			case 'u': {
				style = style.merge(TextStyle(
					decoration: TextDecoration.underline,
					decorationColor: Theme.of(gOpt.context).colorScheme.inverseSurface
				));
				for(Map itm in raw['children']){
					spans.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						style: style,
						rawInput: itm,
						recognizer: recognizer
					));
				}
				break;
			}



			case 'div': {
				List<InlineSpan> children = [];
				if(raw['children'] != null){
					for(Map divChild in raw['children']){
						children.add(htmlRendering(
							content: content,
							opt: opt,
							gOpt: gOpt,
							style: style,
							rawInput: divChild,
						recognizer: recognizer
						));
					}
				}
				spans.add(
					WidgetSpan(child: HtmlBlock(
						attr: raw['attributes'],
						child: TextSpan(children: children)
					))
				);
				break;
			}


			case 'body': {
				List<InlineSpan> children = [];
				if(raw['children'] != null){
					for(Map divChild in raw['children']){
						children.add(htmlRendering(
							content: content,
							opt: opt,
							gOpt: gOpt,
							rawInput: divChild,
							style: style
						));
					}
				}
				spans.add(
					WidgetSpan(child: HtmlBlock(
						attr: raw['attributes'],
						child: TextSpan(children: children)
					))
				);
				break;
			}

			default: {
				if(raw['text'] != null){
					spans.add(TextSpan(text: raw['text']));
				}
				break;
			}
		}


	}
	return TextSpan(children: spans);
}




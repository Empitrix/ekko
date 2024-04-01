import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/html/parser.dart';
import 'package:ekko/markdown/html/tools.dart';
import 'package:ekko/markdown/html/widgets/html_block.dart';
import 'package:ekko/markdown/image.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
				List<InlineSpan> children = [];
				for(Map itm in raw['children']){
					children.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						style: style,
						rawInput: itm,
						recognizer: recognizer
					));
				}
				spans.add(WidgetSpan(
					child: HtmlBlock(
						attr: raw['attributes'],
						child: TextSpan(children: children)
					)
				));
				break;
			}

			case 'a': {
				style = style.merge(const TextStyle(color: Colors.blue));
				GestureRecognizer rec = useLinkRecognizer(
					gOpt.context, raw['attributes']['href'] ?? "",
					gOpt.keyManager);
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
				List<InlineSpan> children = [];
				style = style.merge(TextStyle(
					decoration: TextDecoration.underline,
					decorationColor: Theme.of(gOpt.context).colorScheme.inverseSurface
				));
				for(Map itm in raw['children']){
					children.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						style: style,
						rawInput: itm,
						recognizer: recognizer
					));
				}
				spans.add(TextSpan(children: children));
				break;
			}


			case 'h1' || 'h2': {
				List<InlineSpan> children = [];
				style = style.merge(getHeadlineStyle(
					gOpt.context, raw['tag'] == "h1" ? 1 : 2));
				GlobalKey? headerKey;
				if(raw['attributes']['id'] != null){
					headerKey = gOpt.keyManager.addNewKey(
						raw['attributes']['id'].substring(1));
				}
				for(Map itm in raw['children']){
					children.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						style: style,
						rawInput: itm,
						recognizer: recognizer
					));
				}
				spans.add(WidgetSpan(child: Column(
					key: headerKey,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						HtmlBlock(
							attr: raw['attributes'],
							child: TextSpan(children: children)
						),
						const Divider()
					],
				)));
				break;
			}

			case 'h3' || 'h4' || 'h5' || 'h6': {
				List<InlineSpan> children = [];
				style = style.merge(getHeadlineStyle(
					gOpt.context, int.parse(raw['tag'].replaceAll("h", ""))));
				GlobalKey? headerKey;
				if(raw['attributes']['id'] != null){
					headerKey = gOpt.keyManager.addNewKey(
						raw['attributes']['id'].substring(1));
				}
				for(Map itm in raw['children']){
					children.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						style: style,
						rawInput: itm,
						recognizer: recognizer
					));
				}
				// spans.add(WidgetSpan(
				// 	style: const TextStyle(color: Colors.red),
				// 	child: Text.rich(
				// 		key: headerKey,
				// 		TextSpan(children: children),
				// 	)
				// ));
				spans.add(WidgetSpan(child: HtmlBlock(
					attr: raw['attributes'],
					child: WidgetSpan(
						style: const TextStyle(color: Colors.red),
						child: Text.rich(
							key: headerKey,
							TextSpan(children: children),
						)
					)
				)));
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
				spans.add(WidgetSpan(child: HtmlBlock(
					attr: raw['attributes'],
					child: TextSpan(children: children)
				)));
				break;
			}



			// {@img}
			case 'img': {
				if(raw['attributes']["src"] == null){ break; }
				String link = raw['attributes']["src"]!.trim();
				String format = link.substring(link.lastIndexOf(".") + 1);
				format = format.split("?")[0];
				format = vStr(format);

				// get image parser
				Map<String, dynamic> imgData = {
					"name": raw['attributes']["alt"] ?? "",
					"url": raw['attributes']["src"],
					"format": format == "svg" ? ImageType.svg : ImageType.picture
				};

				double? w = getHtmlSize(gOpt.context, raw['attributes']["width"], "w");
				double? h = getHtmlSize(gOpt.context, raw['attributes']["height"], "h");

				spans.add(WidgetSpan(child: SizedBox(
					width: w,
					height: h,
					child: FittedBox(
						child: Text.rich(showImageFrame("", opt.recognizer, gOpt.variables, imgData)),
					),
				)));
				break;
			}


			/*
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
			*/

			case 'body': {
				List<InlineSpan> children = [];
				if(raw['children'] != null){
					for(Map itm in raw['children']){
						children.add(htmlRendering(
							content: content,
							opt: opt,
							gOpt: gOpt,
							rawInput: itm,
							style: style
						));
					}
				}
				// spans.add(
				// 	WidgetSpan(child: HtmlBlock(
				// 		attr: raw['attributes'],
				// 		child: TextSpan(children: children)
				// 	))
				// );
				spans.add(TextSpan(children: children));
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
	// return TextSpan(children: spans);
	// return WidgetSpan(child: Text.rich(TextSpan(children: spans)));
	return TextSpan(children: spans);
	// return TextSpan(text: "AWESOME", style: Provider.of<ProviderManager>(gOpt.context).defaultStyle);
	// return WidgetSpan(baseline: TextBaseline.alphabetic, child: Column(
	// 	children: [
	// 		const SizedBox(height: 20),
	// 		Text.rich(TextSpan(children: spans)),
	// 	],
	// ));
	// return WidgetSpan(
	// 	// child: TextSpan(children: spans)
	// );
}




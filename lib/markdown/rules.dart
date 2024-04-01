import 'package:ekko/components/divider.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/cases.dart';
// import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/html/parser.dart';
// import 'package:ekko/markdown/html/parser.dart';
import 'package:ekko/markdown/html/rendering.dart';
// import 'package:ekko/markdown/html/html_parser.dart';
import 'package:ekko/markdown/image.dart';
import 'package:ekko/markdown/inline/backqoute.dart';
import 'package:ekko/markdown/inline/checkbox.dart';
import 'package:ekko/markdown/inline/emoji.dart';
import 'package:ekko/markdown/inline/headlines.dart';
import 'package:ekko/markdown/inline/isbb.dart';
import 'package:ekko/markdown/inline/monospace.dart';
import 'package:ekko/markdown/inline/url.dart';
// import 'package:ekko/markdown/inline_html/parser.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:ekko/markdown/table.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'dart:convert';
import 'dart:async';


int lastIndent = 0;
int indentStep = 0;


List<HighlightRule> allSyntaxRules({required GeneralOption gOpt}){

	List<HighlightRule> rules = [
		/*
		// {@HTMl}
		HighlightRule(
			label: "html",
			regex: RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>'),
			action: (txt, opt){
				bool toContinue = true;
				List<HighlightRule> rls = allSyntaxRules(gOpt: gOpt).sublist(1);
				for(HighlightRule r in rls){
					Match? m = r.regex.firstMatch(txt);
					if(m != null){
						if(m.group(0)!.length == txt.length){
							toContinue = false;
						}
					}
				}
				if(!toContinue){
					return applyRules(
						context: gOpt.context,
						content: txt,
						keyManager: gOpt.keyManager,
						rules: allSyntaxRules(gOpt: gOpt).sublist(1),
						id: gOpt.noteId
					);
				}
				try{
					return applyHtmlRules(
						txt: txt,
						recognizer: opt.recognizer,
						gOpt: gOpt,
						forceStyle: const TextStyle()
					);
				} catch(_){
					debugPrint("ERR: $_"); // Possibly Stack-Overflow Err
					return const TextSpan();
				}
			},
		),
		*/

		// {@HTML}
		HighlightRule(
			label: "html",
			regex: RegExp(r'( )*(<.*>\s*)+?(?=\s$|$)|<.*>.*?<\/\w+>', multiLine: true),
			action: (txt, opt){
				bool toContinue = true;
				List<HighlightRule> rls = allSyntaxRules(gOpt: gOpt).sublist(1);
				for(HighlightRule r in rls){
					Match? m = r.regex.firstMatch(txt);
					if(m != null){
						if(m.group(0)!.length == txt.length){
							toContinue = false;
						}
					}
				}

				if(!toContinue){
					return applyRules(
						context: gOpt.context,
						content: txt,
						keyManager: gOpt.keyManager,
						rules: allSyntaxRules(gOpt: gOpt).sublist(1),
						id: gOpt.noteId
					);
				}

				String formatted = txt;
				formatted = formatted.replaceAll(RegExp(r'^ +', multiLine: true), "");
				formatted = formatted.replaceAll(RegExp(r'(?<!\w>)(?<!\n)\n(?!\n)'), " ");
				formatted = formatted.replaceAll(RegExp(r'< *br *(\/)?>'), "\n");
				return htmlRendering(
					content: "",
					rawInput: htmlToJson(formatted),
					style: Provider.of<ProviderManager>(gOpt.context).defaultStyle,
					opt: opt,
					gOpt: gOpt
				);
			}
		),


		// {@Syntax-Hihglighting}
		HighlightRule(
			label: "markdown",
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
			action: (txt, _){
				return TextSpan(
					children: [
						const TextSpan(text: "\n"),
						WidgetSpan(
							child: MarkdownWidget(
								content: txt,
								height: Provider.of<ProviderManager>(gOpt.context).defaultStyle.height!,
							)
						),
						const TextSpan(text: "\n")
					]
				);
			},
		),

		// {@Headlines}
		HighlightRule(
			label: "headline",
			regex: RegExp(r"^#{1,6} [\s\S]*?$\s*"),
			action: (txt, opt){
				return InlineHeadline(opt, gOpt).span(txt);
			},
		),

		// {@Divider}
		HighlightRule(
			label: "divider",
			regex: RegExp(r'^(\-\-\-|\+\+\+|\*\*\*)$'),
			trimNext: true,
			action: (_, __) => const WidgetSpan(
				child: DividerLine(height: 3, lineSide: LineSide.none)
			),
		),

		// {@Checkbox}
		HighlightRule(
			label: "checkbox",
			regex: RegExp(r'^(-|\+|\*)\s{1}(\[ \]|\[x\])\s+(.*)$', multiLine: true),
			action: (txt, opt){
				return InlineCheckbox(opt, gOpt).span(txt);
			},
		),


		// {@Item}
		HighlightRule(
			label: "item",
			regex: RegExp(r'^\s*(-|\+|\*)\s+.+$'),
			action: (txt, _){
				txt = txt.replaceAll(RegExp(r'\n( )*', multiLine: true), "");
				int iLvl = getIndentationLevel(txt);
				int step = iLvl - lastIndent;
				if(step != 0){
					if(step < 0 && step != -1){
						step ++;
					}
					if(step > 0 && step != 1){
						step --;
					}
				}
				indentStep += step;

				if(iLvl != lastIndent){ lastIndent = iLvl; }

				return WidgetSpan(
					child: SublistWidget(
						leading: Icon(
							indentStep == 0 ? Icons.circle:
							indentStep == 1 ? Icons.circle_outlined:
							Icons.square,
							size: 8,
						),
						indentation: indentStep * 20,
						data: TextSpan(
							children: [formattingTexts(
								gOpt: gOpt,
								content: txt.trim().substring(1).trim(),
							)]
						) 
					)
				);
			},
		),



		// {@Table}
		HighlightRule(
			label: "table",
			regex: RegExp(r'^( *?(?!semi)\|.*\|\s?)+'),
			action: (txt, _){
				InlineSpan? outTable = runZoned((){
					return getTableSpan(txt: txt, gOpt: gOpt);
				// ignore: deprecated_member_use
				}, onError: (e, s){
					debugPrint("Index ERR on Loading: $e");
				});
				if(outTable != null){
					return outTable;
				}
				return TextSpan(text: txt);
			},
		),

		// {@Hyper-Link}
		HighlightRule(
			label: "links",
			regex: RegExp(r'(?<!\!)\[((?:\[[^\]]*\]|[^\[\]])*)\]\(([\s\S]*?)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			action: (txt, _){
				Match lastWhere = RegExp(r'(\)|\])(\(|\[)').allMatches(txt).last;
				String name = txt.substring(1, lastWhere.start);
				String link = txt.substring(lastWhere.end - 1);
				link = link.substring(1, link.length - 1);
				TextStyle linkStyle = const TextStyle(
					fontSize: 16,
					decorationColor: Colors.blue,
					color: Colors.blue);

				List<InlineSpan> spoon = [];
				TapGestureRecognizer rec = useLinkRecognizer(gOpt.context, link, gOpt.keyManager);

				List<InlineSpan> appliedRules = formattingTexts(
					content: name,
					gOpt: gOpt,
					recognizer: rec,
				).children!;

				for(InlineSpan span in appliedRules){
					if(span is TextSpan){
						if(span.children == null){
							// print(span.text);
							TextSpan collected = TextSpan(
								text: span.text,
								style: span.style,
								recognizer: rec 
							);
							spoon.add(collected);
							continue;
						}
					}
					spoon.add(span);
				}
				
				return TextSpan(
					children: spoon,
					recognizer: useLinkRecognizer(gOpt.context, link, gOpt.keyManager),
					style: linkStyle
				);
			}
		),

		// {@Image-Link}
		HighlightRule(
			label: "link_image",
			regex: RegExp(r'\!\[([\s\S]*?)\](\(|\[)([\s\S]*?)(\)|\])'),
			action: (String txt, opt){
				InlineSpan? outImg = runZoned((){
					return showImageFrame(txt, opt.recognizer, gOpt.variables);
				// ignore: deprecated_member_use
				}, onError: (e, s){
					debugPrint("ERROR on Loading: $e");
				});
				if(outImg != null){
					return outImg;
				}

				return TextSpan(text: txt);
			},
		),

		// {@Monospace}
		HighlightRule(
			label: "monospace",
			regex: RegExp(r'\`(.|\n)*?\`', multiLine: false),
			action: (txt, opt) => InlineMonospace(opt, gOpt).span(txt),
		),

		// {@URL}
		HighlightRule(
			label: "url",
			regex: RegExp(r'(https\:|http\:|www)(\/\/|\.)([A-Za-z0-9@:%\.\_\+\~\#\=\/\?\-\&]*)'),
			action: (txt, opt) => InlineURL(opt, gOpt).span(txt)
		),

		// {@Italic-Bold, Bold, Italic}
		HighlightRule(
			label: "italic&bold_bold_italic",
			regex: RegExp(r'(\*\*\*|\_\_\_).*?(\*\*\*|\_\_\_)|(\*\*|\_\_).*?(\*\*|\_\_)|(\*|\_).*?(\*|\_)'),
			action: (txt, opt) => InlineIBB(opt, gOpt).span(txt),
		),
		
		// {@Straight}
		HighlightRule(
			label: "strike",
			regex: RegExp(r'~~.*~~'),
			action: (txt, opt) => InlineStrike(opt, gOpt).span(txt),
		),

		// {@Backqoute}
		HighlightRule(
			label: "backqoute",
			regex: RegExp(r'^>\s+.*(?:\n>\s+.*)*'),
			action: (txt, opt) => InlineBackqoute(opt, gOpt).span(txt)
		),

		// {@Emojies}
		HighlightRule(
			label: "emojies",
			regex: RegExp(r'\:\w+\:'),
			action: (txt, opt) => InlineEmoji(opt, gOpt).span(txt)
		),

		// etc..

	];

	return rules;
}


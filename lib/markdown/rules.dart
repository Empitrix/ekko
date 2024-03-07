import 'package:ekko/components/divider.dart';
import 'package:ekko/markdown/backqoute_element.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/check_box.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/html/html_parser.dart';
import 'package:ekko/markdown/image.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/monospace.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:ekko/markdown/table.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';

int lastIndent = 0;
int indentStep = 0;


List<HighlightRule> allSyntaxRules(BuildContext context, Map variables, int noteId, Function hotRefresh){
	List<HighlightRule> rules = [


		// {@HTMl}
		HighlightRule(
			label: "html",
			regex: RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>'),
			// regex: RegExp(r'<(?<tag>\w+)(.*?)>([^<]+(?:<(?!\/\k<tag>\s*>)[\s\S]*?)?)?<\/\k<tag>\s*>|<?<tag>\w+[^>]*\s*\/?>|<(\w+)[^>]*\s*\/?>'),
			action: (txt, opt){

				bool toContinue = true;

				List<HighlightRule> rls = allSyntaxRules(context, variables, noteId, hotRefresh).sublist(1);
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
						context: context,
						content: txt,
						rules: allSyntaxRules(context, variables, noteId, hotRefresh).sublist(1),
						id: noteId
					);
				}

				// print(RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>').hasMatch(txt));
				// Detected as Syntax-Hihglighting
				// For some languages like rust the tag detection is issue, to fix:

				// if(txt.contains("```")){
				// 	return TextSpan(
				// 		children: [
				// 			const TextSpan(text: "\n"),
				// 			WidgetSpan(
				// 				child: MarkdownWidget(
				// 					content: txt,
				// 					height: Provider.of<ProviderManager>(context).defaultStyle.height!,
				// 				)
				// 			),
				// 			const TextSpan(text: "\n")
				// 		]
				// 	);
				// }

				// print(opt.recognizer);
				// debugPrint("${'\n ' * 12}$txt");

				// Detected as HTML
				// return TextSpan();
				try{
					return applyHtmlRules(
						context: context,
						txt: txt,
						variables: variables,
						recognizer: opt.recognizer,
						noteId: noteId,
						hotRefresh: hotRefresh,
						forceStyle: const TextStyle()
					);
				} catch(_){
					// TODO: STACK-OVERFLOW ERR
					debugPrint("ERR: $_");
					return const TextSpan();
				}
				/*
				return applyHtmlRules(
					context: context,
					txt: txt,
					variables: variables,
					recognizer: opt.recognizer,
					noteId: noteId,
					hotRefresh: hotRefresh,
					forceStyle: const TextStyle()
				);
				*/
			},
		),


		// {@Syntax-Hihglighting}
		HighlightRule(
			label: "markdown",
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
			// regex: RegExp(r'``` *(\w+)\n([\s\S]+?)\n```', multiLine: true),
			action: (txt, _){
				return TextSpan(
					children: [
						const TextSpan(text: "\n"),
						WidgetSpan(
							child: MarkdownWidget(
								content: txt,
								height: Provider.of<ProviderManager>(context).defaultStyle.height!,
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
			regex: RegExp(r"^#{1,6} [\s\S]*?$"),
			action: (txt, _){
				int sharpLength = RegExp(r'^\#{1,6}\s?').firstMatch(txt)!.group(0)!.trim().length;
				TextSpan span = TextSpan(
					text: txt.substring(sharpLength + 1),
					// style: getHeadlineStyle(context, sharpLength).merge(_.forceStyle)
					style: getHeadlineStyle(context, sharpLength)
				);
				if(sharpLength == 1 || sharpLength == 2){
					return WidgetSpan(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text.rich(TextSpan(children: [
									endLineChar(),
									span
								])),
								const Divider()
							],
						)
					);
				}
				return span;
			},
		),

		// {@Divider}
		HighlightRule(
			label: "divider",
			regex: RegExp(r'^(\-\-\-|\+\+\+|\*\*\*)$'),
			trimNext: true,
			action: (_, __) => const WidgetSpan(
				child: DividerLine(height: 3, lineSide: LineSide.none)
				// child: Divider(height: 1)
			),
		),

		// {@Checkbox}
		HighlightRule(
			label: "checkbox",
			regex: RegExp(r'^(-|\+|\*)\s{1}(\[ \]|\[x\])\s+(.*)$', multiLine: true),
			action: (txt, opt){
				return WidgetSpan(
					child: CheckBoxSubList(
						txt: txt,
						hotRefresh: hotRefresh,
						noteId: noteId,
						variables: variables,
						nm: opt
					)
				); 
			},
		),

		// {@Item}
		HighlightRule(
			label: "item",
			// regex: RegExp(r'^\s*(-|\+|\*)\s+.+$'),
			// regex: RegExp(r'((^\s*(-|\+|\*)\s+).*(?:\n^\h+.*)*)'),
			// regex: RegExp(r'((^(-|\+|\*)\s+).*(?:\n^\h+.*$)*)', multiLine: true),
			// regex: RegExp(r'((^(-|\+|\*)\s+).*(?:\n^\h+.*?$)*)'),
			// regex: RegExp(r'(^(-|\+|\*)\s+).*(?:\n^\h+.*?$)*', multiLine: true),



			// regex: RegExp(r'^(\s*(-|\+|\*)\s+.*(?:\n\s+.*?)?(.*)$)', multiLine: true),



			// regex: RegExp(r'^((-|\+|\*)\s+.*?(?:\n\s?).*)', multiLine: true),
			// regex: RegExp(r'^(-|\+|\*)\h+.*(?:\n\h+.*)*', multiLine: true),



			// regex: RegExp(r'^(-|\+|\*)\s+.*(?:\n\s+.*)?', multiLine: true),


			// // Working (Maximum amount of whitespace)
			// regex: RegExp(r'^(\s*)(-|\+|\*)\s+(.*(?:\n(?!\1(-|\+|\*)\s|$).*)*)', multiLine: true),
			// // Working (Minimum amount of whitespace)
			// regex: RegExp(r'^(?!\s*$)(\s*)(-|\+|\*)\s+(.*(?:\n(?!\1(-|\+|\*)\s|$).*)*)', multiLine: true),



			regex: RegExp(r'(^ *?[\+\-\*]\s.*\n(^ (?:(?!\s*[-+*0-9]).*)*$)|^ *?[\+\-\*]\s.*)', multiLine: true),


			// regex: RegExp(r'^ *?[\+\-\*]\s.*(?(?=\b\s+(?![\+\-\*])\b)\n(?: .*\n)|$)'),
			// regex: RegExp(r'(^ *?[\+\-\*]\s.*\n +.*|^ *?[\+\-\*]\s(?![0-9])(?![\-\+\*]).*)'),




			// regex: RegExp(r'^(\s*)(-|\+|\*)\s+.*(?:\n(?!\1(-|\+|\*)\s|$)\s+.*)?', multiLine: true),
			// regex: RegExp(r'^(\s*)(-|\+|\*)\s+.*(?:\n(?!(\s*)(-|\+|\*)\s|\s{0}(-|\+|\*)\s|$)\s+.*)?', multiLine: true),
			

			// regex: RegExp(r'^(\s*)(-|\+|\*)\s+.*(?:\n(?!(\s*)(-|\+|\*)\s|$)\s+.*)?'),
			//regex: RegExp(r'^(\s*)(-|\+|\*)\s+.*(?:\n(?!\s+(-|\+|\*)\s|$)\s+.*)?'),
			// regex: RegExp(r'^(?:\s*[-+*]\s.*(?:\n\s+(?![\s*+-]).*)?)'),

			// ^\s*(-|\+|\*)\s+

			// regex: RegExp(r'^\s*(-|\+|\*)\s+(.*[^\n]\s)*?'),
			// regex: RegExp(r'^\s*(-|\+|\*)\s+((?:.*(?:[^-]|\n)){2})'),
			// regex: RegExp(r'^\s*([-+\*])\s+([\s\S]*?)(?=\n{2})'),
			action: (txt, _){

				// txt = txt.replaceAll("\n", "");
				// print(">" + txt.trim().substring(1).trim() + "<");

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
								context: context,
								variables: variables,
								hotRefresh: hotRefresh,
								id: noteId,
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
			//regex: RegExp(r'(?!smi)(\|[\s\S]*?)\|(?:\n)$'),
			// regex: RegExp(r'(?!smi)(\|[\s\S]*?)+\|$'),
			// regex: RegExp(r'(?!smi)(\|[\s\S]*?)+\|(\n)?$'),
			// regex: RegExp(r'^\|\s+.*(?:\n\|[\s\S]*)*'),
			// regex: RegExp(r'(\s*\|[\s\S]*?\|\s?$)+'),

			//regex: RegExp(r'((\s?\|)[\s\S]*?(\|)$)+'),
			// regex: RegExp(r'(\s+[\|].*[^\|]*?)+'),



			// regex: RegExp(r'(\s+[\|].*[^\|]*?)+'),
			// regex: RegExp(r'((\|([^\n])*\|)\n?)+'),
			// regex: RegExp(r'(\n?\|(\s?[^\n])*\|)+'),

			// regex: RegExp(r'(\|(\s?[^\n])*\|)+'),
			// regex: RegExp(r'(?:\h*\|.*?(?=\s*\|)(?:\s*\||$)(?:\n|$))+'),
			// regex: RegExp(r'(?:\s*\|.*?(?=\s*\|)(?:\s*\||$)(?:\n|$))+', multiLine: true),
			// regex: RegExp(r'(\s*\|.*?(?=\s*\|)(?:\s*\||$)(?:\n|$))+', multiLine: true),
			// regex: RegExp(r'(?:\|.*?(?=\|)(?:\||$)(?:\n|$))(?:\n\n|\n)(?:\|.*?(?=\|)(?:\||$)(?:\n|$))*', multiLine: true),
			// regex: RegExp(r'((^\s*([^\\n ].*)\n?)(?=[^\n]))+'),
			// regex: RegExp(r'(\s?((?:|\s{1,}[^\n])\|[^\n]*\|)+)+'),
			// regex: RegExp(r'(\s?((?:|\s{1,}[^\n])\|[^\n]*\|(?:\s|$))){3,}'),
			// regex: RegExp(r'(\s?((?:|\s{0,}[^\n])\|.*\|(?:\s|$))){3,}'),
			// regex: RegExp(r'(^\h*?\|.*\|\h?$\s?)+'),
			regex: RegExp(r'^( *?(?!semi)\|.*\|\s?)+'),

			action: (txt, _){
				// return getTableSpan(context: context, txt: txt, variables: variables);
				InlineSpan? outTable = runZoned((){
					return getTableSpan(
						context: context, txt: txt, variables: variables, id: noteId, hotRefresh: hotRefresh);
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
			// regex: RegExp(r'(?<!\!)\[((?:\[[^\]]*\]|[^\[\]])*)\]\((.*?)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			regex: RegExp(r'(?<!\!)\[((?:\[[^\]]*\]|[^\[\]])*)\]\(([\s\S]*?)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			action: (txt, _){

				// if(txt.contains("What is the best prompt style in the configuration wizard?")){
				// 	debugPrint("HYPER DETECTED !");
				// 	debugPrint(txt);
				// 	print("---------\n\n");
				// 	// debugPrint(txt);
				// 	// debugPrint("${txt.contains('\n')}");
				// }
				// txt = txt.replaceAll("\n", "");


				Match lastWhere = RegExp(r'(\)|\])(\(|\[)').allMatches(txt).last;
				String name = txt.substring(1, lastWhere.start);
				String link = txt.substring(lastWhere.end - 1);
				link = link.substring(1, link.length - 1);
				TextStyle linkStyle = const TextStyle(
					fontSize: 16,
					decorationColor: Colors.blue,
					color: Colors.blue);

				List<InlineSpan> spoon = [];
				TapGestureRecognizer rec = useLinkRecognizer(context, link);

				List<InlineSpan> appliedRules = formattingTexts(
					context: context,
					variables: variables,
					id: noteId,
					hotRefresh: hotRefresh,
					content: name,
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
					recognizer: useLinkRecognizer(context, link),
					style: linkStyle
				);
			}
		),

		
		// {@Image-Link}
		HighlightRule(
			label: "link_image",
			// regex: RegExp(r'\!\[(.*?)\](\(|\[)(.*?)(\)|\])'),
			regex: RegExp(r'\!\[([\s\S]*?)\](\(|\[)([\s\S]*?)(\)|\])'),
			action: (String txt, opt){
				InlineSpan? outImg = runZoned((){
					return showImageFrame(txt, opt.recognizer, variables);
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
			regex: RegExp(r'\`(.*?)\`', multiLine: false),
			action: (txt, opt){
				return getMonospaceTag(
					text: txt.substring(1, txt.length - 1),
					recognizer: opt.recognizer,
				);
			},
		),

		// {@URL}
		HighlightRule(
			label: "url",
			regex: RegExp(r'(https\:|http\:|www)(\/\/|\.)([A-Za-z0-9@:%\.\_\+\~\#\=\/\?\-\&]*)'),
			action: (txt, _) => TextSpan(
				text: txt,
				style: const TextStyle(
					color: Colors.blue,
					fontSize: 16,
					decorationColor: Colors.blue,
					decoration: TextDecoration.underline
				),
				recognizer: useLinkRecognizer(context, txt),
			),
		),

		// {@Italic-Bold, Bold, Italic}
		HighlightRule(
			label: "italic&bold_bold_italic",
			regex: RegExp(r'(\*\*\*|\_\_\_).*?(\*\*\*|\_\_\_)|(\*\*|\_\_).*?(\*\*|\_\_)|(\*|\_).*?(\*|\_)'),
			// regex: RegExp(r'(\*\*\*|___).*?(\1)|(\*\*|__).*?(\3)|(\*|_).*?(\5)'),
			action: (txt, opt){
				int specialChar = RegExp(r'(\*|\_)').allMatches(txt).length;
				if(specialChar % 2 != 0){ specialChar--; }
				specialChar = specialChar ~/ 2;
				return TextSpan(
					text: txt.substring(specialChar, txt.length - specialChar),
					recognizer: opt.recognizer,
					style: 
						specialChar == 3 ? const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic):
						specialChar == 2 ? const TextStyle(fontWeight: FontWeight.bold):
						const TextStyle(fontStyle: FontStyle.italic)
				);
			},
		),
		
		// {@Straight}
		HighlightRule(
			label: "strike",
			regex: RegExp(r'~~.*~~'),
			action: (txt, opt) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				recognizer: opt.recognizer,
				style: TextStyle(
					fontSize: 16,
					decorationColor: Theme.of(context).colorScheme.inverseSurface,
					decorationStyle: TextDecorationStyle.solid,
					decoration: TextDecoration.lineThrough
				)
			),
		),

		// {@Backqoute}
		HighlightRule(
			label: "backqoute",
			regex: RegExp(r'^>\s+.*(?:\n>\s+.*)*'),
			action: (txt, _){
				BackqouteObj obj = getBackqouteElements(context, txt);
				return WidgetSpan(
					child: IntrinsicHeight(
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Container(
									width: 3.5,
									height: double.infinity,
									decoration: BoxDecoration(
										color: obj.color,
										borderRadius: BorderRadius.circular(1)
									),
								),
								const SizedBox(width: 12),
								Expanded(
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											Text.rich(obj.span)
										],
									)
								)
							],
						),
					)
				);
			},
		),

		// {@Emojies}
		HighlightRule(
			label: "emojies",
			regex: RegExp(r'\:\w+\:', multiLine: true),
			action: (String txt, _){
				return WidgetSpan(
					child: FutureBuilder(
						future: DefaultAssetBundle.of(context)
							.loadString('assets/gemoji/data.json'),
						builder: (context, AsyncSnapshot<String> data){
							if(data.hasData){
								List<Map<String, dynamic>> emojies =
									List<Map<String, dynamic>>
									.from(json.decode(data.data!)['emoji']);
								String selected = parseEmojiString(txt, emojies);
								return Text.rich(TextSpan(
									text: selected,
									style: Provider.of<ProviderManager>(context).defaultStyle));
							} else {
								return const SizedBox();
							}
						},
					)
				);
			}
		),





		
		/*
		// {@HTMl}
		HighlightRule(
			label: "html",
			// regex: RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>'),
			regex: RegExp(r'<(?<tag>\w+)(.*?)>([^<]+(?:<(?!\/\k<tag>\s*>)[\s\S]*?)?)?<\/\k<tag>\s*>|<?<tag>\w+[^>]*\s*\/?>|<(\w+)[^>]*\s*\/?>'),
			action: (txt, opt){
				// print(RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>').hasMatch(txt));
				// Detected as Syntax-Hihglighting
				// For some languages like rust the tag detection is issue, to fix:
				if(txt.contains("```")){
					return TextSpan(
						children: [
							const TextSpan(text: "\n"),
							WidgetSpan(
								child: MarkdownWidget(
									content: txt,
									height: Provider.of<ProviderManager>(context).defaultStyle.height!,
								)
							),
							const TextSpan(text: "\n")
						]
					);
				}

				print(opt.recognizer);

				// Detected as HTML
				return applyHtmlRules(
					context: context,
					txt: txt,
					variables: variables,
					noteId: noteId,
					hotRefresh: hotRefresh,
					forceStyle: const TextStyle()
				);
			},
		),
		*/



		// etc..
	];

	return rules;
}


import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/backqoute_element.dart';
import 'package:ekko/markdown/formatting.dart';
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

int lastIndent = 0;
int indentStep = 0;
// Map<String, String> variables = {};

List<HighlightRule> allSyntaxRules(BuildContext context){
	List<HighlightRule> rules = [


		// // {@Variables},
		// HighlightRule(
		// 	label: "variable",
		// 	// regex: RegExp(r'\[.*?\]\s*\:\s*\s*(https?\:\/\/\S+)'), 
		// 	regex: RegExp(r'\[.*?\]\s*\:\s*\s*(https?://\S+)'), 
		// 	action: (String txt, _){
		// 		RegExp r = RegExp(r']\s*\:');
		// 		String key = txt.split(r).first.replaceAll(RegExp(r'(\[|\])'), '').trim();
		// 		String value = txt.split(r).last.trim();
		// 		variables[key] = value;
		// 		// print(value);
		// 		return const TextSpan();
		// 	},
		// ),

		// {@Syntax-Hihglighting}
		HighlightRule(
			label: "markdown",
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
			action: (String text, _) => WidgetSpan(
				child: MarkdownWidget(
					content: text,
					height: Provider.of<ProviderManager>(context).defaultStyle.height!,
				)
			),
		),

		// {@Headlines}
		HighlightRule(
			label: "headline",
			regex: RegExp(r"^#{1,6} [\s\S]*?$"),
			action: (txt, _){
				int sharpLength = RegExp(r'^\#{1,6}\s?').firstMatch(txt)!.group(0)!.trim().length;
				TextSpan span = TextSpan(
					text: txt.substring(sharpLength + 1),
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
				child: Divider(height: 1)
			),
		),

		// {@Checkbox}
		HighlightRule(
			label: "checkbox",
			regex: RegExp(r'^(-|\+|\*)\s{1}(\[ \]|\[x\])\s+(.*)$', multiLine: true),
			action: (txt, _){
				bool isChecked = txt.trim().substring(0, 5).contains("x");
				return WidgetSpan(
					child: SublistWidget(
						type: SublistWidgetType.widget,
						leading: SizedBox(
							width: 18,
							height: 0,
							child: Transform.scale(
								scale: 0.8,
								child: IgnorePointer(
									child: Checkbox(
										value: isChecked,
										onChanged: null
									),
								),
							) ,
						),
						data: TextSpan(
							children: [formattingTexts(
								context: context,
								content: txt.trim().substring(5).trim(),  // Rm <whitespaces>
							)]
						) 
					)
				);
			},
		),

		// {@Item}
		HighlightRule(
			label: "item",
			regex: RegExp(r'^\s*(-|\+|\*)\s+.+$'),
			action: (txt, _){
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
								content: txt.trim().substring(1).trim(),
							)]
						) 
					)
				);
			},
		),



		// // {@Image-Link}
		// HighlightRule(
		// 	label: "link_image",
		// 	regex: RegExp(r'\!\[(.*?)\](\(|\[)(.*?)(\)|\])'),
		// 	action: (String txt, r){
		// 		return showImageFrame(txt);
		// 	},
		// ),

		// {@Hyper-Link}
		HighlightRule(
			label: "links",
			// regex: RegExp(r'\[(.*?)\]\((.*?)\)'),
			// regex: RegExp(r'(\[).*?(\])(\(|\[).*(\)|\])'),
			//regex: RegExp(r'(?<!\!)(\[).*?(\])(\(|\[).*(\)|\])'),

			// regex: RegExp(r'(?<!\!)(\[).*(\])(\(|\[).*(\)|\])'),
			// regex: RegExp(r'(?<!\!)(\[).*?(\])(\(|\[)(?!\]).*?(\)|\])'),
			// regex: RegExp(r'(?<!\!)(\[).*?(\])(\(|\[)(?!\]).*?(\)|\])'),
			// regex: RegExp(r'\[((?:\[[^\]]*\]|[^\[\]])*)\]\((https?:\/\/[^\s)]+)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			regex: RegExp(r'(?<!\!)\[((?:\[[^\]]*\]|[^\[\]])*)\]\((https?:\/\/[^\s)]+)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			// regex: RegExp(r'\[((?:[^\[\]]+|\[(?:[^\[\]]+|\[(?:[^\[\]]+|\[(?:[^\[\]]+)?\])*\])*\])*)\](\(|\[)(.*?)(\)|\])'),
			// regex: RegExp(r'\[((?:[^\[\]]+|\[(?:[^\[\]]+|\[(?:[^\[\]]+|\[(?:[^\[\]]+)?\])*\])*\])*)\](\(|\[).*?(\)|\])'),
			action: (txt, _){


				// return TextSpan(text: txt);
				// RegExp r = RegExp(r'\](\(|\[)');
				// String name = txt.split(r)[0]
				// 	.substring(1).trim();
				// String link = txt.split(r)[1].trim();
				// link = link.substring(0, link.length - 1).trim();
				Match lastWhere = RegExp(r'(\)|\])(\(|\[)').allMatches(txt).last;
				String name = txt.substring(1, lastWhere.start);
				String link = txt.substring(lastWhere.end - 1);
				link = link.substring(1, link.length - 1);

				TextStyle linkStyle = const TextStyle(
					fontSize: 16,
					decorationColor: Colors.blue,
					color: Colors.blue);

				// if(txt.contains("on iOS")){
				if(txt.contains("CI Status")){
					// print(txt);
					// print(name);
					// print(link);
				}

				List<InlineSpan> spoon = [];
				TapGestureRecognizer rec = useLinkRecognizer(context, link);

				List<InlineSpan> appliedRules = formattingTexts(
					context: context,
					content: name,
					recognizer: rec,
				).children!;

				for(InlineSpan span in appliedRules){
					if(span is TextSpan){
						if(span.children == null){
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
			// regex: RegExp(r'\!\[(.*?)\]\((.*?)\)'),
			// regex: RegExp(r'\!\[(.*?)\](\)|\])(.*?)(\)|\])'),
			regex: RegExp(r'\!\[(.*?)\](\(|\[)(.*?)(\)|\])'),
			action: (String txt, r){
				// return TextSpan(text: txt);
				return showImageFrame(txt);
				// String name = txt.split("](")[0]
				// 	.substring(2).trim();
				// String link = txt.split("](")[1].trim();
				// link = link.substring(0, link.length - 1).trim();

				// // return TextSpan(text: txt, style: TextStyle(color: Colors.red));
				// return WidgetSpan(
				// 	child: SvgPicture.network(link)
				// );

			},
		),


		// {@Monospace}
		HighlightRule(
			label: "monospace",
			regex: RegExp(r'\`(.*?)\`', multiLine: false),
			action: (txt, recognizer){
				return getMonospaceTag(
					text: txt.substring(1, txt.length - 1),
					recognizer: recognizer,
				);
			},
		),

		// {@URL}
		HighlightRule(
			label: "url",
			// regex: RegExp(r'(https?://\S+)'),
			// regex: RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'),
			// regex: RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'),
			// regex: RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'),
			// regex: RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)'),
			regex: RegExp(r'(https\:|http\:|www)(\/\/|\.)([A-Za-z0-9@:%\.\_\+\~\#\=\/\?\-]*)'),
			// action: (txt, _) => TextSpan(text: txt)
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

		// {@Italic-Bold}
		HighlightRule(
			label: "italic_bold",
			regex: RegExp(r'\*\*\*(.*?)\*\*\*'),
			action: (txt, rec) => TextSpan(
				text: txt.substring(3, txt.length - 3),
				recognizer: rec,
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold,
					fontStyle: FontStyle.italic
				)
			),
		),

		// {@Bold}
		HighlightRule(
			label: "boldness",
			regex: RegExp(r'\*\*(.*?)\*\*'),
			action: (txt, rec) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				recognizer: rec,
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold
				)
			),
		),

		// {@Italic}
		HighlightRule(
			label: "italic",
			regex: RegExp(r'\*(.*?)\*'),
			action: (txt, rec) => TextSpan(
				text: txt.substring(1, txt.length - 1),
				recognizer: rec,
				style: const TextStyle(
					fontSize: 16,
					fontStyle: FontStyle.italic
				)
			),
		),
		
		// {@Straight}
		HighlightRule(
			label: "strike",
			regex: RegExp(r'~~.*~~'),
			action: (txt, rec) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				recognizer: rec,
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

		// {@Table}
		HighlightRule(
			label: "table",
			regex: RegExp(r'(?!smi)(\|[\s\S]*?)\|(?:\n)$'),
			action: (txt, _){
				return getTableSpan(context: context, txt: txt);
			},
		),

		// etc..
	];

	return rules;
}


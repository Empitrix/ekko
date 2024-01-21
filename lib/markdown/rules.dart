import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/backqoute_element.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/monospace.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

int lastIndent = 0;
int indentStep = 0;

List<HighlightRule> allSyntaxRules(BuildContext context){
	List<HighlightRule> rules = [
		// Markdown
		HighlightRule(
			label: "markdown",
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
			action: (String text) => WidgetSpan(
				child: MarkdownWidget(
					content: text,
					height: Provider.of<ProviderManager>(context).defaultStyle.height!,
				)
			),
		),

		// Headline 1..6
		HighlightRule(
			label: "headline",
			regex: RegExp(r"^#{1,6} [\s\S]*?$"),
			action: (txt){
				int sharpLength = "#".allMatches(txt).length;
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

		// Divider
		HighlightRule(
			label: "divider",
			// regex: RegExp(r'^\s*---\s*$'),
			regex: RegExp(r'^---$'),
			trimNext: true,
			action: (_) => const WidgetSpan(
				child: Divider(height: 1)
			),
		),

		// Sublist CheckedBox
		HighlightRule(
			label: "checkbox",
			regex: RegExp(r'^(-|\+|\*)\s{1}(\[ \]|\[x\])\s+(.*)$', multiLine: true),
			action: (txt){
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
			// regex: RegExp(r'^-\s{1}(\[ \]|\[x\])\s+(.*)$', multiLine: true),
		),

		// Sublist - Item
		HighlightRule(
			label: "item",
			regex: RegExp(r'^\s*(-|\+|\*)\s+.+$'),
			action: (txt){
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
			// regex: RegExp(r'^\s*-\s+.+$'),
		),

		// Monospace
		HighlightRule(
			label: "monospace",
			regex: RegExp(r'\`.*?\`', multiLine: true),
			action: (txt) => getMonospaceTag(
				txt.substring(1, txt.length - 1)
			),
		),

		// Links
		HighlightRule(
			label: "links",
			// regex: RegExp(r'\[.*?\]\(.*?\)'),
			regex: RegExp(r'\[(.*?)\]\((.*?)\)'),
			action: (txt){
				String name = txt.split("](")[0]
					.substring(1).trim();
				String link = txt.split("](")[1].trim();
				link = link.substring(0, link.length - 1).trim();
				TextStyle linkStyle = const TextStyle(
					fontSize: 16,
					decorationColor: Colors.blue,
					color: Colors.blue,
				);
				List<TextSpan> spoon = [];
				for(InlineSpan spn in formattingTexts(context: context, content: name).children!){
					spoon.add(TextSpan(
						text: spn.toPlainText(),
						style: spn.style,
						recognizer: useLinkRecognizer(context, link),
					));
				}
				return TextSpan(
					children: spoon,
					recognizer: useLinkRecognizer(context, link),
					style: linkStyle,
				);
			}
		),

		// URL
		HighlightRule(
			label: "url",
			regex: RegExp(r'(https?://\S+)'),
			action: (txt) => TextSpan(
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

		// Italic & Bold
		HighlightRule(
			label: "italic_bold",
			regex: RegExp(r'\*\*\*(.*?)\*\*\*'),
			action: (txt) => TextSpan(
				text: txt.substring(3, txt.length - 3),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold,
					fontStyle: FontStyle.italic
				)
			),
		),

		// Bold
		HighlightRule(
			label: "boldness",
			regex: RegExp(r'\*\*(.*?)\*\*'),
			action: (txt) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold
				)
			),
		),

		// Italic
		HighlightRule(
			label: "italic",
			regex: RegExp(r'\*(.*?)\*'),
			action: (txt) => TextSpan(
				text: txt.substring(1, txt.length - 1),
				style: const TextStyle(
					fontSize: 16,
					fontStyle: FontStyle.italic
				)
			),
		),

		HighlightRule(
			label: "strike",
			regex: RegExp(r'~~.*~~'),
			action: (txt) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				style: TextStyle(
					fontSize: 16,
					decorationColor: Theme.of(context).colorScheme.inverseSurface,
					decorationStyle: TextDecorationStyle.solid,
					decoration: TextDecoration.lineThrough
				)
			),
		),

		// Backqoute
		HighlightRule(
			label: "backqoute",
			regex: RegExp(r'^>\s+.*(?:\n>\s+.*)*'),
			action: (txt){
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

		// etc..
	];

	return rules;
}


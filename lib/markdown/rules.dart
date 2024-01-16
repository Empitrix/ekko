import 'package:ekko/backend/launcher.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/monospace.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/markdown/sublist_widget.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


List<HighlightRule> allSyntaxRules(BuildContext context){
	List<HighlightRule> rules = [
		// Markdown
		HighlightRule(
			label: "markdown",
			action: (String text) => WidgetSpan(
				child: MarkdownWidget(
					content: text,
					height: Provider.of<ProviderManager>(context).defaultStyle.height!,
				)
			),
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
		),

		// Headline 1..6
		HighlightRule(
			label: "headline",
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
								Text.rich(span),
								const Divider()
							],
						)
					);
				}
				return span;
			},
			regex: RegExp(r"^#{1,6} [\s\S]*?$"),
		),

		// Divider
		HighlightRule(
			label: "divider",
			trimNext: true,
			action: (_) => const WidgetSpan(
				child: Divider(height: 1)
			),
			regex: RegExp(r'^\s*---\s*$'),
		),

		// Sublist CheckedBox
		HighlightRule(
			label: "checkbox",
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
							children: formattingTexts(
								context: context,
								content: txt.trim().substring(5).trim(),  // Rm <whitespaces>
							)
						) 
					)
				);
			},
			regex: RegExp(r'^-\s{1}(\[ \]|\[x\])\s+(.*)$'),
		),

		// Sublist - Item
		HighlightRule(
			label: "item",
			action: (txt){
				int indentedLvl = (tillFirstLetter(txt) / 2).floor();
				return WidgetSpan(
					child: SublistWidget(
						// leading: const Icon(Icons.circle, size: 8),
						leading: Icon(
							indentedLvl == 0 ? Icons.circle :
							indentedLvl == 2 ? Icons.circle_outlined :
							Icons.square,
							size: 8,
						),
						indentation: (indentedLvl ~/ 2) * 20,
						data: TextSpan(
							children: formattingTexts(
								context: context,
								content: txt.trim().substring(1).trim(),
							)
						) 
					)
				);
			},
			regex: RegExp(r'^\s*-\s+.+$'),
		),

		// Monospace
		HighlightRule(
			label: "monospace",
			action: (txt) => getMonospaceTag(
				txt.substring(1, txt.length - 1)
			),
			regex: RegExp(r'\`.*?\`', multiLine: true),
		),

		// Links
		HighlightRule(
			label: "links",
			regex: RegExp(r'\[.*\]\(.*\)'),
			action: (txt){
				String name = txt.split("](")[0]
					.substring(1).trim();
				String link = txt.split("](")[1].trim();
				link = link.substring(0, link.length - 1).trim();
				TextStyle linkStyle = const TextStyle(
					fontSize: 16,
					decoration: TextDecoration.underline,
					decorationColor: Colors.blue,
					color: Colors.blue,
				);
				return TextSpan(
					children: formattingTexts(
						context: context,
						content: name,
						recognizer: TapGestureRecognizer()..onTap = () async {
							await launchThis(
								context: context, url: link);
							debugPrint("Opening: $link"); 
						},
						mergeStyle: linkStyle,
					),
				);
			}
		),

		// URL
		HighlightRule(
			label: "url",
			action: (txt) => TextSpan(
				text: txt,
				style: const TextStyle(
					color: Colors.blue,
					decorationColor: Colors.blue,
					decoration: TextDecoration.underline
				),
				recognizer: TapGestureRecognizer()..onTap = () async {
					await launchThis(
						context: context, url: txt);
					debugPrint("Opening: $txt"); 
				},
			),
			regex: RegExp(r'(https?://\S+)'),
		),

		// Italic & Bold
		HighlightRule(
			label: "italic_bold",
			action: (txt) => TextSpan(
				text: txt.substring(3, txt.length - 3),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold,
					fontStyle: FontStyle.italic
				)
			),
			regex: RegExp(r'\*\*\*(.*?)\*\*\*'),
		),

		// Bold
		HighlightRule(
			label: "boldness",
			action: (txt) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				style: const TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.bold
				)
			),
			regex: RegExp(r'\*\*(.*?)\*\*'),
		),

		// Italic
		HighlightRule(
			label: "italic",
			action: (txt) => TextSpan(
				text: txt.substring(1, txt.length - 1),
				style: const TextStyle(
					fontSize: 16,
					fontStyle: FontStyle.italic
				)
			),
			regex: RegExp(r'\*(.*?)\*'),
		),

		HighlightRule(
			label: "strike",
			action: (txt) => TextSpan(
				text: txt.substring(2, txt.length - 2),
				style: TextStyle(
					fontSize: 16,
					decorationColor: Theme.of(context).colorScheme.inverseSurface,
					decorationStyle: TextDecorationStyle.solid,
					decoration: TextDecoration.lineThrough
				)
			),
			regex: RegExp(r'~~.*~~'),
		),

		// Backqoute
		HighlightRule(
			label: "backqoute",
			action: (txt){
				txt = txt.trim().substring(1);
				return WidgetSpan(
					child: Column(
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Row(
								children: [
									const SizedBox(
										height: 30,
										child: VerticalDivider()),
									const SizedBox(width: 10),
									Expanded( child: SingleChildScrollView(
										controller: ScrollController(),
										scrollDirection: Axis.horizontal,
										child: Column(
											children: [
												Text(
													txt,
													style: const TextStyle(
														fontStyle: FontStyle.italic),
												)
											],
										),
									))
								],
							),
						],
					)
				);
			},
			regex: RegExp(r'^\s*>\s+.+$'),
		),
	];

	return rules;
}


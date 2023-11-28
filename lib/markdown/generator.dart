import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';


class MDGenerator extends StatelessWidget {
	final String content;
	final double textHeight;
	const MDGenerator({
		super.key,
		required this.content,
		this.textHeight = 0.0
	});

	@override
	Widget build(BuildContext context) {

		List<Widget> widgetTree = [];
		
		TextStyle defaultStyle = TextStyle(
			fontSize: 16,
			fontWeight: FontWeight.w500,
			height: textHeight
		);

		// Load highlight rules
		List<HighlightRule> rules = allSyntaxRules(
			context: context,
			textHeight: textHeight,
			defaultStyle: defaultStyle
		);

		// Apply rules and add to widgetTree
		widgetTree = applyRules(
			context: context,
			content: content,
			defaultStyle: defaultStyle,
			rules: rules
		);


		return Container(
			margin: const EdgeInsets.all(0),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: widgetTree,
			),
		);
	}
}

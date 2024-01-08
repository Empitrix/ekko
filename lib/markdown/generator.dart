import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';


class MDGenerator extends StatelessWidget {
	final String content;
	const MDGenerator({
		super.key,
		required this.content,
	});

	@override
	Widget build(BuildContext context) {

		List<Widget> widgetTree = [];

		// Load highlight rules
		List<HighlightRule> rules = allSyntaxRules(
			context: context,
		);

		// Apply rules and add to widgetTree
		widgetTree = applyRules(
			context: context,
			content: content,
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


import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:flutter/material.dart';


class MDGenerator extends StatelessWidget {
	final String content;
	const MDGenerator({
		super.key,
		required this.content,
	});

	@override
	Widget build(BuildContext context) {

		// Apply rules and add to widgetTree
		TextSpan spanWidget = applyRules(
			context: context,
			content: content,
			rules: allSyntaxRules(context)
		);

		return Text.rich(spanWidget);
		// return Padding(
		// 	padding: const EdgeInsets.all(4),
		// 	child: Text.rich(spanWidget)
		// );
	}
}


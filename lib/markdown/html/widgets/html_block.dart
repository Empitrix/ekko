import 'package:ekko/markdown/html/rendering.dart';
import 'package:ekko/markdown/html/tools.dart';
import 'package:flutter/material.dart';

class HtmlBlock extends StatelessWidget {
	final Map htmlInput;

	const HtmlBlock({
		super.key,
		required this.htmlInput,
	});

	@override
	Widget build(BuildContext context) {
		Map attr = htmlInput['attributes'];

		HtmlCalculator calc = HtmlCalculator(context: context);
		return ClipRRect(
			borderRadius: calc.borderRadius(attr['border-radius']!),
			child: Container(
				child: Text.rich(
					htmlRendering(
						content: htmlInput,
						opt: opt,
						gOpt: gOpt
					)
				),
			),
		);
	}
}


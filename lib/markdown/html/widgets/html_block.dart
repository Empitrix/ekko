import 'package:ekko/markdown/html/tools.dart';
import 'package:flutter/material.dart';


class HtmlBlock extends StatelessWidget {
	final Map attr;
	final InlineSpan child;

	const HtmlBlock({
		super.key,
		required this.attr,
		required this.child,
	});

	@override
	Widget build(BuildContext context) {
		HtmlCalculator calc = HtmlCalculator(context: context);

		return ClipRRect(
			borderRadius: calc.borderRadius(attr['border-radius']),
			child: Container(
				decoration: BoxDecoration(
					borderRadius: calc.borderRadius(attr['border-radius']),
				),
				child: Builder(
					builder: (BuildContext context){
						if(attr['align'] != null){
							Alignment widgetAlign = calc.alignment(attr['align']);
							return Align(
								alignment: widgetAlign,
								child: Text.rich(
									child,
									textAlign: TextAlign.center,
								),
							);
						}
						return Text.rich(child);
					},
				),
			),
		);
	}
}


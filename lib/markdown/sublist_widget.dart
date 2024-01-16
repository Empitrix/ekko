import 'package:ekko/backend/backend.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/utils/calc.dart';
import 'package:flutter/material.dart';

enum SublistWidgetType {
	icon,
	widget
}

class SublistWidget extends StatelessWidget {
	final Widget leading;
	final TextSpan data;
	final SublistWidgetType type;
	final double indentation;
	const SublistWidget({
			super.key,
			required this.leading,
			required this.data,
			this.type = SublistWidgetType.icon,
			this.indentation = 0
		});

	@override
	Widget build(BuildContext context) {

		// Calculate margin
		double widgetSize = getNonRenderedWidgetSize(leading);
		double margin = (calcTextSize(context, "").height / 2) - (widgetSize / 2);
		if(type == SublistWidgetType.widget){ margin = margin + 8; }

		return Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				if (type == SublistWidgetType.icon) const SizedBox(width: 5),
				SizedBox(width: indentation),
				Container(
					margin: isDesktop() ?
						EdgeInsets.symmetric(vertical: margin) :
						EdgeInsets.only(top: margin + 2, bottom: margin),
					child: leading,
				),
				SizedBox(width: type == SublistWidgetType.icon ? 17 : 12),
				Expanded(
					child: Text.rich(TextSpan(
						children: [
							const TextSpan(
								text: "\u000A",
								style: TextStyle(color: Colors.red, fontSize: 1)
							),
							data,
						]
					))
				)
			],
		);
	}
}

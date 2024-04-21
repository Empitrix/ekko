import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/formatting.dart';
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
	final Function? leadingOnTap;
	final bool iconHasAction;
	const SublistWidget({
			super.key,
			required this.leading,
			required this.data,
			this.type = SublistWidgetType.icon,
			this.iconHasAction = false,
			this.indentation = 0,
			this.leadingOnTap
		});

	@override
	Widget build(BuildContext context) {

		// Calculate margin
		double widgetSize = getNonRenderedWidgetSize(leading);
		double margin = (calcTextSize(context, "").height / 2) - (widgetSize / 2);

		// was 8 (just in case cause any err)
		if(type == SublistWidgetType.widget){ margin = margin + 9.5; }

		List<Widget> leadingRow = [
			//if (type == SublistWidgetType.icon && leadingOnTap == null) const SizedBox(width: 5),
			if (type == SublistWidgetType.icon) const SizedBox(width: 5),

			SizedBox(width: indentation),
			Container(
				// margin: isDesktop() ?
				// 	// EdgeInsets.symmetric(vertical: margin) :
				// 	EdgeInsets.only(top: margin - (leadingOnTap == null ? 0 : 4)) :
				// 	EdgeInsets.only(top: margin + (leadingOnTap == null ? 2 : -3)),
				margin: EdgeInsets.only(
					top: margin +
						(isDesktop() ? - (leadingOnTap == null ? 0 : 4):
						(leadingOnTap == null ? 1 : -3))  // first: 2
				),
				child: settingModes['checkListCheckable'] ? Padding(
					padding: (type == SublistWidgetType.icon && leadingOnTap == null) ?
						EdgeInsets.only(left: (widgetSize / 2) + 1.0):
						EdgeInsets.zero,
					child: leading,
				): leading,
			),
			// SizedBox(width: type == SublistWidgetType.icon ? 17 : 12),
			// SizedBox(width: type == SublistWidgetType.icon ? iconHasAction ? 0 : 17 : 12),
			SizedBox(width: type == SublistWidgetType.icon ? iconHasAction ? 11.95 : 17 : 12),
		];

		return Row(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				if(leadingOnTap != null) GestureDetector(
					onTap: (){
						leadingOnTap!();
					},
					child: Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: leadingRow,
					),
				) else ...leadingRow,

				// if (type == SublistWidgetType.icon) const SizedBox(width: 5),
				// SizedBox(width: indentation),
				// Container(
				// 	margin: isDesktop() ?
				// 		EdgeInsets.symmetric(vertical: margin) :
				// 		EdgeInsets.only(top: margin + 2, bottom: margin),
				// 	child: leading,
				// ),
				// SizedBox(width: type == SublistWidgetType.icon ? 17 : 12),
				Expanded(
					child: Text.rich(TextSpan(
						children: [
							endLineChar(),
							data,
						]
					))
				)
			],
		);
	}
}

/*
class SublistWidget extends StatelessWidget {
	final Widget leading;
	final TextSpan data;
	final SublistWidgetType type;
	final double indentation;
	final Function? leadingOnTap;
	const SublistWidget({
		super.key,
		required this.leading,
		required this.data,
		this.type = SublistWidgetType.icon,
		this.indentation = 0,
		this.leadingOnTap
	});

	@override
	Widget build(BuildContext context) {
		double widgetSize = getNonRenderedWidgetSize(leading);
		double margin = (calcTextSize(context, "").height / 2) - (widgetSize / 2);
		
		
		return Row(
			// crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				SizedBox(width: indentation),
				
				GestureDetector(
					onTap: leadingOnTap != null ? (){leadingOnTap!();} : null,
					child: leading,
				),

				// Text Data
				Expanded(
					child: Text.rich(TextSpan(
						children: [
							endLineChar(),
							data,
						]
					))
				)
			]
		);
	}
}

*/

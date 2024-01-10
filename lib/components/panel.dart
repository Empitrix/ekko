import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
	final Text title;
	final List<Widget> childern;
	final double roundness;
	final Color? backgroundColor;
	final EdgeInsets? padding;
	final EdgeInsets? margin;
	const Panel({
		super.key,
		required this.title,
		required this.childern,
		this.roundness = 5,
		this.backgroundColor,
		this.padding,
		this.margin
	});

	@override
	Widget build(BuildContext context) {

		Text titleText = Text(
			title.data ?? "",
			style: title.style ?? TextStyle(
				fontSize: 20,
				color: Theme.of(context).colorScheme.inverseSurface,
			),
		);

		return Container(
			padding: padding,
			margin: margin,
			decoration: BoxDecoration(
				color: Colors.transparent,
				borderRadius: BorderRadius.circular(roundness),
			),
			child: Material(
				color: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor!.aae(context).withOpacity(dMode ? 0.6 : 0.5),
				borderRadius: BorderRadius.circular(roundness),
				elevation: 0.5,
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Padding(
							padding: const EdgeInsets.only(top: 8, left: 12),
							child: titleText,
						),
						const SizedBox(height: 12),
						for(Widget child in childern) child,
						const SizedBox(height: 12),
					],
				),
			)
		);
	}
}


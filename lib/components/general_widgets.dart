import 'package:flutter/material.dart';


class SheetText extends StatelessWidget {
	final Widget text;
	final double horizontalMargin;
	const SheetText({
		super.key,
		required this.text,
		this.horizontalMargin = 16
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			margin: const EdgeInsets.symmetric(horizontal: 16),
			child: text,
		);
	}
}

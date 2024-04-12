import 'package:flutter/material.dart';

class CustomModifyButton extends StatelessWidget {
	final Widget label;
	final Widget icon;
	final Function onPressed;
	const CustomModifyButton({
		super.key,
		required this.label,
		required this.icon,
		required this.onPressed
	});

	@override
	Widget build(BuildContext context) {
		return TextButton.icon(
			style: const ButtonStyle(
				foregroundColor: WidgetStatePropertyAll(
					Colors.white
				),
				shape: WidgetStatePropertyAll(
					RoundedRectangleBorder(
						borderRadius: BorderRadius.only(
							topRight: Radius.zero,
							topLeft: Radius.circular(15),
							bottomLeft: Radius.circular(15),
							bottomRight: Radius.zero
						)
					)
				)
			),
			label: label,
			icon: icon,
			onPressed: () => onPressed(),
		);
	}
}


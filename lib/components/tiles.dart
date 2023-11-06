import 'package:flutter/material.dart';

/* Switch List tile widget */
class SwitchTile extends StatelessWidget {
	final Widget title;
	final Widget leading;
	final bool value;
	final ValueChanged<bool> onChange;
	final double scale;
	const SwitchTile({super.key,
		required this.leading,
		required this.title,
		required this.value,
		required this.onChange,
		this.scale = 0.8});
	
	@override
	Widget build(BuildContext context) {
		return ListTile(
			leading: leading,
			title: title,
			trailing: Transform.scale(
				scale: scale,
				child: IgnorePointer(
					child: Switch(
						value: value,
						onChanged: (_){},
					),
				),
			),
			onTap: () => onChange(!value),
		);
	}
}

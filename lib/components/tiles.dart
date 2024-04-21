import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/public.dart';
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
						inactiveThumbColor: settingModes['dMode'] ? null : Colors.grey[600],
						inactiveTrackColor: settingModes['dMode'] ? null : Colors.grey[400],
					),
				),
			),
			onTap: () => onChange(!value),
		);
	}
}




class SliderTile extends StatelessWidget {
	final String text;
	final double value;
	final ValueChanged<double> onChanged;
	final Widget leading;
	const SliderTile({
		super.key,
		required this.leading,
		required this.text,
		required this.value,
		required this.onChanged
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			// margin: const EdgeInsets.all(18),
			margin: const EdgeInsets.only(
				top: 5, bottom: 5,
				right: 18, left: 15
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const SizedBox(width: 12),
					const SizedBox(
						height: 55,
						child: VerticalDivider(width: 2),
					),
					const SizedBox(width: 12),
					Expanded(
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Row(
									children: [
										leading,
										const SizedBox(width: 12),
										Text(
											text,
											style: const TextStyle(
												fontSize: 14,
												fontWeight: FontWeight.bold),
										),
										const SizedBox(width: 5),
										Container(
											decoration: BoxDecoration(
												color: Theme.of(context).scaffoldBackgroundColor.aae(context, -1),
												borderRadius: BorderRadius.circular(5)
											),
											padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
											child: Text("${(value * 100).round().toString().padLeft(2, "0")}%"),
										)
									],
								),
								Slider(
									value: value,
									onChanged: onChanged
								)
							],
						),
					)
				],
			)
		);
	}
}



class TwoColorPalette extends StatelessWidget {
	final Color? baseColor;
	final Color borderColor;
	final double radius;
	final double size;
	final double padding;
	const TwoColorPalette({
		super.key,
		required this.baseColor,
		required this.borderColor,
		this.radius = 5,
		this.size = 18,
		this.padding = 2
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			height: size,
			width: size,
			decoration: BoxDecoration(
				color: baseColor,
				borderRadius: BorderRadius.circular(radius),
				border: Border.all(width: padding, color: borderColor)
			),
		);
	}
}


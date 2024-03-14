import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
	final String title;
	final String subtitle;
	final IconData icon;

	const SettingItem({
		super.key,
		required this.title,
		required this.subtitle,
		required this.icon
	});

	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: (){},
			borderRadius: BorderRadius.circular(5),
			child: Container(
				padding: const EdgeInsets.only(top: 12, bottom: 5, left: 12, right: 5),
				decoration: BoxDecoration(
					color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
					borderRadius: BorderRadius.circular(5)
				),
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Icon(icon),
						const SizedBox(width: 16),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										title,
										style: TextStyle(
											fontSize: 18,
											fontWeight: FontWeight.bold,
											color: Theme.of(context).colorScheme.inverseSurface
										),
									),
									Text(
										subtitle,
										style: TextStyle(
											fontSize: 14,
											color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5)
										),
									),
								],
							),
						)
					],
				),
			),
		);
	}
}

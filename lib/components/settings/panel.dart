import 'package:flutter/material.dart';

class SettingPanel extends StatelessWidget {
	final Text title;
	final List<Widget> children;

	const SettingPanel({
			super.key,
			required this.title,
			required this.children
		});

	@override
	Widget build(BuildContext context) {

		Widget titleWidget = title;
		if(title.style == null){
			titleWidget = Text(
				title.data ?? "",
				style: Theme.of(context).primaryTextTheme.titleMedium!.copyWith(
					color: Theme.of(context).colorScheme.inverseSurface,
					fontSize: 20,
					fontWeight: FontWeight.bold
				),
			);
		}

		return Container(
			margin: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 12),
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
				borderRadius: BorderRadius.circular(5)
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Padding(
						padding: const EdgeInsets.only(left: 16, top: 8),
						child: titleWidget,
					),
					const SizedBox(height: 12),
					...children,
					const SizedBox(height: 6),
				],
			),
		);
	}
}


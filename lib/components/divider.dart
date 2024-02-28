import 'package:flutter/material.dart';

enum LineSide { right, left, both, none }

class DividerLine extends StatelessWidget {
	final double height;
	final double? width;
	final Color? color;
	final LineSide lineSide;
	const DividerLine({
		super.key,
		required this.lineSide,
		this.height = 2,
		this.width,
		this.color});
	@override
	Widget build(BuildContext context) {
		return Container(
			width: width,
			height: height,
			decoration: BoxDecoration(
				color: color ?? Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
				borderRadius: lineSide == LineSide.right ?
					const BorderRadius.only(
						topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)):
					lineSide == LineSide.left ? const BorderRadius.only(
						topRight: Radius.circular(5), bottomRight: Radius.circular(5)):
					lineSide == LineSide.both ? BorderRadius.circular(5):
						BorderRadius.zero
			),
		);
	}
}



class TitleDivider extends StatelessWidget {
	final String title;
	final double height;
	const TitleDivider({
		super.key,
		required this.title,
		this.height = 2
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const SizedBox(height: 12),
				Row(
					children: [
						DividerLine(height: height, width: 20, lineSide: LineSide.left),
						const SizedBox(width: 12),
						Text(
							title,
							style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
								color: Theme.of(context).colorScheme.inverseSurface,
								fontWeight: FontWeight.w900
							),
						),
						const SizedBox(width: 12),
						Expanded(child: DividerLine(height: height, width: 20, lineSide: LineSide.right))
					],
				),
				const SizedBox(height: 8),
			],
		);
	}
}


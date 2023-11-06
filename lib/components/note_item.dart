import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
	final int index;
	const NoteItem({super.key, required this.index});

	@override
	Widget build(BuildContext context) {
		return InkWell(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text("${index + 1}")
				],
			),
			onTap: (){},
		);
	}
}

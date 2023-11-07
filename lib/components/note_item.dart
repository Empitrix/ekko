import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
	final Note note;
	const NoteItem({super.key, required this.note});

	@override
	Widget build(BuildContext context) {
		return InkWell(
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
				child: Row(
					children: [
						IconButton(
							icon: const Icon(Icons.edit),
							onPressed: (){/* Modify Page */},
						),
						const SizedBox(width: 12),
						Expanded(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										note.title,
										overflow: TextOverflow.ellipsis,
										style: TextStyle(
											fontSize: 16,
											color: Theme.of(context)
												.colorScheme
												.inverseSurface,
											fontWeight: FontWeight.bold,
										),
									),
									Text(
										note.description,
										overflow: TextOverflow.ellipsis,
										style: TextStyle(
											fontSize: 14,
											color: Theme.of(context)
												.colorScheme.
												inverseSurface
												.withOpacity(0.5)
										),
									),
								],
							)
						),
						const SizedBox(width: 12),
						IconButton(
							icon: const Icon(Icons.copy),
							onPressed: (){/* Note Actons */},
						),
					],
				),
			),
			onTap: (){/* Present the Note contents */},
		);
	}
}

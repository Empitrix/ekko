import 'package:flutter/material.dart';

class ModifyField extends StatelessWidget {
	final TextEditingController controller;
	final String name;
	const ModifyField({
		super.key,
		required this.controller,
		required this.name
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			child: TextField(
				style: Theme.of(context).primaryTextTheme.headlineLarge,
				decoration: InputDecoration(
					border: InputBorder.none,
					hintText: name,

				),
			)
		);
	}
}
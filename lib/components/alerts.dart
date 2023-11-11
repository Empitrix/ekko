import 'package:flutter/material.dart';

class SNK {
	final BuildContext context;
	SNK(this.context);
	
	void message(Widget icon, String message){
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(
				duration: const Duration(seconds: 1),
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				content: Row(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						icon,
						const SizedBox(width: 12),
						Text(
							message,
							style: TextStyle(
								color: Theme.of(context).colorScheme.inverseSurface
							),
						)
					],
				),
			)
		);
	}
}
import 'package:flutter/material.dart';

class SNK {
	final BuildContext context;
	final Duration duration;
	SNK(this.context, {this.duration = const Duration(seconds: 1)});
	
	void message(Widget icon, String message){
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(
				duration: duration,
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

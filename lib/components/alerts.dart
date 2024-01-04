import 'package:ekko/components/blur/snackbar.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';

class SNK {
	final BuildContext context;
	final Duration duration;
	SNK(this.context, {this.duration = const Duration(seconds: 1)});
	
	void message(Widget icon, String message){
		ScaffoldMessenger.of(context).showSnackBar(
			// SnackBar(
			blurSnakBar(
				context: context,
				duration: duration,
				// backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				content: Row(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						icon,
						const SizedBox(width: 12),
						Text(
							message,
							style: TextStyle(
								color: dMode ? Colors.white : Colors.black
								// color: Theme.of(context).colorScheme.inverseSurface
							),
						)
					],
				),
			),
		);
	}
}

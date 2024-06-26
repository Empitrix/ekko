import 'package:ekko/components/blur/snackbar.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';

class SNK {
	final BuildContext context;
	final Duration duration;

	SNK(this.context, {this.duration = const Duration(seconds: 1)});
	
	void message(Widget icon, String message){
		ScaffoldMessenger.of(context).showSnackBar(
			blurSnakBar(
				context: context,
				duration: duration,
				content: Row(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						icon,
						const SizedBox(width: 12),
						Text(
							message,
							style: TextStyle(
								color: settingModes['dMode'] ? Colors.white : Colors.black
							),
						)
					],
				),
			),
		);
	}
}


import 'package:flutter/material.dart';
import 'dart:ui';


SnackBar blurSnakBar({
	required Duration duration,
	required BuildContext context,
	required Widget content,
	double blurValue = 3.14, 
}){
	return SnackBar(
		// Theme.of(context).colorScheme.inversePrimary
		backgroundColor: Colors.transparent,
		padding: EdgeInsets.zero,
		content: BackdropFilter(
			filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
			child: Container(
				padding: const EdgeInsets.all(12),
				decoration: BoxDecoration(
					// color: Colors.black.withOpacity(0.5)
					// color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3)
					// color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
					color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.5)
				),
				child: content,
				// child: Container()
			),
		)
	);
}


import 'package:flutter/material.dart';

class Dialogs {
	final BuildContext context;
	Dialogs({required this.context});

	/* Show OK dialog */
	void okDialog(String title, content, [String act = "Ok"]){
		showDialog(
			context: context,
			builder: (BuildContext context) => AlertDialog(
				title: Text(title),
				content: Text(content),
				actions: [
					FilledButton(
						child: Text(act),
						onPressed: () => Navigator.pop(context),
					)
				],
			)
		);
	}

}
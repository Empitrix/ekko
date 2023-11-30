import 'package:flutter/material.dart';

class Dialogs {
	final BuildContext context;
	Dialogs(this.context);

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

	void askDialog({
		required String title, content,
		required Function action,
		String fillAct = "Ok",
		String outAct = "Cancel"}){
		showDialog(
			context: context,
			builder: (BuildContext context) => AlertDialog(
				title: Text(title),
				content: Text(content),
				actions: [
					FilledButton(
						child: Text(fillAct),
						onPressed: (){
							Navigator.pop(context);  // Close current bottom
							action();
						},
					),
					OutlinedButton(
						child: Text(outAct),
						onPressed: () => Navigator.pop(context),
					)
				],
			)
		);
	}

}

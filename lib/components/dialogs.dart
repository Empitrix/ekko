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

	void ask({
		required String title,
		required String content,
		required Function action,
		String fillAct = "Ok",
		String outAct = "Cancel"}){
		showDialog(
			context: context,
			builder: (BuildContext context) => AlertDialog(
				title: Text(title),
				content: Text(content),
				actions: [
					OutlinedButton(
						child: Text(outAct),
						onPressed: () => Navigator.pop(context),
					),
					FilledButton(
						child: Text(fillAct),
						onPressed: (){
							Navigator.pop(context);  // Close current bottom
							action();
						},
					),
				],
			)
		);
	}


	void textFieldDialog({
		required String title,
		required String hint,
		required ValueChanged<String> action,
		String fillAct = "Ok",
		String loadedText = "",
		String outAct = "Cancel"}){
		showDialog(
			context: context,
			builder: (BuildContext context){
				TextEditingController ctrl = TextEditingController();
				ctrl.text = loadedText;
				return AlertDialog(
					title: Text(title),
					content: TextField(
						controller: ctrl,
						autofocus: true,
						onSubmitted: (txt){
							Navigator.pop(context);
							action(txt);
						},
						decoration: InputDecoration(
							hintText: hint
						),
					),
					actions: [
						OutlinedButton(
							child: Text(outAct),
							onPressed: () => Navigator.pop(context),
						),
						FilledButton(
							child: Text(fillAct),
							onPressed: (){
								Navigator.pop(context);  // Close current bottom
								action(ctrl.text);
							},
						),
					],
				);
			}
		);
	}  // textFieldDialog


}


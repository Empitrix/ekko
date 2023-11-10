import 'package:ekko/components/fields.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';


class ModifyPage extends StatefulWidget {
	final Note? note;
	const ModifyPage({super.key, this.note});

	@override
	State<ModifyPage> createState() => ModifyPageState();
}

class ModifyPageState extends State<ModifyPage> {
	
	TextEditingController title = TextEditingController();
	FocusNode titleF = FocusNode();
	TextEditingController description = TextEditingController();
	FocusNode descriptionF = FocusNode();
	TextEditingController content = TextEditingController();
	FocusNode contentF = FocusNode();
	bool isPinned = false;
	NoteMode mode = NoteMode.copy;

	void submit(){ debugPrint("Called For Submit"); }


	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				changeView(context, const HomePage());
				return false;
			},
			child: Scaffold(
				appBar: AppBar(
					title: const Text("Modify"),
					leading: IconButton(
						icon: const Icon(Icons.arrow_back),
						onPressed: () => changeView(context, const HomePage()),
					),
					actions: [
						Container(
							height: double.infinity,
							margin: const EdgeInsets.all(8),
							child: TextButton(
								style: ButtonStyle(
									shape: MaterialStatePropertyAll(
										RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(5)))
								),
								child: const Text("Submit"),
								onPressed: () => submit(),
							),
						)
					],
				),
				body: ListView(
					padding: const EdgeInsets.all(12),
					children: [
						ModifyField(
							controller: title,
							name: "Title"
						),

					],
				),
			),
		);
	}
}
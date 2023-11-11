import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/fields.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';


class ModifyPage extends StatefulWidget {
	final Note? note;
	final Function? backLoad;
	const ModifyPage({super.key, this.note, this.backLoad});

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


	void _backClose(){
		if(widget.backLoad != null){
			widget.backLoad!();
		}
		changeView(context, const HomePage(), isPush: false);
	}


	Future<void> submit() async {
		DB db = DB();
		SNK snk = SNK(context);

		// Make sure that all the filed are fulled
		if(!TxtCtrl.isAllFilled(title, description, content)){
			debugPrint("Fill all the forms!");
			snk.message(
				const Icon(Icons.close), "Fill all the forms");
			return;
		}

		Note note = Note(
			id: widget.note == null ? -1 : widget.note!.id,
			title: title.text,
			description: description.text,
			content: content.text,
			lastEdit: DateTime.now(),
			isPinned: isPinned,
			mode: mode
		);

		if(widget.note == null){
			// Add
			await db.addNote(note);
			// snk.message(icon, message);
		} else {
			// Edit
			await db.updateNote(widget.note!, note);
			// snk.message(icon, message);
		}

		if(mounted) _backClose();

	}


	@override
	void initState() {
		if(widget.note != null){
			// Update fileds
			title.text = widget.note!.title;
			description.text = widget.note!.description;
			content.text = widget.note!.content;
			mode = widget.note!.mode;
			isPinned = widget.note!.isPinned;
		}  // EDIT
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				_backClose();
				return false;
			},
			child: Scaffold(
				appBar: AppBar(
					title: const Text("Modify"),
					leading: IconButton(
						icon: const Icon(Icons.arrow_back),
						onPressed: () => _backClose(),
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

						TitleTextField(
							controller: title,
							focusNode: titleF,
							nextFocus: () => descriptionF.requestFocus(),
						),
						DescriptionTextFiled(
							controller: description,
							focusNode: descriptionF,
							previousFocus: () => titleF.requestFocus(),
							nextFocus: () => contentF.requestFocus()
						),
						ContentTextFiled(
							controller: content,
							focusNode: contentF,
							previousFocus: () => descriptionF.requestFocus()
						)
					],
				),
			),
		);
	}
}

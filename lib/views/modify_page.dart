import 'package:regex_pattern_text_field/controllers/regex_pattern_text_editing_controller.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/fields.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/io/md_file.dart';
import 'package:ekko/models/file_out.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';

class ModifyPage extends StatefulWidget {
	final SmallNote? note;
	final int folderId;
	final Function? backLoad;
	final Widget previousPage;
	final String previousPageName;
	const ModifyPage({
		super.key,
		this.note,
		this.folderId = 0,
		this.backLoad,
		required this.previousPage,
		required this.previousPageName,
	});

	@override
	State<ModifyPage> createState() => ModifyPageState();
}

class ModifyPageState extends State<ModifyPage> {
	
	TextEditingController title = TextEditingController();
	FocusNode titleF = FocusNode();
	TextEditingController description = TextEditingController();
	FocusNode descriptionF = FocusNode();
	// TextEditingController? content;
	RegexPatternTextEditingController content = RegexPatternTextEditingController();
	FocusNode contentF = FocusNode();
	bool isPinned = false;
	NoteMode mode = NoteMode.copy;
	// bool isLoaded = true;  // For imported notes
	bool isLoaded = false;  // For imported notes


	void _backClose({bool isNew = false, bool force = false}){
		if(widget.backLoad != null && isNew){
			widget.backLoad!();
		}
		
		if(force){
			changeView(context, widget.previousPage, "", isPush: false);
			return;  // Close the function
		}
		
		if(!TxtCtrl(title, description, content).isAllEmpty()){
			// check if anything has been changed
			// if(<something changed>){
			// 	<ask!, if granted then quit>
			// } else { <quit> }
			Dialogs(context).ask(
				title: "Exit",
				content: widget.note == null ?
					"If you exit, all the fields will be cleared!":
					"Are sure that you want to exit?",
				action: (){
					changeView(context, widget.previousPage, widget.previousPageName, isPush: false);
				}
			);
		} else {
			changeView(context, widget.previousPage, widget.previousPageName, isPush: false);
		}
	}


	Future<void> submit() async {
		DB db = DB();
		SNK snk = SNK(context);

		// Make sure that all the filed are fulled
		if(!TxtCtrl(title, description, content).isAllFilled()){
			debugPrint("Fill all the forms!");
			snk.message(
				const Icon(Icons.close), "Fill all the forms");
			return;
		}

		Note note = Note(
			id: widget.note == null ? -1 : widget.note!.id,
			folderId: widget.folderId,
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
			await db.updateNote(note);
			// snk.message(icon, message);
		}

		if(mounted) _backClose(isNew: true, force: true);
	}


	Future<void> loadTheNote() async {
		setState(() { isLoaded = false; });

		if(widget.note == null){
			setState(() { isLoaded = true; });
			return;
		}

		Note note = await widget.note!.toRealNote();
		
		title.text = note.title;
		description.text = note.description;
		content.text = note.content;
		mode = note.mode;
		isPinned = note.isPinned;
		
		if(note.content.length > waitForLoading){
			await Future.delayed(Duration(
				milliseconds: waitLoadingSize));
			setState(() { isLoaded = true; });
		} else {
			setState(() { isLoaded = true; });
		}
	}


	Future<void> _updateFiledWithOutterFile() async {
		FileContentOut? fileData = await MDFile.read();
		if(fileData == null) { return; }
		content.text = fileData.content;
		title.text = fileData.name;
		// Set focus to descript filed becasue it's not filled
		descriptionF.requestFocus();
	}

	@override
	void initState() {
		loadTheNote();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: (bool didPop) async {
				if(didPop) { return; }
				_backClose();
			},
			child: Scaffold(
				resizeToAvoidBottomInset: false,
				appBar: AppBar(
					title: const Text("Modify"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: () => _backClose(),
					),
					actions: [
						Container(
							margin: const EdgeInsets.all(5),
							child: IconButton(
								tooltip: "Import",
								// icon: const Icon(Icons.import_contacts),
								icon: const Icon(Icons.input, size: 20),
								onPressed: () async {
									if(!TxtCtrl(title, description, content).isAllEmpty()){
										Dialogs(context).ask(
											title: "Replace",
											content: "Did you want to replace all?",
											action: () async {
												await _updateFiledWithOutterFile();
											}
										);
									} else {
										await _updateFiledWithOutterFile();
									}
								}
							),
						),
						// Should be the last Container
						// SizedBox(
						// 	height: double.infinity,
						// 	child: CustomModifyButton(
						// 		label: const Text("Submit"),
						// 		icon: const Icon(Icons.check),
						// 		onPressed: () => submit(),
						// 	),
						// ),
						Container(
							margin: const EdgeInsets.all(5),
							child: IconButton(
								tooltip: "Submit",
								icon: Icon(
									Icons.check,
									color: Theme.of(context).colorScheme.primary,
								),
								onPressed: () => submit(),
							),
						),
					],
				),
				body: Builder(
					builder: (BuildContext context){
						// Loading
						if(!isLoaded){
							return const Center(
								child: CircularProgressIndicator());}

						// Widgets
						return ListView(
							padding: const EdgeInsets.all(12),
							children: [
								TitleTextField(
									controller: title,
									focusNode: titleF,
									autofocus: widget.note == null,
									nextFocus: () => descriptionF.requestFocus(),
								),
								// const SizedBox(height: 20),
								DescriptionTextFiled(
									controller: description,
									focusNode: descriptionF,
									previousFocus: () => titleF.requestFocus(),
									nextFocus: () => contentF.requestFocus()
								),
								const SizedBox(height: 20),
								ContentTextFiled(
									controller: content,
									focusNode: contentF,
									previousFocus: () => descriptionF.requestFocus()
								)
							],
						);
					}
				)
			),
		);
	}
}

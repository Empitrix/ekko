import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/custom_buttons.dart';
import 'package:ekko/components/fields.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
import 'package:regex_pattern_text_field/controllers/regex_pattern_text_editing_controller.dart';

class ModifyPage extends StatefulWidget {
	final SmallNote? note;
	final Function? backLoad;
	final Widget previousPage;
	const ModifyPage({
		super.key,
		this.note,
		this.backLoad,
		required this.previousPage
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


	void _backClose({bool isNew = false}){
		if(widget.backLoad != null && isNew){
			widget.backLoad!();
		}
		// changeView(context, const HomePage(), isPush: false);
		changeView(context, widget.previousPage, isPush: false);
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
			await db.updateNote(note);
			// snk.message(icon, message);
		}

		if(mounted) _backClose(isNew: true);

	}

	/*Future<void> loadTheNote() async {
		setState(() { isLoaded = false; });
		ReceivePort getPort = (await loadModifyWithIsolates(note: widget.note!));
		getPort.listen((note) async {
			if(note is Note){
				// Update fields
				title.text = note.title;
				description.text = note.description;
				content.text = note.content;
				mode = note.mode;
				isPinned = note.isPinned;
				/*
					Waiting if content length is too long!
					for performance, and wait for animations
					to complete!
				*/
				if(note.content.length > 420){
					await Future.delayed(const Duration(seconds: 1)).then((value){
						setState(() { isLoaded = true; });
						getPort.close();
					});
				} else {
					setState(() { isLoaded = true; });
					getPort.close();
				}
			}
		});
	}*/


	Future<void> loadTheNote() async {
		setState(() { isLoaded = false; });
		
		// await Future.microtask((){
		// 	content = getContentTextEditingController(context);
		// });

		if(widget.note == null){
			setState(() { isLoaded = true; });
			return;
		}

		Note note = await widget.note!.toRealNote();
		
		title.text = note.title;
		description.text = note.description;
		content!.text = note.content;
		mode = note.mode;
		isPinned = note.isPinned;
		
		if(note.content.length > waitForLoading){
			await Future.delayed(Duration(
				milliseconds: waitLoadingSize));
			setState(() { isLoaded = true; });
		} else {
			setState(() { isLoaded = true; });
		}

		/*!
		ReceivePort getPort = (await loadModifyWithIsolates(note: widget.note!));
		getPort.listen((note) async {
			if(note is Note){
				// Update fields
				if(note.content.length > 420){
					await Future.delayed(const Duration(seconds: 1)).then((value){
						setState(() { isLoaded = true; });
						getPort.close();
					});
				} else {
					setState(() { isLoaded = true; });
					getPort.close();
				}
			}
		});
		*/
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
						SizedBox(
							height: double.infinity,
							child: CustomModifyButton(
								label: const Text("Submit"),
								icon: const Icon(Icons.check),
								onPressed: () => submit(),
							),
						)
					],
				),
				body: Builder(
					builder: (BuildContext context){

						if(!isLoaded){
							return const Center(
								child: CircularProgressIndicator(),
							);
						}

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
									controller: content!,
									focusNode: contentF,
									previousFocus: () => descriptionF.requestFocus()
								)
							],
						);

					}
				)
			// 	body: isLoaded ? ListView(
			// 		padding: const EdgeInsets.all(12),
			// 		children: [
			// 			TitleTextField(
			// 				controller: title,
			// 				focusNode: titleF,
			// 				autofocus: widget.note == null,
			// 				nextFocus: () => descriptionF.requestFocus(),
			// 			),
			// 			// const SizedBox(height: 20),
			// 			DescriptionTextFiled(
			// 				controller: description,
			// 				focusNode: descriptionF,
			// 				previousFocus: () => titleF.requestFocus(),
			// 				nextFocus: () => contentF.requestFocus()
			// 			),
			// 			const SizedBox(height: 20),
			// 			ContentTextFiled(
			// 				controller: content!,
			// 				focusNode: contentF,
			// 				previousFocus: () => descriptionF.requestFocus()
			// 			)
			// 		],
			// 	) : const Center(
			// 		child: CircularProgressIndicator(),
			// 	)
			),
		);
	}
}

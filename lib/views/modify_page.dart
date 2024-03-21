import 'package:ekko/animation/expand.dart';
import 'package:ekko/components/editor/buffer.dart';
import 'package:ekko/components/shortcut/intents.dart';
import 'package:ekko/components/shortcut/scaffold.dart';
import 'package:flutter/services.dart';
import 'package:awesome_text_field/awesome_text_field.dart';
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
import 'dart:async';



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

class ModifyPageState extends State<ModifyPage> with TickerProviderStateMixin{

	TextEditingController title = TextEditingController();
	FocusNode titleF = FocusNode();
	TextEditingController description = TextEditingController();
	FocusNode descriptionF = FocusNode();
	AwesomeController content = AwesomeController();
	ValueNotifier<List<String>> tags = ValueNotifier([]);
	ValueNotifier<LineStatus> lineStatus = ValueNotifier(
		LineStatus(lineNumber: 0, lineHeight: 20, currentLine: 0, currentCol: 0));
	FocusNode contentF = FocusNode();
	bool isPinned = false;
	NoteMode mode = NoteMode.copy;
	bool isLoaded = false;  // For imported notes

	bool oneTime = true;

	late GenAnimation headerAnim;

	GlobalKey headerKey = GlobalKey();
	GlobalKey appbarKey = GlobalKey();


	void _backClose({bool isNew = false, bool force = false}){
		if(widget.backLoad != null && isNew){
			widget.backLoad!();
		}
		
		if(force){
			changeView(context, widget.previousPage, widget.previousPageName, isPush: false);
			return;  // Close the function
		}

		// TODO: CHECK FOR TAGS LIST && ADD DON'T SHOW CHECK DIALOG
		if(!TxtCtrl(title, null, content).isAllEmpty()){
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
		if(!TxtCtrl(title, null, content).isAllFilled()){
			debugPrint("Fill all the forms!");
			snk.message(const Icon(Icons.close), "Fill all the forms");
			return;
		}

		String extractedTags = "";
		for(String tag in tags.value){
			extractedTags += "${tag.trim()} ";
		}

		Note note = Note(
			id: widget.note == null ? -1 : widget.note!.id,
			folderId: widget.folderId,
			title: title.text,
			description: extractedTags,
			content: "${content.text.replaceAll("\r\n", "\n").replaceAll("\n\r", "\n").trim()}\n",
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

	void initializeAnimations(){
		headerAnim = generateLinearAnimation(
			ticket: this, initialValue: 1, durations: [200]);
	}

	void initializeListiners(){
		contentF.addListener(() async {
			if(contentF.hasFocus){
				headerAnim.controller.reverse();
				// headerAnim.controller.reverse().then((_) => setState(() {}));
				// setState(() {});
			} else {
				headerAnim.controller.forward();
				// headerAnim.controller.forward().then((_) => setState(() {}));
				// setState(() {});
			}
		});
	}


	Future<List<double>> calcWidgetSize(double animValue) async {
		double wh = 0.0;
		double hH = 0.0;
		Completer<List<double>> onFetchCompleter = Completer<List<double>>();
		// WidgetsBinding.instance.addPostFrameCallback((_) async {
		await Future.microtask((){
			if(appbarKey.currentContext != null && headerKey.currentContext != null){
				// bool headerEnabled = headerAnim.animation.value == 1;
				// double headerHeight = animValue * (headerKey.currentContext!.findRenderObject() as RenderBox).size.height;
				double headerHeight = (headerKey.currentContext!.findRenderObject() as RenderBox).size.height;
				double appbarHeight = (appbarKey.currentContext!.findRenderObject() as RenderBox).size.height;
				double bufferHeight = 20.0;
				double platformHeight = isDesktop() ? 0 : 2;

				// if(!headerEnabled){ headerHeight = 0; }

				wh = (headerHeight + appbarHeight + bufferHeight) + platformHeight;
				// ignore: use_build_context_synchronously
				wh = MediaQuery.of(context).size.height - wh;
				wh = wh - MediaQuery.of(context).viewInsets.bottom;

				wh = wh - 33;
				hH = headerHeight;
			}
		});
		onFetchCompleter.complete([wh, hH]);
		return onFetchCompleter.future;
	}

	@override
	void initState() {
		loadTheNote();
		initializeAnimations();
		initializeListiners();
		titleF.requestFocus();  // Auto request for ttiel (prime field)
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
			// child: Scaffold(
			child: ShortcutScaffold(
				focusNode: screenShortcutFocus["ModifyPage"],
				autofocus: true,
				resizeToAvoidBottomInset: false,
				shortcuts: const <ShortcutActivator, Intent>{
					SingleActivator(LogicalKeyboardKey.keyS, control: true): SubmitNoteIntent(),
				},
				actions: <Type, Action<Intent>>{
					SubmitNoteIntent: CallbackAction<SubmitNoteIntent>(
						onInvoke: (SubmitNoteIntent intent) => submit()
					)
				},
				appBar: AppBar(
					key: appbarKey,
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
						Container(
							margin: const EdgeInsets.only(
								left: 5, top: 5, bottom: 5, right: 12
							),
							child: IconButton(
								tooltip: "Submit",
								icon: Icon(
									Icons.check,
									color: dMode ?
										Colors.pink:
										Colors.amber,
								),
								style: ButtonStyle(side: MaterialStatePropertyAll(BorderSide(
										width: 1,
										color: dMode ?
											Colors.pink:
											Colors.amber
									))),
								onPressed: () => submit(),
							),
						),
					],
				),
				body: Builder(
					builder: (BuildContext context){
						// Loading
						if(!isLoaded){return const Center(child: CircularProgressIndicator());}
						// Widgets
						Widget header = Padding(
							key: headerKey,
							padding: const EdgeInsets.all(12),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									TitleTextField(
										controller: title,
										focusNode: titleF,
										autofocus: widget.note == null,
										nextFocus: () => descriptionF.requestFocus(),
									),
									DescriptionTextFiled(
										controller: description,
										tags: tags,
										focusNode: descriptionF,
										previousFocus: () => titleF.requestFocus(),
										nextFocus: () => contentF.requestFocus()
									),
								],
							),
						);
						/*
						Widget header = ListView(
							padding: EdgeInsets.zero,
							children: [
								Padding(
									padding: const EdgeInsets.all(12),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											TitleTextField(
												controller: title,
												focusNode: titleF,
												autofocus: widget.note == null,
												nextFocus: () => descriptionF.requestFocus(),
											),
											DescriptionTextFiled(
												controller: description,
												tags: tags,
												focusNode: descriptionF,
												previousFocus: () => titleF.requestFocus(),
												nextFocus: () => contentF.requestFocus()
											),
										],
									),
								),
								// const SizedBox(height: 20),
								// ContentTextFiled(
								// 	controller: content,
								// 	focusNode: contentF,
								// 	previousFocus: () => descriptionF.requestFocus()
								// )
							],
						);
						*/


						/*
						Column columnWidget = Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							mainAxisAlignment: MainAxisAlignment.start,
							children: [
								expandAnimation(
									animation: headerAnim.animation,
									mode: ExpandMode.height,
									body: header
								),
								// const Row(
								// 	mainAxisAlignment: MainAxisAlignment.end,
								// 	children: [
								// 		Icon(Icons.open_with)
								// 	],
								// ),

								AnimatedBuilder(
									animation: headerAnim.animation,
									builder: (BuildContext context, Widget? child){
										// Calculate current widget height
										double cwh = ((MediaQuery.sizeOf(context).height - (235 - 8)) - (isDesktop() ? 2 : 14));
										cwh = cwh - (MediaQuery.of(context).viewInsets.bottom);
										double currentLost = ((headerAnim.animation.value - 1) * (128 - 8));
										cwh = cwh - (currentLost) -
											(currentLost == 0 ? 0 : !isDesktop() ? -12 : 0);

										return ContentTextFiled(
											controller: content,
											focusNode: contentF,
											widgetHeight: cwh,
											lineChanged: (LineStatus status){
												Future.microtask((){
													lineStatus.value = status;
												});
											},
											previousFocus: () => descriptionF.requestFocus()
										);
									}
								),

								ValueListenableBuilder(
									valueListenable: lineStatus,
									builder: (_, status, __){
										return EditorBuffer(
											controller: content,
											lineStatus: status,
											note: widget.note,
											folderId: widget.folderId,
										);
									}
								)

							],
						);
						*/


						return AnimatedBuilder(
							animation: headerAnim.animation,
							builder: (BuildContext context, Widget? child){
								return FutureBuilder(
									future: calcWidgetSize(headerAnim.animation.value),
									builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
										if(snapshot.hasData && snapshot.data!.first == 0){
											WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
										}

										if(snapshot.hasData){
											return Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												mainAxisAlignment: MainAxisAlignment.start,
												children: [
													expandAnimation(
														animation: headerAnim.animation,
														mode: ExpandMode.height,
														body: header
													),

													AnimatedBuilder(
														animation: headerAnim.animation,
														builder: (BuildContext context, Widget? child){
															/*
															// Calculate current widget height
															double cwh = ((MediaQuery.sizeOf(context).height - (235 - 8)) - (isDesktop() ? 2 : 14));
															cwh = cwh - (MediaQuery.of(context).viewInsets.bottom);
															double currentLost = ((headerAnim.animation.value - 1) * (128 - 8));
															cwh = cwh - (currentLost) -
																(currentLost == 0 ? 0 : !isDesktop() ? -12 : 0);
															*/

															return ContentTextFiled(
																controller: content,
																focusNode: contentF,
																// widgetHeight: snapshot.data![0] - (headerAnim.animation.value * snapshot.data![1] / 100),
																widgetHeight: snapshot.data![0] + ((1 - headerAnim.animation.value) * snapshot.data![1]),
																lineChanged: (LineStatus status){
																	Future.microtask((){
																		lineStatus.value = status;
																	});
																},
																previousFocus: () => descriptionF.requestFocus()
															);
														}
													),
													ValueListenableBuilder(
														valueListenable: lineStatus,
														builder: (_, status, __){
															return EditorBuffer(
																controller: content,
																lineStatus: status,
																note: widget.note,
																folderId: widget.folderId,
															);
														}
													)
												],
											);
										}

										return const SizedBox();
									}
								);


							},
						);



					}
				)
			),
		);
	}
}

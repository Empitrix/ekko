import 'package:ekko/animation/expand.dart';
import 'package:ekko/animation/floating_button.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/in_loading_page.dart';
import 'package:ekko/components/nested.dart';
import 'package:ekko/components/shortcut/intents.dart';
import 'package:ekko/components/shortcut/scaffold.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/generator.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/plain/renderer.dart';
import 'package:ekko/views/land_page.dart';
import 'package:ekko/views/modify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DisplayPage extends StatefulWidget {
	final SmallNote smallNote;
	final Widget previousPage;
	final String previousPageName;
	final Function loadAll;
	const DisplayPage({
		super.key,
		required this.smallNote,
		required this.previousPage,
		required this.previousPageName,
		required this.loadAll
	});

	@override
	State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> with TickerProviderStateMixin{

	Note? note;
	bool isLoaded = false;

	// Floating Action Button
	ScrollController scrollCtrl = ScrollController();
	GenAnimation? floatingButtonAnim;
	FocusNode contextFocus = FocusNode();
	TextSelectionControls? selectionControl;
	TextEditingController searchCtrl = TextEditingController();
	ValueNotifier<String> searchNotif = ValueNotifier<String>("");

	NestedSearchObj searchObj = NestedSearchObj(keys: [], current: 0);



	void _backToPreviousPage(){
		widget.loadAll();
		changeView(context, const LandPage(), "LandPage",  isPush: false);
	}

	void initAnimations(){
		floatingButtonAnim = generateLinearAnimation(
			ticket: this, initialValue: 1, durations: [1000]);
	}

	Future<void> loadAll([int? id]) async {
		id ??= widget.smallNote.id;
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			setState(() => isLoaded = false);
			// note = await widget.smallNote.toRealNote();
			note = await DB().loadThisNote(id!);
			if(note!.content.length > waitForLoading){
				await Future.delayed(Duration(
					milliseconds: waitLoadingSize));
			}
			setState(() => isLoaded = true);
		});
	}

	void _goToModifyPage(){
		changeView(
			context, ModifyPage(
				note: widget.smallNote,
				folderId: widget.smallNote.folderId,
				backLoad: (){loadAll();},
				previousPage: widget,
				previousPageName: "DisplayPage",
				// previousPage: widget.previousPage,
				// previousPageName: widget.previousPageName,
			),
			"ModifyPage"
		);
	}


	void moveTo(GlobalKey? k) async {
		if(k != null){
			await Scrollable.ensureVisible(
				k.currentContext!,
				duration: const Duration(milliseconds: 200)
			);
		}
	}

	@override
	void initState() {
		// Load async
		initAnimations();
		loadAll();
		contextFocus.requestFocus();
		selectionControl = getSelectionControl();
		super.initState();
	}

	@override
	void dispose() {
		// Dispose animations/tickes
		if(floatingButtonAnim != null){
			floatingButtonAnim!.controller.dispose();
		}
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: (bool didPop) async {
				if(didPop){ return; }
				debugPrint("Did-Pop: $didPop");
				_backToPreviousPage();
			},
			child: Container(
				color: Theme.of(context).appBarTheme.backgroundColor,
				child: SafeArea(
					// child: Scaffold(
					// GoToEditPageIntent
					child: ShortcutScaffold(
						focusNode: screenShortcutFocus["DisplayPage"],
						shortcuts: const <ShortcutActivator, Intent>{
							SingleActivator(LogicalKeyboardKey.keyE, control: true): GoToEditPageIntent(),
							SingleActivator(LogicalKeyboardKey.escape): ClosePageIntent(),
						},
						// contextFocus
						actions: <Type, Action<Intent>>{
							GoToEditPageIntent: CallbackAction<GoToEditPageIntent>(
								onInvoke: (GoToEditPageIntent intent) => {
									_goToModifyPage()
								}),
							ClosePageIntent: CallbackAction<ClosePageIntent>(
								onInvoke: (ClosePageIntent intent) => {
									_backToPreviousPage()
								}),
						},
						floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
						floatingActionButton: AnimatedFloatingButton(
							controller: scrollCtrl,
							animation: floatingButtonAnim!,
							child: const Icon(Icons.edit),
							onPressed: () => _goToModifyPage(),
						),
						body: Builder(
							builder:(context){
								if(!isLoaded){ return const InLoadingPage(); }
								contextFocus.requestFocus(); // Update Foucs

								return NestedList(
									controller: scrollCtrl,
									note: note!,
									searchObj: searchObj,
									onNext: (){
										moveTo(searchObj.next());
									},
									onPrevius: (){
										moveTo(searchObj.previus());
									},
									onChanged: (_){
										moveTo(searchObj.first());
									},
									searchController: searchCtrl,
									searchNotifier: searchNotif,
									contextFocus: contextFocus,
									onClose: _backToPreviousPage,
									selectionControls: selectionControl!,

									child: note!.mode == NoteMode.plaintext ? ListenableBuilder(
										// valueListenable: searchNotif,
										listenable: searchObj,
										builder: (context, child){
											WidgetsBinding.instance.addPostFrameCallback((_){
												searchObj.clear();
											});
											return ValueListenableBuilder(
												// listenable: searchObj,
												valueListenable: searchNotif,
												builder: (context, value, child){
													return PlainRenderer(
														content: note!.content,
														onMatchAdd: (GlobalKey k){
															WidgetsBinding.instance.addPostFrameCallback((_){
																searchObj.addKey(k);
															});
														},
														search: value,
														index: searchObj.current
													);
												}
											);
											// return PlainRenderer(
											// 	content: note!.content,
											// 	onMatchAdd: (GlobalKey k){
											// 		WidgetsBinding.instance.addPostFrameCallback((_){
											// 			searchObj.addKey(k);
											// 		});
											// 	},
											// 	search: value,
											// 	index: searchObj.current
											// );
										}
									): MDGenerator(
										content: note!.content,
										noteId: note!.id,
										hotRefresh: () async {
											note!.content = (await DB().loadThisNote(note!.id)).content;
											setState(() {});
										},
									)
								);
								
								/*
								return NestedScrollView(
									controller: scrollCtrl,
									floatHeaderSlivers: true,
									physics: const ScrollPhysics(),
									headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
										return <Widget>[
											SliverAppBar(
												floating: false,
												pinned: Platform.isLinux,
												primary: false,
												title: Column(
													mainAxisAlignment: MainAxisAlignment.start,
													crossAxisAlignment: CrossAxisAlignment.start,
													children: note!.mode == NoteMode.plaintext ? [
														TextField(
															style: const TextStyle(fontSize: 18),
															decoration: InputDecoration(
																hintText: "Search",
																hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
																border: InputBorder.none
															),
														),
													] : [
														Text(
															note!.title,
															overflow: TextOverflow.fade,
															style: Theme.of(context).appBarTheme.titleTextStyle
														),
														Text(
															differenceFromNow(note!.lastEdit),
															style: TextStyle(
																fontSize: 14,
																overflow: TextOverflow.fade,
																color: settingModes['dMode'] ? Colors.grey : Colors.grey[400]
															)
														)
													],
												),
												actions: [
													Container(
														margin: const EdgeInsets.all(5),
														child: IconButton(
															icon: const Icon(Icons.more_vert),
															onPressed: (){
																inViewNoteSheet(
																	context: context,
																	note: note!
																);
															}
														),
													)
												],
												forceElevated: false,
												leading: IconButton(
													icon: const Icon(Icons.close),
													onPressed: _backToPreviousPage,
												),
											),
										];
									},
									body: SelectionArea(
										focusNode: contextFocus,
										selectionControls: selectionControl!,
										contextMenuBuilder: (context, editableTextState) => AdaptiveTextSelectionToolbar.buttonItems(
											anchors: editableTextState.contextMenuAnchors,
											buttonItems: editableTextState.contextMenuButtonItems,
										),
										child: ListView(
											padding: const EdgeInsets.only(
												right: 12, left: 12,
												top: 12, bottom: 85
											),
											children: [
												const SizedBox(height: 10),
												MDGenerator(
													content: note!.content,
													noteId: note!.id,
													hotRefresh: () async {
														note!.content = (await DB().loadThisNote(note!.id)).content;
														setState(() {});
													},
												)
											],
										),
									)
								);
								*/
							}
						),
					)
				)
			)
		);
	}
}


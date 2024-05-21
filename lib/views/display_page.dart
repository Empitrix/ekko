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
	ScrollController listController = ScrollController();
	GenAnimation? floatingButtonAnim;
	FocusNode contextFocus = FocusNode();
	TextSelectionControls? selectionControl;
	TextEditingController searchCtrl = TextEditingController();
	ValueNotifier<String> searchNotif = ValueNotifier<String>("");
	NestedSearchObj searchObj = NestedSearchObj(keys: [], current: 0);

	final GlobalKey<NestedScrollViewState> nestedKey = GlobalKey();



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
				duration: const Duration(milliseconds: 500)
				// duration: Duration.zero
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
					child: ShortcutScaffold(
						focusNode: screenShortcutFocus["DisplayPage"],
						shortcuts: const <ShortcutActivator, Intent>{
							SingleActivator(LogicalKeyboardKey.keyE, control: true): GoToEditPageIntent(),
							SingleActivator(LogicalKeyboardKey.arrowDown): MoveDownIntent(),
							SingleActivator(LogicalKeyboardKey.arrowUp): MoveUpIntent(),
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
							MoveDownIntent: CallbackAction<MoveDownIntent>(
								onInvoke: (MoveDownIntent intent) => {
									nestedKey.currentState!.innerController.animateTo(
										nestedKey.currentState!.innerController.offset + 170,
										duration: const Duration(milliseconds: 100),
										curve: Curves.ease)
								}
							),
							MoveUpIntent: CallbackAction<MoveUpIntent>(
								onInvoke: (MoveUpIntent intent) => {
									nestedKey.currentState!.innerController.animateTo(
										nestedKey.currentState!.innerController.offset - 170,
										duration: const Duration(milliseconds: 100),
										curve: Curves.ease)
								}
							),
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
									nestedKey: nestedKey,
									listController: listController,
									controller: scrollCtrl,
									note: note!,
									searchObj: searchObj,
									onNext: () => moveTo(searchObj.next()),
									onPrevius: () => moveTo(searchObj.previus()),
									onChanged: (_) => moveTo(searchObj.first()),
									searchController: searchCtrl,
									searchNotifier: searchNotif,
									contextFocus: contextFocus,
									onClose: _backToPreviousPage,
									selectionControls: selectionControl!,
									child: note!.mode == NoteMode.plaintext ? ListenableBuilder(
										listenable: searchObj,
										builder: (context, child){
											WidgetsBinding.instance.addPostFrameCallback((_){
												searchObj.clear();
											});
											return ValueListenableBuilder(
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
							}
						),
					)
				)
			)
		);
	}
}


import 'package:ekko/animation/expand.dart';
import 'package:ekko/animation/floating_button.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/generator.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/land_page.dart';
import 'package:ekko/views/modify_page.dart';
import 'package:flutter/material.dart';

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

	@override
	void initState() {
		// Load async
		initAnimations();
		loadAll();
		contextFocus.requestFocus();
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
					child:Scaffold(
						floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
						floatingActionButton: AnimatedFloatingButton(
							controller: scrollCtrl,
							animation: floatingButtonAnim!,
							child: const Icon(Icons.edit),
							onPressed: () => changeView(
								context, ModifyPage(
									note: widget.smallNote,
									folderId: widget.smallNote.folderId,
									backLoad: (){loadAll();},
									previousPage: widget,
									previousPageName: "DisplayPage",
								),
								"ModifyPage"
							),
						),
						body: Builder(
							builder:(context){

								if(!isLoaded){
									return const Center(child: CircularProgressIndicator());
								}

								return NestedScrollView(
									controller: scrollCtrl,
									floatHeaderSlivers: true,
									physics: const ScrollPhysics(),
									headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
										return <Widget>[
											SliverAppBar(
												floating: false,
												pinned: false,
												// title: const Text("Display"),
												title: Column(
													mainAxisAlignment: MainAxisAlignment.start,
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Text(
															note!.title,
															overflow: TextOverflow.fade,
															style: Theme.of(context).appBarTheme.titleTextStyle
														),
														Text(note!.description, style: TextStyle(
															fontSize: 16,
															overflow: TextOverflow.fade,
															color: dMode ? Colors.grey : Colors.grey[400]
														))
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
													onPressed: (){
														_backToPreviousPage();
													},
												),
											)
										];
									},
									body: SelectionArea(
										focusNode: contextFocus,
										contextMenuBuilder: (context, editableTextState){
											final List<ContextMenuButtonItem> buttonItems = editableTextState.contextMenuButtonItems;
											return AdaptiveTextSelectionToolbar.buttonItems(
												anchors: editableTextState.contextMenuAnchors,
												buttonItems: buttonItems,
											);
										},
										child: ListView(
											padding: const EdgeInsets.only(
												right: 12, left: 12,
												top: 12, bottom: 85  // :)
											),
											children: [
												const SizedBox(height: 10),
												MDGenerator(content: note!.content)
											],
										),
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


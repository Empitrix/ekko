import 'package:ekko/animation/expand.dart';
import 'package:ekko/animation/floating_button.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/note_item.dart';
import 'package:ekko/components/search_bar.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/utils/loading.dart';
import 'package:ekko/views/drawer_page.dart';
import 'package:ekko/views/modify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LandPage extends StatefulWidget {
	final int folderId;
	const LandPage({super.key, this.folderId = 0});

	@override State<LandPage> createState() => _LandPageState();
}

class _LandPageState extends State<LandPage> with TickerProviderStateMixin{

	final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
	final GlobalKey notesKey = GlobalKey();
	String titleName = "Notes";
	DB db = DB();

	ValueNotifier<List<SmallNote>> notes = ValueNotifier<List<SmallNote>>([]);
	ValueNotifier<bool> isLoaded = ValueNotifier<bool>(false);
	TextEditingController searchCtrl = TextEditingController();
	ScrollController scrollCtrl = ScrollController();
	FocusNode searchBarFocus = FocusNode();
	// Animations
	GenAnimation? searchAnim;
	GenAnimation? floatingButtonAnim;

	Future<void> _updateTitle() async {
		String dummyTitle = await db.getFolderName(id: widget.folderId);
		if (mounted) setState(() { titleName = dummyTitle; });
	}

	Future<void> loadAll([bool isNew = true]) async {
		if(isNew) isLoaded.value = false;
		// Update Title
		_updateTitle();
		notes.value = await db.getSmallNotes(folderId: widget.folderId);
		if(notesKey.currentState != null){
			notesKey.currentState!.setState(() {});
		}
		isLoaded.value = true;
		if(!isNew) setState(() {});
	}


	void initAnimations(){
		searchAnim = generateLinearAnimation(
			ticket: this, initialValue: 0);
		floatingButtonAnim = generateLinearAnimation(
			ticket: this, initialValue: 1, durations: [1000]);
	}

	// Inner functions
	void _filterSearch(String words){
		for(int i = 0; i < notes.value.length; i++){
			if(notes.value[i].title.toLowerCase()
				.contains(vStr(words))){
				notes.value[i].isVisible = true;
			} else {
				notes.value[i].isVisible = false;
			}
			// Re-build the visual part
			notesKey.currentState!.setState(() {});
		}
	}

	void _releaseAllNotes(){
		for(int i = 0; i < notes.value.length; i++){
			notes.value[i].isVisible = true;
		}
		if(notesKey.currentState != null){
			notesKey.currentState!.setState(() {});
		}
	}

	bool _isAllSearchHide(){
		for(int i = 0; i < notes.value.length; i++){
			if(notes.value[i].isVisible){
				return false;
			}
		}
		return true;
	}
	
	void _closeSearch(){
		searchCtrl.text = "";
		searchBarFocus.unfocus();
		_releaseAllNotes();
	}

	@override
	void initState() {
		initAnimations();
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			await essentialLoading(context);
			await loadAll();
		});
		super.initState();
	}

	@override
		void dispose() {
			if(searchAnim != null){
				searchAnim!.controller.dispose();
			}
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
				// Close Drawer
				if(scaffoldKey.currentState != null){
					if(scaffoldKey.currentState!.isDrawerOpen){
						scaffoldKey.currentState!.closeDrawer();
					}
				}
				// Close Search-Bar
				if(searchAnim != null){
					if(searchAnim!.animation.value == 1){
						_closeSearch();
						searchAnim!.controller.reverse();
					}
				}
				// Minimize the app
				// T-O-D-O: save current page state (folder-id)
				SystemNavigator.pop(animated: true);
			},
			child: Scaffold(
				resizeToAvoidBottomInset: false,
				key: scaffoldKey,
				// drawer: const DrawerPage(),
				drawer: DrawerPage(closeLoading: _updateTitle, currentFolderId: widget.folderId),
				floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
				floatingActionButton: AnimatedFloatingButton(
					controller: scrollCtrl,
					animation: floatingButtonAnim!,
					child: const Icon(Icons.add_rounded),
					onPressed: () => changeView(
						context, ModifyPage(
							backLoad: (){loadAll(false);},
							previousPage: widget,
							folderId: widget.folderId,
						)
					),
				),
				appBar: customSearchBar(
					context: context,
					
					title: titleName,
					searchAnim: searchAnim!,
					controller: searchCtrl,
					onChange: (String words) => _filterSearch(words),
					focus: searchBarFocus,
					onClose: () => _closeSearch(),
					onOpen: () => searchBarFocus.requestFocus(),
					leading: const Icon(Icons.menu),
					onLoading: (){
						if(scaffoldKey.currentState != null){
							scaffoldKey.currentState!.openDrawer();
						}
					},
				),
				body: ValueListenableBuilder(
					valueListenable: isLoaded,
					builder: (_, load, __) {
						
						// for loading
						if(!load){
							return const Center(
								child: CircularProgressIndicator()
							);
						}
						
						// If there is no notes
						if(notes.value.isEmpty){
							return const Center(
								child: Text("Add Note!"),
							);
						}
						
						// Mian List-View
						return ValueListenableBuilder(
							key: notesKey,
							valueListenable: notes,
							builder: (context, value, child){
								if(value.isEmpty){
									return const Center(child: Text("Add Note"));
								}
								// Check for search result
								if(_isAllSearchHide()){
									return const Center(
										child: Text("Not Found!"),
									);
								}
								return Scrollbar(
									controller: scrollCtrl,
									child: ListView.builder(
										itemCount: value.length,
										controller: scrollCtrl,
										itemBuilder: (context, index){
											return NoteItem(
												note: value[index],
												backLoad: (){loadAll(false);},
											);
										},
									),
								);
							}
						);
					}
				),
			),
		);
	}
}

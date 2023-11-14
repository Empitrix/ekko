import 'package:ekko/animation/expand.dart';
import 'package:ekko/animation/floating_button.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/note_item.dart';
import 'package:ekko/components/search_bar.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/drawer_page.dart';
import 'package:ekko/views/modify_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

	final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
	final GlobalKey notesKey = GlobalKey();

	ValueNotifier<List<SmallNote>> notes = ValueNotifier<List<SmallNote>>([]);
	ValueNotifier<bool> isLoaded = ValueNotifier<bool>(false);
	TextEditingController searchCtrl = TextEditingController();
	ScrollController scrollCtrl = ScrollController();
	// Animations
	GenAnimation? searchAnim;
	GenAnimation? floatingButtonAnim;


	Future<void> loadAll([bool isNew = true]) async {
		if(isNew) isLoaded.value = false;
		notes.value = await DB().getSmallNotes();
		isLoaded.value = true;
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
		notesKey.currentState!.setState(() {});
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
		_releaseAllNotes();
	}

	@override
	void initState() {
		loadAll();
		initAnimations();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				// Close Search-Bar
				if(searchAnim != null){
					if(searchAnim!.animation.value == 1){
						_closeSearch();
						searchAnim!.controller.reverse();
						return false;
					}
				}
				// Close Drawer
				if(scaffoldKey.currentState != null){
					if(scaffoldKey.currentState!.isDrawerOpen){
						scaffoldKey.currentState!.closeDrawer();
						return false;
					}
				}
				// Minimize the app

				return false;
			},
			child: Scaffold(
				resizeToAvoidBottomInset: false,
				key: scaffoldKey,
				drawer: const DrawerPage(),
				floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
				floatingActionButton: AnimatedFloatingButton(
					controller: scrollCtrl,
					animation: floatingButtonAnim!,
					child: const Icon(Icons.add),
					onPressed: () => changeView(
						context, ModifyPage(backLoad: (){loadAll(false);})),
				),
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: CustomSearchBar(
						title: "Notes",
						searchAnim: searchAnim!,
						controller: searchCtrl,
						onChange: (String words) => _filterSearch(words),
						onClose: () => _closeSearch()
					),
					leading: IconButton(
						icon: const Icon(Icons.menu),
						onPressed: (){
							// Open drawer
							if(scaffoldKey.currentState != null){
								scaffoldKey.currentState!.openDrawer();
							}
						},
					),
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
								return ListView.builder(
									itemCount: value.length,
									controller: scrollCtrl,
									itemBuilder: (context, index){
										return NoteItem(
											note: value[index],
											backLoad: (){loadAll(false);},
										);
									},
								);
							}
						);
					}
				),
			),
		);
	}
}

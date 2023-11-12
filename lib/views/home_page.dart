import 'package:ekko/components/note_item.dart';
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

class _HomePageState extends State<HomePage> {

	final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
	ValueNotifier<List<SmallNote>> notes = ValueNotifier<List<SmallNote>>([]);
	ValueNotifier<bool> isLoaded = ValueNotifier<bool>(false);

	Future<void> loadAll([bool isNew = true]) async {
		if(isNew) isLoaded.value = false;
		notes.value = await DB().getSmallNotes();
		isLoaded.value = true;
	}
	
	@override
	void initState() {
		loadAll();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async { return false; },
			child: Scaffold(
				key: scaffoldKey,
				drawer: const DrawerPage(),
				floatingActionButton: FloatingActionButton(
					child: const Icon(Icons.add),
					onPressed: () => changeView(
						context, ModifyPage(backLoad: (){loadAll(false);})),
				),
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("Notes"),
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
							valueListenable: notes,
							builder: (context, value, child){
								if(value.isEmpty){
									return const Center(child: Text("Add Note"));
								}
								return ListView.builder(
									itemCount: value.length,
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

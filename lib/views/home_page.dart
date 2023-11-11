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
	ValueNotifier<List<Note>> notes = ValueNotifier<List<Note>>([]);
	bool isLoaded = false;


	Future<void> loadAll() async {
		setState(() => isLoaded = true);
		notes.value = await DB().getNotes();
		setState(() => isLoaded = true);
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
					onPressed: () => changeView(context, const ModifyPage(), isPush: true),
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
				body: isLoaded ? ValueListenableBuilder(
					valueListenable: notes,
					builder: (context, value, child){
						// if(!isLoaded){
						// 	return const Center(child: CircularProgressIndicator());
						// }
						if(value.isEmpty){
							return const Center(child: Text("Add Note"));
						}
						return ListView.builder(
							itemCount: value.length,
							itemBuilder: (context, index){
								return NoteItem(note: value[index]);
							},
						);
					}
				) : const Center(
					child: CircularProgressIndicator(),
				),
			),
		);
	}
}
import 'package:ekko/components/note_item.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/utils/loading.dart';
import 'package:ekko/views/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	
	final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
	bool isLoaded = false;
	ValueNotifier<List<Note>> notes = ValueNotifier<List<Note>>([]);


	Future<void> init() async {
		setState(() => isLoaded = false);
		// Just for testing
		await updateDbPath();
		await DB().init();
		ThemeMode mode = await DB().readTheme();
		bool aMode = await DB().readAcrylicMode();
		setState(() => dMode = mode == ThemeMode.dark);
		setState(() => acrylicMode = aMode);
		if(mounted) Provider.of<ProviderManager>(context, listen: false).changeTmode(mode);
		notes.value = await DB().getNotes();
		setState(() => isLoaded = true);
	}
	
	
	@override
	void initState() {
		init();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async { return false; },
			child: Scaffold(
				key: scaffoldKey,
				drawer: const DrawerPage(),
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

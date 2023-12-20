import 'package:ekko/animation/expand.dart';
import 'package:ekko/animation/floating_button.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/folder_item.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';


class FoldersPage extends StatefulWidget {
	const FoldersPage({super.key});
 
	@override
	State<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> with TickerProviderStateMixin {

	ValueNotifier<List<Folder>> foldersNotifier = ValueNotifier<List<Folder>>([]);
	bool isLoading = true;
	ScrollController scrollCtrl = ScrollController();
	GenAnimation? floatingButtonAnim;
	DB db = DB();

	void setupAnimations(){
		floatingButtonAnim = generateLinearAnimation(
			ticket: this, initialValue: 1, durations: [1000]);
	}

	Future<void> primalLoading([bool isNew = false]) async {
		debugPrint("[LOADING FOLDERS]");
		if(isNew) setState(() => isLoading = true);
		// await Future.delayed(const Duration(seconds: 2));  // Async Test
		// Load all the folders
		foldersNotifier.value = await db.loadFolders();
		if(isNew) setState(() => isLoading = false);
	}



	@override
	void initState() {
		setupAnimations();
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			await primalLoading(true);
		});
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: (bool didPop){
				if(didPop){ return; }
			},
			child: Scaffold(
				resizeToAvoidBottomInset: false,
				appBar: AppBar(
					title: const Text("Folders"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: (){
							changeView(context, const  HomePage(), isPush: false);
						},
					),
				),
				floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
				floatingActionButton: AnimatedFloatingButton(
					controller: scrollCtrl,
					animation: floatingButtonAnim!,
					child: const Icon(Icons.create_new_folder),
					onPressed: (){
						Dialogs(context).textFieldDialog(
							title: "Name",
							hint: "Name",
							action: (String name) async {
								name = name.trim();
								debugPrint("Name: $name");
								db.createFolder(folderName: name); 
								await primalLoading();
							}
						);
					}
				),
				body: ValueListenableBuilder(
					valueListenable: foldersNotifier,
					builder: (_, folders, __){
						// Check for loading
						if(isLoading){
							return const Center(child: CircularProgressIndicator());}

						// Check that is there any folder
						if(folders.isEmpty){
							return const Center(child: Text("Add New Folder!"));}

						return ListView.builder(
							controller: scrollCtrl,
							itemCount: folders.length,
							itemBuilder: (BuildContext context, int index) => folderItem(
								context: context,
								folder: folders[index],
								update: () => primalLoading(false)
							),
						);

					},
				),
			),
		);
	}
}

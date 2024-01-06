import 'package:ekko/animation/expand.dart';
import 'package:ekko/animation/floating_button.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/folder_item.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/views/land_page.dart';
import 'package:flutter/material.dart';


class FoldersPage extends StatefulWidget {
	final Function? closeLoading;
	final int previousId;
	const FoldersPage({super.key, this.closeLoading, required this.previousId});
 
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
		// Load all the folders
		foldersNotifier.value = await db.loadFolders();
		if(isNew) setState(() => isLoading = false);
	}

	void _back() async {
		List<FolderInfo> fInfo = await DB().loadFoldersInfo();
		if(fInfo.any((e) => e.id == widget.previousId)){
			if(!mounted){ return; }
			changeView(context, const LandPage(), "LandPage", isPush: false);
			return;
		}
		if(!mounted){ return; }
		changeView(context, const LandPage(folderId: 0), "LandPage", isPush: true, isReplace: true);
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
		void dispose() {
			if(widget.closeLoading != null){
				widget.closeLoading!();
			}
			super.dispose();
		}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: (bool didPop){
				if(didPop){ return; }
				_back();
			},
			child: Scaffold(
				resizeToAvoidBottomInset: false,
				appBar: AppBar(
					title: const Text("Folders"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: (){
							_back();
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

						// Folder's list
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

import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/launcher.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/nf_icons.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/models/folder.dart';
import 'package:ekko/views/folders_page.dart';
import 'package:ekko/views/land_page.dart';
import 'package:ekko/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DrawerPage extends StatefulWidget {
	final Function? closeLoading;
	final int currentFolderId;
	const DrawerPage({super.key, this.closeLoading, required this.currentFolderId});

	@override
	State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> with TickerProviderStateMixin{
	
	final double roundness = 5;
	late GenAnimation folderAnim;
	
	void _newView(Widget view, String name){
		Navigator.pop(context);  // Close the drawer
		changeView(context, view, name, isPush: true);
	}


	@override
	void initState() {
		folderAnim = generateLinearAnimation(
			ticket: this, initialValue: 0);
		super.initState();
	}

	// @override
	// void dispose() {
	// 	super.dispose();
	// }

	@override
	Widget build(BuildContext context) {
		return Drawer(
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.only(
					topLeft: Radius.zero,
					bottomLeft: Radius.zero,
					topRight: Radius.circular(roundness),
					bottomRight: Radius.circular(roundness),
				)
			),
			child: ScrollConfiguration(
				behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
				child: ListView(
					children: [
						Container(
							margin: const EdgeInsets.all(12),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Center(
										child: Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												SvgPicture.asset(
													"assets/icon/icon.svg",
													height: 120,
													width:  120,
													// ignore: deprecated_member_use
													color: Theme.of(context).colorScheme.inverseSurface,
												),
												const SizedBox(width: 25),
												Text(
													"Ekko",
													style: TextStyle(
														fontSize: 50,
														color: Theme.of(context).colorScheme.inverseSurface,
														fontFamily: "",
														fontWeight: FontWeight.bold,
														fontStyle: FontStyle.italic
													),
												),
											],
											// ].reversed.toList(),
										),
									),
									Text(
										"\t$appVersion",
										style: TextStyle(
											fontSize: 12,
											color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
										),
									),
								],
							),
						),
						const Divider(),
						ListTile(
							leading: const Icon(Icons.settings),
							title: const Text("Settings"),
							onTap: () => _newView(const SettingsPage(), "SettingsPage"),
						),
						// ListTile(
						// 	leading: const Icon(Icons.folder),
						// 	title: const Text("Folders"),
						// 	onTap: () => _newView(FoldersPage(closeLoading: widget.closeLoading, previousId: widget.currentFolderId,), "FoldersPage"),
						// ),
						InkWell(
							child: Padding(
								padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
								child: Row(
									children: [
										const Icon(Icons.folder),
										const SizedBox(width: 12),
										const Text("Folder"),
										const Expanded(child: SizedBox()),
										SizedBox(
											height: 32,
											width: 32,
											child: IconButton(
												icon: const Icon(Icons.add),
												// icon: const Icon(FontAwesomeIcons.circlePlus),
												iconSize: 16,
												style: ButtonStyle(
													backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondaryContainer)
												),
												onPressed: (){
													if(folderAnim.animation.value == 0){
														folderAnim.controller.forward();
													}
													Dialogs(context).textFieldDialog(
														title: "Name",
														hint: "Name",
														action: (String name) async {
															name = name.trim();
															debugPrint("Name: $name");
															await DB().createFolder(folderName: name); 
															setState(() {});
														}
													);
												},
											)
										)
									],
								),
							),
							onTap: (){
								if(folderAnim.animation.value == 1){
									folderAnim.controller.reverse();
								} else {
									folderAnim.controller.forward();
								}
							},
						),

						const SizedBox(width: 12),
						expandAnimation(
							animation: folderAnim.animation,
							mode: ExpandMode.height,
							body: FutureBuilder(
								future: DB().loadFoldersInfo(),
								builder: (BuildContext context, AsyncSnapshot<List<FolderInfo>> snap){
									if(!snap.hasData){ return const SizedBox(); }
									return Column(
										children: [
											for(int idx = 0; idx < snap.data!.length; idx++) InkWell(
												child: Row(
													children: [
														const SizedBox(width: 25),
														// Icon(Icons.folder, color: idx == 0 ? Colors.amber : null),
														// Icon(Icons.folder, color: idx == 0 ? Colors.amber : null),
														NfFont(
															unicode: idx == widget.currentFolderId ? "\ue5fe " : "\ue5ff ",
															color: idx == 0 ? Colors.amber : null,
															size: 20
														).widget(),
														const SizedBox(width: 3),
														Expanded(child: Text(
															snap.data![idx].name,
															overflow: TextOverflow.ellipsis,
															style: const TextStyle(fontSize: 14)
														))
													],
												),
												onTap: (){
													/* Move to the sleected folder */
													Navigator.of(context).pop();  // Close Drawer
													changeView(
														context,
														LandPage(folderId: snap.data![idx].id),
														"LandPage",
														isPush: true,
														isReplace: true
													);
												},
											)
										],
									);
								}
							)
						),


						/*
						Listener(
							onPointerDown: (pointer){
								if(pointer.buttons == 2){
									Navigator.pop(context);
									githubInfoSheet(context: context);
								}
							},
							child: ListTile(
								leading: const Icon(FontAwesomeIcons.github),
								title: const Text("Github"),
								onTap: () async {
									await launchThis(context: context, url: "https://github.com/empitrix/ekko");
								},
								onLongPress: !isDesktop() ? (){
									Navigator.pop(context);
									githubInfoSheet(context: context);
								} : null,
							)
						)
						*/

					],
				),
			)
		);
	}
}

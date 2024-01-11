import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/launcher.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/views/folders_page.dart';
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

class _DrawerPageState extends State<DrawerPage> {
	
	final double roundness = 5;
	
	void _newView(Widget view, String name){
		Navigator.pop(context);  // Close the drawer
		changeView(context, view, name, isPush: true);
	}

	@override
	void dispose() {
		super.dispose();
	}

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
					ListTile(
						leading: const Icon(Icons.folder),
						title: const Text("Folders"),
						onTap: () => _newView(FoldersPage(closeLoading: widget.closeLoading, previousId: widget.currentFolderId,), "FoldersPage"),
					),
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

				],
			),
		);
	}
}

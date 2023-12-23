import 'package:ekko/config/navigator.dart';
import 'package:ekko/views/folders_page.dart';
import 'package:ekko/views/settings_page.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
	final Function? closeLoading;
	const DrawerPage({super.key, this.closeLoading});

	@override
	State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
	
	final double roundness = 5;
	
	void _newView(Widget view){
		Navigator.pop(context);  // Close the drawer
		changeView(context, view, isPush: true);
	}

	@override
	void dispose() {
		// if(widget.closeLoading != null){
		// 	widget.closeLoading!();
		// }
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
					ListTile(
						leading: const Icon(Icons.settings),
						title: const Text("Settings"),
						onTap: () => _newView(const SettingsPage()),
					),
					ListTile(
						leading: const Icon(Icons.folder),
						title: const Text("Folders"),
						onTap: () => _newView(FoldersPage(closeLoading: widget.closeLoading)),
					)
				],
			),
		);
	}
}

import 'package:ekko/config/navigator.dart';
import 'package:ekko/views/settings_page.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
	const DrawerPage({super.key});

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
					)
				],
			),
		);
	}
}
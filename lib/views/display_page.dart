import 'package:ekko/config/navigator.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
	final SmallNote smallNote;
	const DisplayPage({
		super.key,
		required this.smallNote
	});

	@override
	State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {

	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				changeView(context, const HomePage(), isPush: false);
				return false;
			},
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("Dispaly"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: (){
							changeView(context, const HomePage(), isPush: false);
						},
					),
				),
				body: const Center(child: Text("Display Page!")),
			),
		);
	}
}

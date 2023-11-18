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

	Note? note;
	bool isLoaded = false;

	@override
	void initState() {
		// Load async
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			setState(() => isLoaded = false);
			note = await widget.smallNote.toRealNote();
			if(note!.content.length > 420){
				await Future.delayed(const Duration(seconds: 1));
			}
			setState(() => isLoaded = true);
		});
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
				body: Builder(
					builder: (BuildContext context){

						if(!isLoaded){
							return const Center(
								child: CircularProgressIndicator(),
							);
						}

						return SelectionArea(
							child: ListView(
								padding: const EdgeInsets.all(12),
								children: [
									/* Title */
									Text(
										note!.title,
										style: const TextStyle(
											fontSize: 25,
											fontWeight: FontWeight.w500,
											height: 0
										),
									),
									const SizedBox(height: 5),
									/* Description */
									Text(
										note!.description,
										style: TextStyle(
											fontSize: 20,
											color: Theme.of(context)
												.colorScheme.inverseSurface
												.withOpacity(0.73),
											fontWeight: FontWeight.w500,
											height: 0
										),
									),
									const SizedBox(height: 10),
									Text(
										note!.content,
										style: TextStyle(
											fontSize: Theme.of(context)
												.primaryTextTheme.bodyLarge!.fontSize,
											fontWeight: FontWeight.w500,
											// height: 1.25
											height: 0
										),
									),

								],
							),
						);

					},
				)
			),
		);
	}
	
}

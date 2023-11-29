import 'package:ekko/animation/expand.dart';
import 'package:ekko/animation/floating_button.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/generator.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/home_page.dart';
import 'package:ekko/views/modify_page.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
	final SmallNote smallNote;
	final Widget previousPage;
	final Function loadAll;
	const DisplayPage({
		super.key,
		required this.smallNote,
		required this.previousPage,
		required this.loadAll
	});

	@override
	State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> with TickerProviderStateMixin{

	Note? note;
	bool isLoaded = false;

	// Floating Action Button
	ScrollController scrollCtrl = ScrollController();
	GenAnimation? floatingButtonAnim;
	GenAnimation? appbarHideAnimation;

	void _backToPreviousPage(){
		widget.loadAll();
		changeView(context, const HomePage(), isPush: false);
	}

	void initAnimations(){
		floatingButtonAnim = generateLinearAnimation(
			ticket: this, initialValue: 1, durations: [1000]);
		appbarHideAnimation = generateLinearAnimation(
			ticket: this, initialValue: 56, durations: [100], range: {0, 56});
	}

	void initListeners(){
		double lastOffest = 0.0;
		scrollCtrl.addListener(() {
			if(scrollCtrl.offset > lastOffest){
				appbarHideAnimation!.controller.reverse();
			} else {
				appbarHideAnimation!.controller.forward();
			}
			lastOffest = scrollCtrl.offset;
		});
	}


	Future<void> loadAll([int? id]) async {
		id ??= widget.smallNote.id;
		WidgetsBinding.instance.addPostFrameCallback((_) async {
			setState(() => isLoaded = false);
			// note = await widget.smallNote.toRealNote();
			note = await DB().loadThisNote(id!);
			if(note!.content.length > waitForLoading){
				await Future.delayed(Duration(
					milliseconds: waitLoadingSize));
			}
			setState(() => isLoaded = true);
		});
	}

	@override
	void initState() {
		// Load async
		initAnimations();
		initListeners();
		loadAll();
		super.initState();
	}

	@override
	void dispose() {
		// Dispose animations/tickes
		if(floatingButtonAnim != null){
			floatingButtonAnim!.controller.dispose();
		}
		if(appbarHideAnimation != null){
			appbarHideAnimation!.controller.dispose();
		}
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: (bool didPop) async {
				if(didPop){ return; }
				debugPrint("Did-Pop: $didPop");
				_backToPreviousPage();
			},
			child: Scaffold(
				floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
				floatingActionButton: AnimatedFloatingButton(
					controller: scrollCtrl,
					animation: floatingButtonAnim!,
					child: const Icon(Icons.edit),
					onPressed: () => changeView(
						context, ModifyPage(
							note: widget.smallNote,
							backLoad: (){loadAll();},
							previousPage: widget,
						)),
				),
				// appBar: AppBar(
				//	automaticallyImplyLeading: false,
				//	// toolbarHeight: 56,
				//	title: const Text("Dispaly"),
				//	leading: IconButton(
				//		icon: const Icon(Icons.close),
				//		onPressed: (){
				//			_backToPreviousPage();
				//		},
				//	),
				// ),

				body: Builder(
					builder: (BuildContext context){
						if(!isLoaded){
							return const Center(
								child: CircularProgressIndicator(),
							);
						}
						return Column(
							mainAxisAlignment: MainAxisAlignment.start,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [

								AnimatedBuilder(
									animation: appbarHideAnimation!.animation,
									builder: (BuildContext context, Widget? child) => AppBar(
										automaticallyImplyLeading: false,
										toolbarHeight: appbarHideAnimation!.animation.value,
										title: const Text("Dispaly"),
										leading: IconButton(
											icon: const Icon(Icons.close),
											onPressed: (){
												_backToPreviousPage();
											},
										),
									),
								),

								Expanded(
									child: SelectionArea(
										child: ListView(
											controller: scrollCtrl,
											padding: const EdgeInsets.only(
												right: 12, left: 12,
												top: 12, bottom: 85  // :)
											),
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
												MDGenerator(content: note!.content, textHeight: 1.4)
											],
										),
									)
								)

							],
						);

					},
				)
			),
		);
	}
	
}

import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/fields.dart';
import 'package:ekko/markdown/generator.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
	const PreviewPage({super.key});

	@override
	State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {


	AwesomeController controller = AwesomeController();
	ScrollController scrollCtrl = ScrollController();
	bool syncCtrl = false;


	void _attach(ScrollPosition pos){
		/* Method 1 */
		// if(syncCtrl){
		// 	scrollCtrl.animateTo(pos.pixels.toDouble(), duration: const Duration(milliseconds: 200), curve: Curves.ease);
		// }

		/* Method 2 */
		double maxR = scrollCtrl.position.maxScrollExtent;
		double maxE = pos.maxScrollExtent;
		double val = pos.pixels.toDouble() * maxR / maxE;
		if(syncCtrl){
			scrollCtrl.animateTo(
				val,
				duration: const Duration(milliseconds: 200),
				curve: Curves.ease
			);
		}
	}


	@override
	Widget build(BuildContext context) {
		return PopScope(
			onPopInvoked: (didPop){
				if(didPop){ return; }
			},
			child: Scaffold(
				appBar: AppBar(
					title: const Text("Preview"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: () => Navigator.pop(context),
					),
					actions: [
						Padding(
							padding: const EdgeInsets.only(right: 12),
							child: IconButton(
								icon: Icon(syncCtrl ? Icons.close: Icons.merge),
								onPressed: (){
									setState(() => syncCtrl = !syncCtrl);
									SNK(context).message(
										Icon(syncCtrl ? Icons.merge : Icons.close),
										syncCtrl ? "Synced": "Dissabled");
								},
							)
						)
					],
				),
				body: Row(
					children: [
						Expanded(
							child: Center(
								child: ContentTextFiled(
									controller: controller,
									lineChanged: (_){
										Future.microtask(() => setState((){}));
									},
									focusNode: FocusNode(),
									onOffsetChange: (ScrollPosition pos) => _attach(pos),
									widgetHeight: MediaQuery.sizeOf(context).height - 89,
									previousFocus: (){}
								),
							),
						),
						const VerticalDivider(),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									const SizedBox(height: 5),
									Expanded(child: ScrollConfiguration(
										behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
										child: SelectionArea(child: SingleChildScrollView(
											controller: scrollCtrl,
											child: MDGenerator(
												content: controller.text,
												noteId: -1,
												hotRefresh: () async {
													setState(() {});
												},
											),
										)),
									)),
								],
							)
						),
						const SizedBox(width: 5)
					],
				),
			),
		);
	}
}

import 'package:awesome_text_field/awesome_text_field.dart';
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
				),
				body: Row(
					children: [
						// Expanded(child: Center(child: Text("Panel 1"))),
						// VerticalDivider(),
						// Expanded(child: Center(child: Text("Panel 2")))
						Expanded(
							child: Center(
								child: ContentTextFiled(
									controller: controller,
									lineChanged: (_){
										Future.microtask(() => setState((){}));
									},
									focusNode: FocusNode(),
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
											child: MDGenerator(
												content: controller.text,
												noteId: -1,
												hotRefresh: () async {
													setState(() {});
												},
											),
										)),
									))
								],
							)
						)
					],
				),
			),
		);
	}
}

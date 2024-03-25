import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/tag_field.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/filed_rules.dart';
import 'package:ekko/utils/calc.dart';
import 'package:flutter/material.dart';


class TitleTextField extends StatelessWidget {
	final TextEditingController controller;
	final Function nextFocus;
	final FocusNode focusNode;
	final bool autofocus;
	const TitleTextField({
		super.key,
		required this.controller,
		required this.nextFocus,
		required this.focusNode,
		required this.autofocus
	});

	@override
	Widget build(BuildContext context) {
		ValueNotifier<int> index = ValueNotifier<int>(0);
		int contentLength = 0;

		TextStyle indexStyle(BuildContext context, int index){
			return [
				Theme.of(context).primaryTextTheme.headlineLarge!,
				Theme.of(context).primaryTextTheme.headlineMedium!,
				Theme.of(context).primaryTextTheme.headlineSmall!,
			][index].copyWith(
				color: Theme.of(context).colorScheme.inverseSurface,
			);
		}
		// Convert SizedBox to Container just in case of padding/margin
		return KeyboardListener(
			focusNode: FocusNode(),
			onKeyEvent: (KeyEvent event) async {
				await Future.delayed(const Duration(milliseconds: 100));
				if(event.logicalKey.keyId == 4294968065){
					// Down
					nextFocus();
				}
			},
			
			child: SizedBox(
				child: ValueListenableBuilder(
					valueListenable: index,
					builder: (context, value, child) => TextField(
						controller: controller,
						onSubmitted: (_) => nextFocus(),
						focusNode: focusNode,
						autofocus: autofocus,
						style: indexStyle(context, value),
						onChanged: (txt){
							double width = calcTextSize(
								context,
								txt,
								indexStyle(context, index.value)).width;
							if(txt.isEmpty){
								index.value = 0;
								return;
							}
							if(
									(width + 24) > (MediaQuery.of(context).size.width - 24) &&
									(contentLength < txt.length)
								){
								if(index.value < 2){
									index.value++;
								}
							} else {
								if(index.value > 0 && (contentLength > txt.length)){
									index.value--;
								}
							}
							contentLength = txt.length;
						},
						decoration: const InputDecoration(
							border: InputBorder.none,
							hintText: "Title",
						),
					),
				)
			),
		);
	}
}



class DescriptionTextFiled extends StatelessWidget {
	final TextEditingController controller;
	final FocusNode focusNode;
	final Function previousFocus;
	final Function nextFocus;
	final ValueNotifier<List<String>> tags;
	final GenAnimation animation;
	const DescriptionTextFiled({
		super.key,
		required this.controller,
		required this.focusNode,
		required this.previousFocus,
		required this.nextFocus,
		required this.tags,
		required this.animation,
	});

	@override
	Widget build(BuildContext context) {
		return KeyboardListener(
			focusNode: FocusNode(),
			onKeyEvent: (KeyEvent event) async {
				await Future.delayed(const Duration(milliseconds: 150));
				if(event.logicalKey.keyId == 4294968068){
					previousFocus();
				}
				if(event.logicalKey.keyId == 4294968065){
					nextFocus();
				}
			},
			child: SizedBox(
				// height: 30,
				child: TagField(
					anim: animation,
					controller: controller,
					tags: tags,
					/*
					focusNode: focusNode,
					style: Theme.of(context).primaryTextTheme.titleLarge!
						.copyWith(
							color: Theme.of(context).colorScheme.inverseSurface),
					onEnd: () => nextFocus(),
					*/
				),
			),
		);
	}
}


class ContentTextFiled extends StatelessWidget {
	final AwesomeController controller;
	final FocusNode focusNode;
	final Function previousFocus;
	final double widgetHeight;
	final ValueChanged<LineStatus> lineChanged;
	final double lessOpt;
	const ContentTextFiled({
		super.key,
		required this.controller,
		required this.lineChanged,
		required this.focusNode,
		required this.widgetHeight,
		required this.previousFocus,
		this.lessOpt = -0.1
	});

	@override
	Widget build(BuildContext context) {
		return KeyboardListener(
			focusNode: FocusNode(),
			onKeyEvent: (KeyEvent event) async {
				await Future.delayed(const Duration(milliseconds: 150));
				if(
						event.logicalKey.keyId == 4294968068 &&
						controller.selection.baseOffset == 0
					){ previousFocus(); }
			},
			child: SizedBox(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [

						Builder(
							builder: (context){

								// {@Awesome}
								Padding editor = Padding(
									padding: const EdgeInsets.only(right: 8),
									child: AwesomeTextField(
										controller: controller,
										focusNode: focusNode,
										decoration: const InputDecoration(hintText: "Write..."),
										borderRadius: const BorderRadius.only(
											bottomRight: Radius.circular(0),
											topRight: Radius.circular(0),
										),
										border: Border(
											right: BorderSide(
												color: Theme.of(context).colorScheme.inverseSurface, width: 1),
										),
										lineNumberColor: LineNumberPalette(
											indexColor: dMode ?
												const Color(0xff95949C):
												const Color(0xff69686e),
											onSelectIndex: (dMode ? Colors.black : Colors.white),
											onSelectBackground: (dMode ? Colors.amber : Colors.indigo),
											background: (dMode ?
												const Color(0xff1a232e):
												const Color(0xffc8dffa)).aae(context, lessOpt),
											indexBackground: (dMode ?
												const Color(0xff1a232e):
												const Color(0xffc8dffa)).aae(context, lessOpt),
										),
										lineChanged: lineChanged,
										regexStyle: allFieldRules(context),
										widgetHeight: widgetHeight,
										style: Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(
											color: Theme.of(context).colorScheme.inverseSurface,
											fontFamily: "RobotoMono",
											height: 1.3
										),
									),
								);


								// CustomMultiChildLayout(delegate: delegate)

								// return LayoutBuilder(
								// 	builder: (BuildContext context, BoxConstraints box){
								// 		return editor;
								// 	}
								// );

								return editor;

							}
						)

					],
				),
			),
		);
	}
}


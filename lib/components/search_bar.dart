import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


AppBar customSearchBar({
	required BuildContext context,
	required String title,
	required GenAnimation searchAnim,
	required TextEditingController controller,
	required ValueChanged<String> onChange,
	required FocusNode focus,
	required Function onClose,
	required Function onOpen,
	required Function onLoading,
	required Widget leading}){

	FocusNode shortcutFocus = FocusNode();
	ValueNotifier<double> openNotifier =
		ValueNotifier<double>(searchAnim.animation.value);
	ValueNotifier<bool> textNotifier = ValueNotifier(true);
	searchAnim.animation.addListener((){
		openNotifier.value = searchAnim.animation.value;
	});
	controller.text = "";
	controller.addListener((){
		textNotifier.value = controller.text == "";
	});


	Future<void> toggle() async {
		if(!textNotifier.value){
			controller.text = "";
			onChange(controller.text);
			focus.requestFocus();
			return;
		}
		if(searchAnim.animation.value == 1){
			await searchAnim.controller.reverse();
			onClose();
			shortcutFocus.requestFocus();
			// focus.unfocus();
		}else{
			await searchAnim.controller.forward();
			onOpen();
			// focus.requestFocus();
		}
	}

	return AppBar(
		leading: IconButton(
			icon: leading,
			onPressed: () => onLoading(),
		),
		title: Row(
			mainAxisAlignment: MainAxisAlignment.start,
			children: [
				expandAnimation(
					animation: searchAnim.animation,
					mode: ExpandMode.width,
					body: Container(
						height: isDesktop() ? 40 : 45,
						width: MediaQuery.of(context).size.width - (isDesktop() ? 145 : 152),
						padding: isDesktop() ? const EdgeInsets.only(
							left: 8, right: 8,
							bottom: 4
						) : const EdgeInsets.only(
							left: 8, right: 8,
							top: 0, bottom: 0
						),
						decoration: BoxDecoration(
							borderRadius: BorderRadius.circular(5),
							color: Theme.of(context).scaffoldBackgroundColor.aae(context)
						),
						child: CallbackShortcuts(
								bindings: <ShortcutActivator, VoidCallback>{
									const SingleActivator(LogicalKeyboardKey.keyF, control: true): () async {
										await toggle();
								},
							},
							child: Focus(
								autofocus: true,
								focusNode: shortcutFocus,
								child: TextField(
									focusNode: focus,
									controller: controller,
									onChanged: (value) => onChange(value),
									decoration: const InputDecoration(
										border: InputBorder.none,
										hintText: "Search..."
									),
								),
							),
						),
					)
				),
				expandAnimation(
					animation: searchAnim.animation,
					reverse: true,
					mode: ExpandMode.width,
					body: SizedBox(
						width: MediaQuery.of(context).size.width - 145,
						child: Text(
							title,
							overflow: TextOverflow.ellipsis,
							style: Theme.of(context).appBarTheme.titleTextStyle
						),
					),
				)
			],
		),
		actions: [
			Container(
				margin: const EdgeInsets.all(8),
				child: ValueListenableBuilder(
					valueListenable: openNotifier,
					builder: (_, isOpenV, __){
						bool isOpen = isOpenV == 1;
						return ValueListenableBuilder(
							valueListenable: textNotifier,
							builder: (_, isEmpty, __){
								return IconButton(
									icon: Icon(
										isOpen ?
										isEmpty ? Icons.search :
										Icons.close :
										Icons.search
									),
									onPressed: () async {
										// await __toggle();
										if(!isEmpty){
											controller.text = "";
											onChange(controller.text);
											return;
										}
										if(searchAnim.animation.value == 1){
											await searchAnim.controller.reverse();
											onClose();
											shortcutFocus.requestFocus();
										}else{
											await searchAnim.controller.forward();
											onOpen();
										}
									}
								);
							}
						);
					},
				),
			)
		],
	);
}


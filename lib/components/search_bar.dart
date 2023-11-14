import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/backend.dart';
import 'package:flutter/material.dart';


AppBar customSearchBar({
	required BuildContext context,
	required String title,
	required GenAnimation searchAnim,
	required TextEditingController controller,
	required ValueChanged<String> onChange,
	required Function onClose,
	required Function onLoading,
	required Widget leading}){

	FocusNode focus = FocusNode();
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
							color: Theme.of(context).scaffoldBackgroundColor
						),
						child: TextField(
							focusNode: focus,
							controller: controller,
							onChanged: (value) => onChange(value),
							decoration: const InputDecoration(
								border: InputBorder.none,
								hintText: "Search..."
							),
						),
					)
				),
				expandAnimation(
					animation: searchAnim.animation,
					reverse: true,
					mode: ExpandMode.width,
					body: Text(
						title,
						overflow: TextOverflow.ellipsis,
						style: Theme.of(context).appBarTheme.titleTextStyle
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
									onPressed: (){
										if(!isEmpty){
											controller.text = "";
											onChange(controller.text);
											return;
										}
										if(searchAnim.animation.value == 1){
											searchAnim.controller.reverse();
											focus.unfocus();
											onClose();
										}else{
											searchAnim.controller.forward();
											focus.requestFocus();
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

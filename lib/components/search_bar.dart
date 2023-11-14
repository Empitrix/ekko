import 'package:ekko/animation/expand.dart';
import 'package:flutter/material.dart';


class CustomSearchBar extends StatelessWidget {
	final String title;
	final GenAnimation searchAnim;
	final TextEditingController controller;
	final ValueChanged<String> onChange;
	final Function onClose;
	const CustomSearchBar({
		super.key,
		required this.title,
		required this.searchAnim,
		required this.controller,
		required this.onChange,
		required this.onClose
	});

	@override
	Widget build(BuildContext context) {
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
		return SizedBox(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					expandAnimation(
						animation: searchAnim.animation,
						mode: ExpandMode.width,
						body: Container(
							width: MediaQuery.of(context).size.width - 137,
							height: 40,
							padding: const EdgeInsets.all(10),
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(5),
								color: Theme.of(context).scaffoldBackgroundColor
							),
							child: Center(
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
						)
					),
					expandAnimation(
						animation: searchAnim.animation,
						reverse: true,
						mode: ExpandMode.width,
						body: Text(
							title,
							style: Theme.of(context).appBarTheme.titleTextStyle
						)
					),
					expandAnimation(
						animation: searchAnim.animation,
						mode: ExpandMode.width,
						reverse: true,
						body: SizedBox(
							width: MediaQuery.of(context).size.width - 193)
					),
					const SizedBox(width: 5),
					
					ValueListenableBuilder(
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
					)
				],
			),
		);
	}
}

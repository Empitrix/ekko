import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';


ValueNotifier<bool> _textNotifier = ValueNotifier(true);

class SearchBarField extends StatelessWidget implements PreferredSizeWidget {
	final String title;
	final GenAnimation searchAnim;
	final TextEditingController controller;
	final ValueChanged<String> onChange;
	// final FocusNode focus;
	final Function onClose;
	final Function onOpen;
	final Function onLoading;
	final Widget leading;

	@override
	final Size preferredSize;

	const SearchBarField({
		super.key,
		required this.title,
		required this.searchAnim,
		required this.controller,
		required this.onChange,
		// required this.focus,
		required this.onClose,
		required this.onOpen,
		required this.onLoading,
		required this.leading,
	}):preferredSize = const Size.fromHeight(60.0);


	Future<void> toggle() async {
		if(!_textNotifier.value){
			controller.text = "";
			onChange(controller.text);
			return;
		}
		if(searchAnim.animation.value == 1){
			await searchAnim.controller.reverse();
			onClose();
		}else{
			await searchAnim.controller.forward();
			onOpen();
		}
	}

	@override
	AppBar build(BuildContext context) {


		FocusNode fNode = FocusNode();

		ValueNotifier<double> openNotifier =
			ValueNotifier<double>(searchAnim.animation.value);
		searchAnim.animation.addListener((){
			openNotifier.value = searchAnim.animation.value;
			if(searchAnim.animation.value == 1){
				fNode.requestFocus();
			} else {
				fNode.unfocus();
			}
		});
		controller.text = "";
		controller.addListener((){
			_textNotifier.value = controller.text == "";
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
								color: Theme.of(context).scaffoldBackgroundColor.aae(context)
							),
							child: TextField(
								// focusNode: focus,
								focusNode: fNode,
								autofocus: true,
								controller: controller,
								onChanged: (value){
									if(searchAnim.animation.value == 1){
										onChange(value);
									} else {
										controller.text = "";
									}
								},
								decoration: const InputDecoration(
									border: InputBorder.none,
									hintText: "Search..."
								),
							)
						)
					),
					expandAnimation(
						animation: searchAnim.animation,
						reverse: true,
						mode: ExpandMode.width,
						body: SizedBox(
							width: MediaQuery.of(context).size.width - (isDesktop() ? 145 : 152),
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
								valueListenable: _textNotifier,
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
												// shortcutFocus.requestFocus();
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
}


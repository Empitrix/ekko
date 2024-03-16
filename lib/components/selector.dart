import 'package:flutter/material.dart';
import 'dart:async';


class SelectorButton extends StatelessWidget {
	final BorderRadius? borderRadius;
	final Widget child;
	final void Function()? onTap;
	final void Function()? onLongPress;
	final double? minHeight;

	const SelectorButton({
		super.key,
		required this.child,
		required this.onTap,
		this.onLongPress,
		this.borderRadius,
		this.minHeight,
	});

	@override
	Widget build(BuildContext context){
		late Timer timer;
		bool called = false;
		return SizedBox(
			height: minHeight,
			child: Material(
				borderRadius: borderRadius,
				color: Theme.of(context).colorScheme.tertiaryContainer,
				child: InkWell(
					onTap: (){
						if(!called){
							if(onTap != null){
								onTap!();
							}
						}
					},
					onLongPress: onLongPress,
					borderRadius: borderRadius,
					onTapDown: (TapDownDetails value) async {
						timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
							if(onTap != null){
								onTap!();
							}
							called = true;
						});
					},
					onTapUp: (TapUpDetails value){
						timer.cancel();
						called = false;
					},
					child: child,
				)
			)
		);
	}
}


class InputSelector extends StatelessWidget {
	final double? height;
	final double? width;
	final TextEditingController controller;
	final Type inputType;
	final bool enabled;
	final String hintText;
	final List<dynamic> arguments;

	const InputSelector({
		super.key,
		required this.controller,
		required this.arguments,
		this.enabled = true,
		this.width,
		this.height,
		this.inputType = int,
		this.hintText = "",
	});

	_movement(int pointer){
		if(arguments.isEmpty){ return; }
		// Re-format values into string
		List<String> args = [];
		for(var arg in arguments){ args.add(arg.toString()); }

		if(!args.contains(controller.text)){
			controller.text = arguments.first.toString();
		}
		
		int idx = args.indexOf(controller.text);
		if(pointer > 0){
			idx += pointer;
			if(idx == args.length){
				idx = 0;
			}
		} else {
			idx += pointer;
			if(idx < 0){
				idx = args.length - 1;
			}
		}
		controller.text = args[idx];
	}


	@override
	Widget build(BuildContext context) {
		// if(controller.text.isEmpty){
		// 	controller.text = arguments.first.toString();
		// }
		return IntrinsicWidth(child: Container(
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.secondaryContainer,
				borderRadius: BorderRadius.circular(5)
			),
			height: height,
			width: width,
			child: Row(
				children: [
					SelectorButton(
						borderRadius: const BorderRadius.only(
							topLeft: Radius.circular(5),
							bottomLeft: Radius.circular(5),
						),
						minHeight: height,
						onTap: () => _movement(-1),
						child: const Icon(Icons.arrow_left),
					),
					Container(
						width: 30,
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer
						),
						child: TextField(
							style: TextStyle(
								color: Theme.of(context).colorScheme.inverseSurface
							),
							inputFormatters: const [
								// FilteringTextInputFormatter.allow(regex!),
							],
							controller: controller,
							enabled: enabled,
							decoration: InputDecoration(
								isDense: true,
								hintText: hintText,
								border: InputBorder.none
							)
						),
					),
					SelectorButton(
						borderRadius: const BorderRadius.only(
							topRight: Radius.circular(5),
							bottomRight: Radius.circular(5),
						),
						minHeight: height,
						onTap: () => _movement(1),
						child: const Icon(Icons.arrow_right),
					),
				],
			),
		));
	}
}

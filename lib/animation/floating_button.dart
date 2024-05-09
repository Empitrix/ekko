import 'dart:io';

import 'package:ekko/animation/expand.dart';
import 'package:flutter/material.dart';


class AnimatedFloatingButton extends StatelessWidget {
	final ScrollController controller;
	final GenAnimation animation;
	final Widget child;
	final Function onPressed;

	const AnimatedFloatingButton({
		super.key,
		required this.controller,
		required this.animation,
		required this.child,
		required this.onPressed
	});

	@override
	Widget build(BuildContext context) {
		// Auto Hide
		if(!Platform.isLinux){
			double lastOffset = 0.0;
			controller.addListener(() async {
				if(controller.offset > lastOffset){
					if(animation.animation.value.round() == 1){
						animation.controller.reverse();
					}
				} else {
					if(animation.animation.value.round() == 0){
						animation.controller.forward(from: 0.8);
					}
				}
				lastOffset = controller.offset;
			});
		}

		// Main Button
		return expandAnimation(
			animation: animation.animation,
			mode: ExpandMode.height,
			body: Align(
				alignment: Alignment.bottomRight,
				child: Container(
					margin: const EdgeInsets.all(16),
					child: FloatingActionButton(
						backgroundColor: Theme.of(context).colorScheme.inversePrimary,
						onPressed: () => onPressed(), child: child),
				)
			)
		);

	}
}

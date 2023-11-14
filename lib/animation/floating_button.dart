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
		// Location Sould be:
		//  FloatingActionButtonLocation.endDocked
		// Auto Hide
		double lastOffset = 0.0;
		controller.addListener(() {
			if(controller.offset > lastOffset){
				animation.controller.reverse();
			} else {
				animation.controller.forward();
			}
			lastOffset = controller.offset;
		});
		// Main Button
		return expandAnimation(
			animation: animation.animation,
			mode: ExpandMode.height,
			body: Align(
				alignment: Alignment.bottomRight,
				child: Container(
					margin: const EdgeInsets.only(bottom: 16),
					child: FloatingActionButton(
						onPressed: () => onPressed(), child: child),
				)
			)
		);

	}
}

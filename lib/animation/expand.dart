import 'package:flutter/material.dart';

// TickerProviderStateMixin

class GenAnimation {
	final Animation<double> animation;
	final AnimationController controller;
	late double maxValue;
	GenAnimation({required this.animation, required this.controller, this.maxValue = 1});
}

// Generate Expank animation
GenAnimation generateLinearAnimation({
	required TickerProvider ticket,
	required double initialValue,
	Set<int> range = const {0, 1},
	List<int> durations = const [300, 300],

}){
	AnimationController ctrl = AnimationController(
		vsync: ticket,
		duration: Duration(milliseconds: durations.first),
		reverseDuration: Duration(milliseconds: durations.last),
	);
	Animation<double> anim = Tween<double>(
		begin: range.first.toDouble(),
		end: range.last.toDouble()
	).animate(ctrl);
	ctrl.value = initialValue;

	return GenAnimation(
		animation: anim,
		controller: ctrl,
		maxValue: range.last.toDouble()
	);
}


enum ExpandMode {
	height,
	width
}

typedef CustomBuilder = Widget Function(BuildContext context, Widget? child);

Widget expandAnimation({
	required Animation<double> animation,
	required ExpandMode mode,
	required Widget body,
	BorderRadius? borderRadius,
	// double roundness = 5,
	bool reverse = false
}){
	return AnimatedBuilder(
		animation: animation,
		builder: (BuildContext context, Widget? child) => ClipRect(
			child: ClipRRect(
				borderRadius: borderRadius ?? BorderRadius.circular(5),
				child: Align(
					heightFactor: mode ==
						ExpandMode.height ? reverse ? (1 - animation.value) : animation.value : null,
					widthFactor: mode ==
						ExpandMode.width ? reverse ? (1 - animation.value) : animation.value : null,
					child: body,
				),
			),
		)
	);
}

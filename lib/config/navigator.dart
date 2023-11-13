import 'package:flutter/material.dart';


class CustomPageRoute extends PageRouteBuilder{
	final Widget view;
	final Duration duration;

	CustomPageRoute({
		required this.view,
		this.duration = const Duration(milliseconds: 250),
	}) : super(
		transitionDuration: duration,
		reverseTransitionDuration: duration,
		pageBuilder: (context, animation, secondaryAnimation) => view,
	);

	@override
	Widget buildTransitions(
		BuildContext context,
		Animation<double> animation,
		Animation<double> secondaryAnimation,
		Widget child) => SlideTransition(
			position: Tween<Offset>(
				begin: const Offset(0, 0.5),
				end: Offset.zero
			).animate(
			CurvedAnimation(
				parent: animation,
				curve: Curves.ease,
				reverseCurve: Curves.ease
			)
		),
		child: child
	);
}


void changeView(
	BuildContext context, Widget view,
	{bool isPush = true, isReplace = false}){
	if(isPush){
		if(isReplace){
			Navigator.pushReplacement(
				context,
				// MaterialPageRoute(builder: (_) => view)
				CustomPageRoute(view: view)
			);
		} else {
			Navigator.push(
				context,
				// MaterialPageRoute(builder: (_) => view)
				CustomPageRoute(view: view)
			);
		}
	} else {
		Navigator.pop(context);
	}
}

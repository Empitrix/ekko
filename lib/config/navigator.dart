import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/toolbar.dart';
import 'package:ekko/config/public.dart';
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


void _bringBackFcous(String name){
	if(screenShortcutFocus[name] != null){
		screenShortcutFocus[name]!.requestFocus();
	}
}


void changeView(
	BuildContext context, Widget screen, String name,
	{bool isPush = true, isReplace = false}){

	
		debugPrint("GOING TO: [$name]");
		_bringBackFcous(name);

		Widget? view;

		if(isDesktop()){
			 view = ToolbarView(view: screen);
		} else {
			view = screen;
		}

	if(isPush){
		if(isReplace){
			/* 
				There is an issue for ../l/c/folder_item taht can' replace page 
				SOLVING:
					- Remove current one using .pop
					- Remove Until current one (currently selected)
			*/
			// Remove All the previus views
			Navigator.of(context).popUntil((route) => route.isFirst); 
			// Replace Current one with the new one
			Navigator.pushReplacement(
				context,
				CustomPageRoute(view: view)
			);
		} else {
			Navigator.push(
				context,
				CustomPageRoute(view: view)
			);
		}

	} else {
		Navigator.pop(context);
	}

}

import 'package:flutter/material.dart';
/*
	Following widget is a scaffold that able to
	add shortcuts for dynamic actions
*/

class ShortcutScaffold extends StatelessWidget {
	final Widget? body;
	final PreferredSizeWidget? appBar;
	final Function? onPopInvoked;
	final bool canPop;
	final bool autofocus;
	final FocusNode? focusNode;
	final GlobalKey? scaffoldKey;
	final bool? resizeToAvoidBottomInset;
	final Widget? drawer;
	final FloatingActionButtonLocation? floatingActionButtonLocation;
	final Widget? floatingActionButton;
	final Map<ShortcutActivator, Intent> shortcuts;
	final Map<Type, Action<Intent>> actions;

	const ShortcutScaffold({
		super.key,
		this.body,
		this.appBar,
		this.onPopInvoked,
		this.focusNode,
		this.canPop = false,
		this.autofocus = true,
		this.resizeToAvoidBottomInset,
		this.scaffoldKey,
		this.drawer,
		this.floatingActionButtonLocation,
		this.floatingActionButton,
		this.shortcuts = const {},
		this.actions = const {}

	});

	@override
	Widget build(BuildContext context) {
		return Shortcuts(
			// shortcuts: <ShortcutActivator, Intent>{},
			shortcuts: shortcuts,
			child: Actions(
				// actions: <Type, Action<Intent>>{},
				actions: actions,
				child: Focus(
					focusNode: focusNode,
					autofocus: autofocus,
					child: PopScope(
						canPop: canPop,
						onPopInvoked: (didPop){
							if(didPop){return;}
							if(onPopInvoked != null){
								onPopInvoked!();
							}
						},
						child: Scaffold(
							key: scaffoldKey,
							resizeToAvoidBottomInset: resizeToAvoidBottomInset,
							floatingActionButtonLocation: floatingActionButtonLocation,
							floatingActionButton: floatingActionButton,
							drawer: drawer,
							appBar: appBar,
							body: body,
						),
					),
				),
			),
		);
	}
}


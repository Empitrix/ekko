import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';

WindowButtonColors __primaryColors(BuildContext context){
	return WindowButtonColors(
		// normal: Theme.of(context).appBarTheme.backgroundColor!.aae(context),
		iconMouseOver: Colors.white,
		mouseOver: Colors.red,
		mouseDown: Colors.red.shade800,
		iconNormal: Colors.white
	);
}

WindowButtonColors __secondaryColors(BuildContext context){
	return WindowButtonColors(
		// normal: Theme.of(context).appBarTheme.backgroundColor!.aae(context),
		iconMouseOver: Colors.white,
		mouseOver: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
		mouseDown: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
		iconNormal: Colors.white
	);
}

class ToolbarView extends StatelessWidget {
	final Widget view;
	const ToolbarView({super.key, required this.view});

	@override
	Widget build(BuildContext context) {

		debugPrint("[TOOLBAR REBUILD]");

		Widget runningWidget = Column(
			mainAxisAlignment: MainAxisAlignment.start,
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Container(
					color: Theme.of(context).appBarTheme.backgroundColor!.aae(context),
					child: WindowTitleBarBox(
						child: Row(
							mainAxisAlignment: MainAxisAlignment.start,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Row(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										Container(
											margin: const EdgeInsets.only(
												left: 12, top: 5, bottom: 5
											),
											child: const Text(
												"Ekko",
												style: TextStyle(color: Colors.white),
											),
										)
									],
								),
								Expanded(
									child: MouseRegion(
										cursor: SystemMouseCursors.move,
										child: MoveWindow(),
									),
								),
								Row(
								// TODO: hide to don't show icons for movement
									children: true ? [
										MinimizeWindowButton(colors: __secondaryColors(context)),
										MaximizeWindowButton(colors: __secondaryColors(context)),
										CloseWindowButton(colors: __primaryColors(context))
									] : [],
								)
							],
						),
					),
				),
				Expanded(
					child: view,
				)
			],
		);

		return Scaffold(body: runningWidget);
	}
}


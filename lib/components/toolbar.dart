import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
								Container(
									margin: const EdgeInsets.only(
										left: 12, top: 5, bottom: 5
									),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.center,
										children: [
											SvgPicture.asset(
												"assets/icon/icon.svg",
												height: 20,
												width:  20,
												// ignore: deprecated_member_use
												color: Colors.white,
											),
											const SizedBox(width: 6),
											const Text(
												"Ekko",
												style: TextStyle(color: Colors.white),
											)
										],
									),
								),

								Expanded(
									child: MouseRegion(
										cursor: SystemMouseCursors.move,
										child: MoveWindow(),
									),
								),
								Row(
									children: [
										MinimizeWindowButton(colors: __secondaryColors(context)),
										MaximizeWindowButton(colors: __secondaryColors(context)),
										CloseWindowButton(colors: __primaryColors(context))
									],
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


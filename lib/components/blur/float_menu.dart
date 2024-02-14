import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


class FloatMenu extends StatelessWidget {
	final List<ListTile> actions;
	final Widget? header;
	const FloatMenu({
		super.key,
		required this.actions,
		this.header,
	});

	@override
	Widget build(BuildContext context) {
		Dialog dialog = Dialog(
			backgroundColor: Colors.transparent,
			surfaceTintColor: Colors.transparent,
			elevation: 0,
			clipBehavior: Clip.hardEdge,
			shadowColor: Colors.transparent,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(12)
			),
			alignment: Alignment.centerRight,
			insetPadding: const EdgeInsets.only(top: 20, right: 20),
			child: ClipRect(
				child: BackdropFilter(
					filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
					child: Container(
						decoration: BoxDecoration(
							color: (dMode ? Colors.black : Colors.white).withOpacity(0.5),
						),
						padding: const EdgeInsets.symmetric(vertical: 20),
						constraints: BoxConstraints(
							maxWidth: MediaQuery.sizeOf(context).width / 1.8,
							maxHeight: MediaQuery.sizeOf(context).height - 200
						),
						child: SingleChildScrollView(child:Column(
							children: [
								// Header
								if(header != null) header!,

								if(actions.isNotEmpty) const SizedBox(height: 20),

								for(ListTile action in actions) Material(
									color: Colors.transparent,
									child: ListTile(
										splashColor: (dMode ? Colors.white : Colors.black).withOpacity(0.1),
										leading: action.leading,
										title: action.title,
										titleTextStyle: action.titleTextStyle,
										onTap: action.onTap,
										onLongPress: action.onLongPress,
									),
								),

								const SizedBox(height: 20),
							],
						)),
					),
				),
			),
		);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const SizedBox(height: 85),
				dialog,
			],
		);
	}
}


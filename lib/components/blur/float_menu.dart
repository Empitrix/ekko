import 'dart:io';

import 'package:ekko/backend/backend.dart';
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
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// const SizedBox(height: 85),
				SizedBox(height: isDesktop() ? 85 : 55),
				Dialog(
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
						child: Builder(
							builder: (BuildContext context){
								Widget menuWidget = Container(
									decoration: BoxDecoration(
										color: (settingModes['dMode'] ? Colors.black : Colors.white).withOpacity(0.5),
									),
									padding: const EdgeInsets.symmetric(vertical: 20),
									constraints: BoxConstraints(
										maxWidth: 300,
										// minWidth: MediaQuery.sizeOf(context).width / 1.8,
										maxHeight: MediaQuery.sizeOf(context).height - 200
									),
									child: SingleChildScrollView(child:Column(
										children: [
											// Header
											if(header != null) header!,
											// Actions
											if(actions.isNotEmpty) const SizedBox(height: 20),
											for(ListTile action in actions) Material(
												color: Colors.transparent,
												child: ListTile(
													splashColor: (settingModes['dMode'] ? Colors.white : Colors.black).withOpacity(0.1),
													leading: action.leading,
													trailing: action.trailing,
													title: action.title,
													titleTextStyle: action.titleTextStyle,
													onTap: action.onTap,
													onLongPress: action.onLongPress,
												),
											),
											const SizedBox(height: 20),
										],
									)),
								);
								if(Platform.isLinux){
									return menuWidget;
								}
								return BackdropFilter(
									filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
									child: menuWidget,
								);
							}
						)
					),
				),
			],
		);
	}
}


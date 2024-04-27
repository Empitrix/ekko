import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class EkkoDrawerHeader extends StatelessWidget {
	const EkkoDrawerHeader({super.key});

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				Listener(
					onPointerDown: (e){
						if(e.buttons == 2){
							githubInfoSheet(context: context);
						}
					},
					child: GestureDetector(
						onLongPress: !isDesktop() ? (){
							githubInfoSheet(context: context);
						} : null,
						child: Container(
							margin: const EdgeInsets.all(12),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Center(
										child: Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												SvgPicture.asset(
													"assets/icon/icon.svg",
													height: 120,
													width:  120,
													// ignore: deprecated_member_use
													color: Theme.of(context).colorScheme.inverseSurface,
												),
												const SizedBox(width: 25),
												Text(
													"Ekko",
													style: TextStyle(
														fontSize: 50,
														color: Theme.of(context).colorScheme.inverseSurface,
														fontFamily: "",
														fontWeight: FontWeight.bold,
														fontStyle: FontStyle.italic
													),
												),
											],
											// ].reversed.toList(),
										),
									),
									Text(
										"\t$appVersion",
										style: TextStyle(
											fontSize: 12,
											color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
										),
									),
								],
							),
						),
					),
				),
				const Divider()
			],
		);
	}
}

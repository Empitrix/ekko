import 'package:ekko/backend/launcher.dart';
import 'package:ekko/components/general_widgets.dart';
import 'package:ekko/components/sheets/show.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void githubInfoSheet({
	required BuildContext context,
	}){
	showSheet(
		context: context,
		builder: (BuildContext context) => SizedBox(
			width: MediaQuery.of(context).size.width,
			child: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						SheetText(
							horizontalMargin: 12,
							text: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								mainAxisAlignment: MainAxisAlignment.start,
								children: [
									// App Info
									const Text(
										"Ekko",
										style: TextStyle(
											fontSize: 35,
											fontWeight: FontWeight.bold
										),
									),
									Text(
										appVersion,
										style: TextStyle(
											fontSize: 12,
											color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
										),
									),
									const SizedBox(height: 20),
									const Text("Ekko is an open-source cross-platform application!"),
									Align(
										alignment: Alignment.centerRight,
										child: IconButton(
											tooltip: "Ekko's Github",
											color: Colors.cyan,
											onPressed: () => launchThis(context: context, url: "https://github.com/empitrix/ekko"),
											icon: const Icon(FontAwesomeIcons.github),
										),
									)
								],
							),
						),
						const SizedBox(height: 12)
					],
				),
			),
		)
	);
}

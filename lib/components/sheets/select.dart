import 'package:ekko/components/sheets/show.dart';
import 'package:flutter/material.dart';

void selectSheet({
	required BuildContext context,
	required List<Widget> items,
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
						for(Widget item in items) item,
						const SizedBox(height: 12)
					],
				),
			),
		)
	);
}

import 'package:flutter/material.dart';


Widget onLeadingText({
	/* One lading item that have also a text*/
	required Widget leading,
	required TextSpan text,
	double widgetSpacing = 12
}){
	return Row(
		children: [
			leading,
			SizedBox(width: widgetSpacing),
			Expanded(child: Text.rich(text))
		],
	);
}


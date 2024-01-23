import 'package:ekko/backend/launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


Widget onLeadingText({
	/* One lading item that have also a text*/
	required Widget leading,
	required TextSpan text,
	double widgetSpacing = 12,
	double spacing = 0,
	double topMargin = 0
}){
	return Row(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			SizedBox(width: spacing),
			Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children:[
					SizedBox(height: topMargin),
					leading
				]
			),
			SizedBox(width: widgetSpacing),
			Expanded(child: Text.rich(text))
		],
	);
}


int getIndentationLevel(String line) {
 // Count leading spaces or tabs
 RegExp regex = RegExp(r'^[ \t]+');
 String indentation = regex.stringMatch(line) ?? '';
 // Determine the indentation level (each indent is 2 spaces)
 int indentationLevel = (indentation.length / 2).round();
 return indentationLevel;
}


double getNonRenderedWidgetSize(Widget input){
	// Works for: SizedBox, Icon, (**add more if needed!)
	double size = 0;
	// ignore: invalid_use_of_protected_member
	Widget element = input.createElement().widget; 
	if(element is Icon){
		if(element.size != null){
			size = element.size!;
		}
	} else if(element is SizedBox){
		if(element.width != null){
			size = element.width!;
		}
	} else {
		return 0;
	}
	return size;
}


TapGestureRecognizer useLinkRecognizer(BuildContext context, String link){
	return TapGestureRecognizer()..onTap = () async {
		await launchThis(
			context: context, url: link);
		debugPrint("Opening: $link"); 
	};
}


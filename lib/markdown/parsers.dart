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


int tillFirstLetter(String input){
	List<String> all = input.split("");
	for(int i = 0; i < all.length; i++){
		if(all[i].trim() != ""){
			return i;
		}
	}
	return 0;
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


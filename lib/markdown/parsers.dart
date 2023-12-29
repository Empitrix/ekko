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
		// mainAxisAlignment: MainAxisAlignment.start,
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			SizedBox(width: spacing),
			Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children:[
					// SizedBox(height: isDesktop() ? 6.5 : 12),
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

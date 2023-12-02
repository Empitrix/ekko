import 'package:flutter/material.dart';


Widget onLeadingText({
	/* One lading item that have also a text*/
	required Widget leading,
	required TextSpan text,
	double widgetSpacing = 12,
	double spacing = 0
}){
	return Row(
		children: [
			SizedBox(width: spacing),
			leading,
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

import 'package:ekko/markdown/syntax.dart';
import 'package:ekko/theme/colors.dart';
import 'package:flutter/material.dart';


TextSpan getMonospaceTag(String txt, [double radius = 5]){
	// txt = txt.trim();
	List<String> words = breakPhrase(txt);
	List<WidgetSpan> tags = [];
	for(String w in words){
		tags.add(
			WidgetSpan(child: Container(
				decoration: BoxDecoration(
					borderRadius: BorderRadius.only(
						topLeft: Radius.circular(
							words.indexOf(w) == 0 ? radius : 0),
						bottomLeft: Radius.circular(
							words.indexOf(w) == 0 ? radius : 0),
						topRight: Radius.circular(
							words.indexOf(w) == words.length - 1 ? radius : 0),
						bottomRight: Radius.circular(
							words.indexOf(w) == words.length - 1 ? radius : 0)
					),
					color: getMonoBgColor()
				),
				// child: Text.rich(TextSpan(text: w, style: const TextStyle(
				// 	fontFamily: "RobotoMono" 
				// ))),
				child: Text(w, style: const TextStyle(
					fontFamily: "RobotoMono" 
				)),
			)
		));
	}
	return TextSpan(children: [
		// const TextSpan(text: " "),
		...tags,
		// const TextSpan(text: " "),
	]);
}


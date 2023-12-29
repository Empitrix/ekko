import 'package:ekko/markdown/syntax.dart';
import 'package:ekko/theme/colors.dart';
import 'package:flutter/material.dart';


TextSpan getMonospaceTag(String txt, [double radius = 5, double padding = 5]){
	List<String> words = breakPhrase(txt);
	List<WidgetSpan> tags = [];
	for(String w in words){
		bool isFirst = words.indexOf(w) == 0;
		bool isLast = words.indexOf(w) == words.length - 1;
		tags.add(
			WidgetSpan(child: Container(
				padding: EdgeInsets.only(
					left: isFirst ? padding : 0,
					right: isLast ? padding : 0
				),
				margin: EdgeInsets.zero,
				decoration: BoxDecoration(
					borderRadius: BorderRadius.only(
						topLeft: Radius.circular(
							isFirst ? radius : 0),
						bottomLeft: Radius.circular(
							isFirst ? radius : 0),
						topRight: Radius.circular(
							isLast ? radius : 0),
						bottomRight: Radius.circular(
							isLast ? radius : 0)
					),
					color: getMonoBgColor()
				),
				child: Text(w, style: const TextStyle(
					fontFamily: "RobotoMono" 
				)),
			)
		));
	}
	return TextSpan(children: [
		...tags,
	]);
}


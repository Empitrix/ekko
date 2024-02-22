import 'package:ekko/backend/backend.dart';
import 'package:ekko/models/html_rule.dart';
import 'package:flutter/material.dart';


HtmlAlignment getHtmlAlignment(String input){
	/* Get HTML alignemt value and turn it to enum for html-aligment */
	input = vStr(input);
	late HtmlAlignment align;
	switch(input){
		case "left": { align = HtmlAlignment.left; }
		case "right": { align = HtmlAlignment.right; }
		case "center": { align = HtmlAlignment.center; }
		case "justify": { align = HtmlAlignment.justify; }
		case _: { align = HtmlAlignment.left; }  // Default (like text)
	}
	return align;
}


Alignment htmlToFlutterAlign(HtmlAlignment alignment){
	/* convert to html alignment ( not for justify ) */
	late Alignment align;
	switch(alignment){
		case HtmlAlignment.left: { align = Alignment.centerLeft; }
		case HtmlAlignment.right: { align = Alignment.centerRight; }
		case HtmlAlignment.center: { align = Alignment.center; }
		case _: { align = Alignment.centerLeft; }
	}
	return align;
}


class ApplyHtmlAlignment extends StatelessWidget {
	final List<Widget> children;
	final HtmlAlignment alignment;
	const ApplyHtmlAlignment({
		super.key,
		required this.children,
		required this.alignment
	});

	@override
	Widget build(BuildContext context) {

		if(children.length == 1){
			return Align(
				alignment: htmlToFlutterAlign(alignment),
				child: children.first,
			);
		}

		if(alignment == HtmlAlignment.justify){
			return Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: children,
			);
		}


		return Align(
			alignment: htmlToFlutterAlign(alignment),
			child: Row(children: children),
		);

	}
}


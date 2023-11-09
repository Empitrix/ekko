import 'package:flutter/material.dart';

void changeView(
	BuildContext context, Widget view, {bool isPush = true, isReplace = false}){
	if(isPush){
		if(isReplace){
			Navigator.pushReplacement(
				context,
				MaterialPageRoute(builder: (_) => view)
			);
		} else {
			Navigator.push(
				context,
				MaterialPageRoute(builder: (_) => view)
			);
		}
	} else {
		Navigator.pop(context);
	}
}

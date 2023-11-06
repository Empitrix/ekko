import 'package:flutter/material.dart';

void changeView(BuildContext context, Widget view, {bool isPush = true}){
	if(isPush){
		Navigator.push(
			context,
			MaterialPageRoute(
				builder: (context){
					return view;
				}
			)
		);
	} else {
		Navigator.pop(context);
	}
}

import 'package:flutter/material.dart';
import 'dart:ui';

class HorizontalScrollBehavior extends MaterialScrollBehavior {
	@override
	Set<PointerDeviceKind> get dragDevices => {
		PointerDeviceKind.touch,
		PointerDeviceKind.mouse,
		PointerDeviceKind.stylus,
		PointerDeviceKind.unknown,
	};
}


Future<double> getParrentHeigt(GlobalKey key) async {
	double parrentSize = 0;
	// WidgetsBinding.instance.addPostFrameCallback((_) {
	// 	if(key.currentContext != null){
	// 		parrentSize = (key.currentContext!.findRenderObject() as RenderBox).size.height;
	// 	}
	// });
	await Future.microtask(() async {
		parrentSize = (key.currentContext!.findRenderObject() as RenderBox).size.height;
	});
	return parrentSize;
}

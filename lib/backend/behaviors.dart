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


Future<Size> getParrentSize(GlobalKey key) async {
	/* Get parrent size by getting parrent's GlobalKey */
	Size parrentSize = const Size(0, 0);
	// if(key.currentContext == null){
	// 	return parrentSize;
	// }
	await Future.microtask(() async {
		parrentSize = (
			key.currentContext!.findRenderObject() as RenderBox)
			.size;
	});
	return parrentSize;
}


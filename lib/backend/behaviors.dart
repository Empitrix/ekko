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


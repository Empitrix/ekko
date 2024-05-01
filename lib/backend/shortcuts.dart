import 'package:flutter/material.dart';


TextEditingController insertByShortcut(TextEditingController controller, String pastText, [bool single = false]){
	String main = controller.text;
	int offset = controller.value.selection.baseOffset;
	controller.value = controller.value.copyWith(
		text: "${main.substring(0, offset)}$pastText"
			"${ single ? '' : pastText }${main.substring(offset, main.length)}",
		selection: TextSelection(
			baseOffset: offset + pastText.length,
			extentOffset: controller.value.selection.extentOffset + pastText.length
		),
	);
	return controller;
}

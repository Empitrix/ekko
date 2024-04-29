import 'package:flutter/services.dart';

// bool __isShift(){
// 	final shiftKeys = [LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight];
// 	return HardwareKeyboard.instance.logicalKeysPressed
// 		.where((it) => shiftKeys.contains(it)).isNotEmpty;
// }

bool checkAlternateKey(List<LogicalKeyboardKey> keys){
	return HardwareKeyboard.instance.logicalKeysPressed
		.where((it) => keys.contains(it)).isNotEmpty;
}


class AlterKeyboardKey{
	// final LogicalKeyboardKey onKey;
	final String onKey;
	final bool onShift;
	final bool onCtrl;
	final bool onAlt;
	final bool onTab;

	AlterKeyboardKey({
		required this.onKey,
		this.onAlt = false,
		this.onCtrl = false,
		this.onShift = false,
		this.onTab = false,
	});

	@override
	String toString() {
		return "$onKey"
		"${ (onShift || onCtrl || onAlt) ? " -> [${onAlt ? 'ALT' : ''}"
		"${onCtrl ? ', CTRL' : ''}"
		"${onShift ? ', SHIFT' : ''}]":''}";
	}
}



AlterKeyboardKey checkKeyboardKey(LogicalKeyboardKey key){
	return AlterKeyboardKey(
		onKey: key.keyLabel,
		onAlt: checkAlternateKey([LogicalKeyboardKey.altLeft, LogicalKeyboardKey.altRight]),
		onCtrl: checkAlternateKey([LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight]),
		onTab: checkAlternateKey([LogicalKeyboardKey.tab]),
		onShift: checkAlternateKey([LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight])
	);
}


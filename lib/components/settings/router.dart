import 'package:ekko/components/settings/components/appearance.dart';
import 'package:ekko/components/settings/components/editor.dart';
import 'package:ekko/components/settings/components/fonts.dart';
import 'package:ekko/components/settings/components/general.dart';
import 'package:flutter/material.dart';

class SettingObject {
	final BuildContext context;
	final TickerProvider ticker;
	final void Function(void Function()) setState; 

	SettingObject(this.context, this.ticker, this.setState);

	void init(){}
	Widget load() => const SizedBox();
}

enum SettingItemEnum {
	appearance,
	editor,
	fonts,
	general
}

SettingObject getCurrentSetting({
	required SettingItemEnum item,
	required BuildContext context,
	required TickerProvider ticker,
	required void Function(void Function()) setState
}){
	List<Map<SettingItemEnum, SettingObject>> objects = [
		{ SettingItemEnum.appearance: SettingAppearance(context, ticker, setState) },
		{ SettingItemEnum.fonts: SettingFont(context, ticker, setState) },
		{ SettingItemEnum.editor: SettingEditor(context, ticker, setState) },
		{ SettingItemEnum.general: SettingGeneral(context, ticker, setState) },
	];

	for(Map<SettingItemEnum, SettingObject> m in objects){
		if(m.keys.first == item){
			return m.values.first;
		}
	}

	return SettingObject(context, ticker, setState);
}

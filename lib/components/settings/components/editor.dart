import 'package:ekko/components/settings/router.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:flutter/material.dart';

class SettingEditor extends SettingObject {
	SettingEditor(super.context, super.ticker, super.setState);

	late DB db;

	@override
	void init(){
		db = DB();
	}

	@override
	Widget load(){
		return Column(
			children: [
				SwitchTile(
					leading: const Icon(Icons.wrap_text),
					title: const Text("Wrap Mode"),
					value: settingModes['editorWrapMode'],
					onChange: (bool newState) async {
						setState(() => settingModes['editorWrapMode'] = newState );
						await db.writeBool("editorWrapMode", newState);
					}
				)
			],
		);
	}
}


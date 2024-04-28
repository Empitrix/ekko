import 'package:ekko/components/selector.dart';
import 'package:ekko/components/settings/router.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:flutter/material.dart';

class SettingEditor extends SettingObject {
	SettingEditor(super.context, super.ticker, super.setState);

	late DB db;
	TextEditingController tabSizeCtrl = TextEditingController();

	@override
	void init(){
		db = DB();

		tabSizeCtrl = TextEditingController(text: settingModes['tabSize']!.toString());
		tabSizeCtrl.addListener((){
			int value = int.parse(tabSizeCtrl.text);
			db.writeInt('tabSize', value);
			settingModes['tabSize'] = value;
		});
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
				),

				ListTile(
					title: const Text("Tab Size"),
					leading: const Icon(Icons.format_indent_decrease),
					trailing: InputSelector(
						controller: tabSizeCtrl,
						width: 12,
						height: 28,
						enabled: false,
						arguments: const [2, 4, 8]
					)
				)
			],
		);
	}
}


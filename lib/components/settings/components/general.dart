import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/settings/router.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SettingGeneral extends SettingObject{
	SettingGeneral(super.context, super.ticker, super.setState);

	late DB db;

	@override
	void init(){
		db = DB();
	}

	@override
	Widget load(){
		return Column(
			children: [

				// Wrap Mode
				SwitchTile(
					leading: const Icon(Icons.wrap_text),
					title: const Text("Syntax Wrap Mode"),
					value: wrapCodeMode,
					onChange: (bool newMode) async {
						setState(() => wrapCodeMode = newMode );
						await db.writeBool("wrapCodeMode", newMode);
					}
				),



				// Checkable
				SwitchTile(
					leading: const Icon(FontAwesomeIcons.squareCheck),
					title: const Text("Checkable checklist"),
					value: checkListCheckable,
					onChange: (bool newMode) async {
						setState(() => checkListCheckable = newMode );
						await db.writeBool("checkableCheckList", newMode);
					}
				),

				// Markdown theme
				ListTile(
					leading: const Icon(Icons.color_lens),
					title: const Text("Markdown Theme"),
					subtitle: Row(
						children: [
							TwoColorPalette(
								baseColor: allMarkdownThemes[markdownThemeName]!["root"]!.backgroundColor,
								borderColor: allMarkdownThemes[markdownThemeName]!["meta"]!.color!
							),
							const SizedBox(width: 12),
							Text(markdownThemeName.replaceAll("-"," ").title())
						],
					),
					onTap: (){
						selectMarkdownTheme(
							context: context,
							onSelect: (String name) async {
								debugPrint("Selected Name: $name");
								setState(() { markdownThemeName = name; });
								await db.updateMarkdownTheme(name);
							}
						);
						
					},
				),



			],
		);
	}


}

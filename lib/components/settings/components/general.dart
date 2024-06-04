import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/selector.dart';
import 'package:ekko/components/settings/router.dart';
import 'package:ekko/components/sheets/select_markdown.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:ekko/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SettingGeneral extends SettingObject{
	SettingGeneral(super.context, super.ticker, super.setState);

	late DB db;
	late TextEditingController rModeCtrl;

	@override
	void init(){
		db = DB();
		rModeCtrl = TextEditingController();
		rModeCtrl.text = (settingModes['renderMode'] as RenderMode).name.title();
		rModeCtrl.addListener(() async {
			if(rModeCtrl.text.mini() == "fast"){
				await db.setRenderMode(1);
				settingModes['renderMode'] = RenderMode.fast;
			} else if (rModeCtrl.text.mini() == "fancy"){
				await db.setRenderMode(0);
				settingModes['renderMode'] = RenderMode.fancy;
			}
		});
	}

	@override
	Widget load(){
		return Column(
			children: [

				// Wrap Mode
				SwitchTile(
					leading: const Icon(Icons.wrap_text),
					title: const Text("Syntax Wrap Mode"),
					value: settingModes['wrapCodeMode'],
					onChange: (bool newMode) async {
						setState(() => settingModes['wrapCodeMode'] = newMode );
						await db.writeBool("wrapCodeMode", newMode);
					}
				),



				// Checkable
				SwitchTile(
					leading: const Icon(FontAwesomeIcons.squareCheck),
					title: const Text("Checkable checklist"),
					value: settingModes['checkListCheckable'],
					onChange: (bool newMode) async {
						setState(() => settingModes['checkListCheckable'] = newMode );
						await db.writeBool("checkableCheckList", newMode);
					}
				),


				// Wrap Mode
				SwitchTile(
					leading: const Icon(Icons.format_bold),
					title: const Text("Plain Text Bionic Mode"),
					value: settingModes['plainBionicMode'],
					onChange: (bool newMode) async {
						setState(() => settingModes['plainBionicMode'] = newMode );
						await db.writeBool("plainBionicMode", newMode);
					}
				),


				ListTile(
					title: const Text("Redner Mode"),
					leading: const Icon(Icons.view_day),
					trailing: InputSelector(
						controller: rModeCtrl,
						width: 50,
						height: 28,
						enabled: false,
						arguments: const ["Fancy", "Fast"]
					)
				),

				// Markdown theme
				ListTile(
					leading: const Icon(Icons.color_lens),
					title: const Text("Markdown Theme"),
					subtitle: Row(
						children: [
							TwoColorPalette(
								baseColor: allMarkdownThemes[settingModes['markdownThemeName']]!["root"]!.backgroundColor,
								borderColor: allMarkdownThemes[settingModes['markdownThemeName']]!["meta"]!.color!
							),
							const SizedBox(width: 12),
							Text(settingModes['markdownThemeName'].replaceAll("-"," ").toString().title())
						],
					),
					onTap: (){
						selectMarkdownTheme(
							context: context,
							onSelect: (String name) async {
								debugPrint("Selected Name: $name");
								setState(() { settingModes['markdownThemeName'] = name; });
								await db.updateMarkdownTheme(name);
							}
						);
						
					},
				),



			],
		);
	}


}


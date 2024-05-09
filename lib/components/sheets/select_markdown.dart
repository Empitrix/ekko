import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/sheets/show.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:flutter/material.dart';

void selectMarkdownTheme({
	required BuildContext context,
	required ValueChanged<String> onSelect,
	}){
	showSheet(
		context: context,
		builder: (BuildContext context) => SizedBox(
			width: MediaQuery.of(context).size.width,
			child: SingleChildScrollView(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						for(String name in allMarkdownThemes.keys)  ListTile(
							leading: TwoColorPalette(
								baseColor: allMarkdownThemes[name]!["root"]!.backgroundColor,
								borderColor: allMarkdownThemes[name]!["meta"]!.color!
							),
							title: Text(
								name.replaceAll("-", " ").title()),
							trailing: settingModes['markdownThemeName'] == name ?
								const Icon(Icons.check) :
								null,
							onTap: (){
								Navigator.pop(context);
								onSelect(name);
							},
						),
						const SizedBox(height: 12)
					],
				),
			),
		)
	);
}

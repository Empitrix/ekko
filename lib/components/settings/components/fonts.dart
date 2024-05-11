import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/settings/router.dart';
import 'package:ekko/components/sheets/select.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class SettingFont extends SettingObject{
	SettingFont(super.context, super.ticker, super.setState);

	late DB db;

	@override
	void init(){
		db = DB();
	}

	@override
	Widget load(){
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// Font Family
				ListTile(
					leading: const Icon(Icons.font_download),
					trailing: Container(
						padding: const EdgeInsets.all(5),
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer,
							borderRadius: BorderRadius.circular(5)
						),
						child: Text(
							"${Provider.of<ProviderManager>(context).defaultStyle.fontFamily}",
							style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: "RobotoMono"),
						),
					),
					title: const Text("Font Family"),
					onTap: (){
						selectSheet(
							context: context,
							items: [
								for(String name in ["Rubik", "SauceCodeProNerdFont", "RobotoMono"]) ListTile(
									title: Text(name),
									trailing: Provider.of<ProviderManager>
										(context, listen: false)
										.defaultStyle.fontFamily! == name ?
											const Icon(Icons.check) : null,
									onTap: () async {
										Navigator.pop(context);
										Provider.of<ProviderManager>
											(context, listen: false)
											.changeDefaultTextStyle(fontFamily: name);
										await db.updateTextStyle(context);
									},
								)
							]
						);
					},
				),

				// Font Size
				ListTile(
					leading: const FaIcon(FontAwesomeIcons.arrowDownShortWide, size: 20),
					trailing: Container(
						padding: const EdgeInsets.all(5),
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer,
							borderRadius: BorderRadius.circular(5)
						),
						child: Text(
							"${Provider.of<ProviderManager>(context).defaultStyle.fontSize}",
							style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: "RobotoMono"),
						),
					),
					title: const Text("Font Size"),
					onTap: (){
						selectSheet(
							context: context,
							items: [
								for(double idx = 10; idx < 43; idx ++) ListTile(
									title: Text("${idx}px"),
									trailing: Provider.of<ProviderManager>
										(context, listen: false)
										.defaultStyle.fontSize! == idx ?
											const Icon(Icons.check) : null,
									onTap: () async {
										Navigator.pop(context);
										Provider.of<ProviderManager>
											(context, listen: false)
											.changeDefaultTextStyle(fontSize: idx);
										await db.updateTextStyle(context);
									},
								)
							]
						);
					},
				),

				// Font Weight
				ListTile(
					leading: const FaIcon(FontAwesomeIcons.bold, size: 20),
					trailing: Container(
						padding: const EdgeInsets.all(5),
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer,
							borderRadius: BorderRadius.circular(5)
						),
						child: Text(
							"W-${Provider.of<ProviderManager>(context).defaultStyle.fontWeight!.value}",
							style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: "RobotoMono"),
						),
					),
					title: const Text("Font Weight"),
					onTap: (){
						selectSheet(
							context: context,
							items: [
								for(int idx = 100; idx < 1000; idx = idx + 100) ListTile(
									title: Text("W-$idx"),
									/*
									trailing: int.parse(Provider.of<ProviderManager>
										(context, listen: false)
										.defaultStyle.fontWeight!
										.toString().replaceAll("FontWeight.w", "")) == idx ?
											const Icon(Icons.check) : null,
									*/
									trailing: Provider.of<ProviderManager>
										(context, listen: false)
										.defaultStyle.fontWeight!.value == idx ?
											const Icon(Icons.check) : null,
									onTap: () async {
										Navigator.pop(context);
										Provider.of<ProviderManager>
											(context, listen: false)
											.changeDefaultTextStyle(fontWeight: fontWeightParser(idx));
										await db.updateTextStyle(context);
									},
								)
							]
						);
					},
				),

				// Letter Spacing
				ListTile(
					leading: const FaIcon(FontAwesomeIcons.leftRight, size: 20),
					trailing: Container(
						padding: const EdgeInsets.all(5),
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer,
							borderRadius: BorderRadius.circular(5)
						),
						child: Text(
							"${Provider.of<ProviderManager>(context).defaultStyle.letterSpacing}",
							style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: "RobotoMono"),
						),
					),
					title: const Text("Letter Spacing"),
					onTap: (){
						selectSheet(
							context: context,
							items: [
								for(double idx = 0; idx < 21; idx ++) ListTile(
									title: Text("${idx/10}px"),
									trailing: Provider.of<ProviderManager>
										(context, listen: false)
										.defaultStyle.letterSpacing! == idx / 10 ?
											const Icon(Icons.check) : null,
									onTap: () async {
										Navigator.pop(context);
										Provider.of<ProviderManager>
											(context, listen: false)
											.changeDefaultTextStyle(letterSpacing: idx / 10);
										await db.updateTextStyle(context);
									},
								)
							]
						);
					},
				),

				// Text height
				ListTile(
					leading: const FaIcon(FontAwesomeIcons.upDown, size: 20),
					trailing: Container(
						padding: const EdgeInsets.all(5),
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer,
							borderRadius: BorderRadius.circular(5)
						),
						child: Text(
							"${Provider.of<ProviderManager>(context).defaultStyle.height}",
							style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: "RobotoMono"),
						),
					),
					title: const Text("Text height"),
					onTap: (){
						selectSheet(
							context: context,
							items: [
								for(double idx = 0; idx < 21; idx ++) ListTile(
									title: Text("${idx/10}px"),
									trailing: Provider.of<ProviderManager>
										(context, listen: false)
										.defaultStyle.height! == idx / 10 ?
											const Icon(Icons.check) : null,
									onTap: () async {
										Navigator.pop(context);
										Provider.of<ProviderManager>
											(context, listen: false)
											.changeDefaultTextStyle(height: idx / 10);
										await db.updateTextStyle(context);
									},
								)
							]
						);
					},
				),

				const Divider(),

				ListTile(
					leading: const Icon(Icons.font_download),
					trailing: Container(
						padding: const EdgeInsets.all(5),
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer,
							borderRadius: BorderRadius.circular(5)
						),
						child: Text(
							settingModes['plainFontFamily'],
							style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: "RobotoMono"),
						),
					),
					title: const Text("Plain Font Family"),
					onTap: (){
						selectSheet(
							context: context,
							items: [
								for(String name in ["Rubik", "SauceCodeProNerdFont", "RobotoMono"]) ListTile(
									title: Text(name),
									trailing: settingModes['plainFontFamily'] == name ?
										const Icon(Icons.check):
										null,
									onTap: () async {
										Navigator.pop(context);
										await db.updateString("plainFontFamily", name);
										setState(() => settingModes["plainFontFamily"] = name);
									},
								)
							]
						);
					},
				)

			],
		);
	}
}


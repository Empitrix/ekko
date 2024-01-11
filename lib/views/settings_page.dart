import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/divider.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:ekko/views/land_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';


class SettingsPage extends StatefulWidget {
	const SettingsPage({super.key});

	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin{
	
	DB db = DB();
	GenAnimation? sliderAnim;
	
	void initAnimations(){
		sliderAnim = generateLinearAnimation(
			ticket: this, initialValue: acrylicMode ? 1: 0);
	}


	@override
	void initState() {
		initAnimations();
		super.initState();
	}

	@override
		void dispose() {
			if(sliderAnim != null){
				sliderAnim!.controller.dispose();
			}
			super.dispose();
		}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: (bool didPop) async {
				if(didPop) { return; }
				changeView(context, const LandPage(), "LandPage", isPush: false);
			},
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("Settings"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: () => changeView(context, const LandPage(), "LandPage", isPush: false),
					),
				),
				body: ListView(
					padding: const EdgeInsets.only(bottom: 12),
					children: [
						SwitchTile(
							leading: const Icon(Icons.dark_mode),
							title: const Text("Dark Mode"),
							value: dMode,
							onChange: (bool value) async {
								setState(() { dMode = value; });
								Provider.of<ProviderManager>(context, listen: false).changeTmode(
									dMode ? ThemeMode.dark : ThemeMode.light);
								await db.updateTheme(dMode ? ThemeMode.dark : ThemeMode.light);
							}
						), // Dark mode

						if(isDesktop(["linux"])) SwitchTile(
							leading: const Icon(Icons.window),
							title: const Text("Acrylic Mode"),
							value: acrylicMode,
							onChange: (bool value) async {
								if(value){
									await sliderAnim!.controller.forward();
									await Window.setEffect(
										effect: WindowEffect.acrylic,
										// ignore: use_build_context_synchronously
										color: const Color(0xff17212b).aae(context)
									);
									double op = await db.readAcrylicOpacity();
									// ignore: use_build_context_synchronously
									Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(op);
								} else {
									await sliderAnim!.controller.reverse();
									await Window.setEffect(
										effect: WindowEffect.disabled,
										// ignore: use_build_context_synchronously
										color: const Color(0xff17212b).aae(context)
									);
									// ignore: use_build_context_synchronously
									Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(1);
								}
								setState(() { acrylicMode = value; });
								await db.updateAcrylicMode(value);
							}
						),	// Acrylic mode

						if(isDesktop()) expandAnimation(
							animation: sliderAnim!.animation,
							mode: ExpandMode.height,
							body: SliderTile(
								leading: const Icon(Icons.opacity),
								text: "Acrylic Opacity",
								value: Provider.of<ProviderManager>(context, listen: false).acrylicOpacity,
								onChanged: (double newData) async {
									if(Provider.of<ProviderManager>(context, listen: false).acrylicOpacity == newData){
										return;
									}
									setState(() {});  // Rebuild the page
									Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(
										newData);
									Future.microtask(() async {
										await db.updateAcrylicOpacity(newData);
									});
								} 
							)
						),
						// Wrap Mode
						SwitchTile(
							leading: const Icon(Icons.wrap_text),
							title: const Text("Syntax Wrap Mode"),
							value: wrapCodeMode,
							onChange: (bool newMode) async {
								setState(() => wrapCodeMode = newMode );
								await db.updateWrapCodeMode(newMode);
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

						// Fonts
						const TitleDivider(title: "Font"),
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
									"${Provider.of<ProviderManager>(context).defaultStyle.fontWeight}".replaceAll("FontWeight.w", "W-"),
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
											trailing: int.parse(Provider.of<ProviderManager>
												(context, listen: false)
												.defaultStyle.fontWeight!
												.toString().replaceAll("FontWeight.w", "")) == idx ?
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

					],
				),
			),
		);
	}
}

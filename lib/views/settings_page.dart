import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';

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
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				changeView(context, const HomePage(), isPush: false);
				return false;
			},
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("Settings"),
					leading: IconButton(
						icon: const Icon(Icons.close),
						onPressed: () => changeView(context, const HomePage(), isPush: false),
					),
				),
				body: ListView(
					children: [

						SwitchTile(
							leading: const Icon(Icons.dark_mode),
							title: const Text("Dark Mode",
								style: TextStyle(fontWeight: FontWeight.bold)),
							value: dMode,
							onChange: (bool value) async {
								setState(() { dMode = value; });
								Provider.of<ProviderManager>(context, listen: false).changeTmode(
									dMode ? ThemeMode.dark : ThemeMode.light);
								await db.updateTheme(dMode ? ThemeMode.dark : ThemeMode.light);
							}
						), // Dark mode

						if(isDesktop()) SwitchTile(
							leading: const Icon(Icons.window),
							title: const Text("Acrylic Mode",
								style: TextStyle(fontWeight: FontWeight.bold)),
							value: acrylicMode,
							onChange: (bool value) async {
								if(value){
									await sliderAnim!.controller.forward();
									await Window.setEffect(
										effect: WindowEffect.acrylic,
										// ignore: use_build_context_synchronously
										color: const Color(0xff17212b).aae(context)
									);
								} else {
									await sliderAnim!.controller.reverse();
									// ignore: use_build_context_synchronously
									Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(1);
									await Window.setEffect(
										effect: WindowEffect.disabled,
										// ignore: use_build_context_synchronously
										color: const Color(0xff17212b).aae(context)
									);
								}
								setState(() { acrylicMode = value; });
								await db.updateAcrylicMode(value);
							}
						),  // Acrylic mode

						if(isDesktop()) expandAnimation(
							animation: sliderAnim!.animation,
							mode: ExpandMode.height,
							body: SliderTile(
								leading: const Icon(Icons.opacity),
								text: "Acrylic Opacity",
								value: Provider.of<ProviderManager>(context, listen: false).acrylicOpacity,
								onChanged: (double newData){
									setState(() {});  // Rebuild the page
									Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(
										newData);
								} 
							)
						)

					],
				),
			),
		);
	}
}
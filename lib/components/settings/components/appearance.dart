import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/settings/router.dart';
import 'package:ekko/components/tiles.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';


class SettingAppearance extends SettingObject{
	SettingAppearance(super.context, super.ticker, super.setState);

	late DB db;
	late GenAnimation sliderAnim;

	@override
	void init(){
		db = DB();
		sliderAnim = generateLinearAnimation(
			ticket: ticker, initialValue: acrylicMode ? 1: 0);
	}

	@override
	Widget load(){
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [

				SwitchTile(
					leading: const Icon(Icons.dark_mode),
					title: const Text("Dark Mode"),
					value: dMode,
					onChange: (bool value) async {
						setState(() { dMode = value; });
						Provider.of<ProviderManager>(context, listen: false).changeTmode(
							dMode ? ThemeMode.dark : ThemeMode.light);
						await db.writeBool("darkMode", dMode);
					}
				), // Dark mode

				if(isDesktop(["linux"])) SwitchTile(
					leading: const Icon(Icons.window),
					title: const Text("Acrylic Mode"),
					value: acrylicMode,
					onChange: (bool value) async {
						if(value){
							await sliderAnim.controller.forward();
							await Window.setEffect(
								effect: WindowEffect.acrylic,
								// ignore: use_build_context_synchronously
								color: const Color(0xff17212b).aae(context)
							);
							double op = await db.readAcrylicOpacity();
							// ignore: use_build_context_synchronously
							Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(op);
						} else {
							await sliderAnim.controller.reverse();
							await Window.setEffect(
								effect: WindowEffect.disabled,
								// ignore: use_build_context_synchronously
								color: const Color(0xff17212b).aae(context)
							);
							// ignore: use_build_context_synchronously
							Provider.of<ProviderManager>(context, listen: false).changeAcrylicOpacity(1);
						}
						setState(() { acrylicMode = value; });
						await db.writeBool("acrylicMode", value);
					}
				),	// Acrylic mode

				if(isDesktop()) expandAnimation(
					animation: sliderAnim.animation,
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

			],
		);
	}
}

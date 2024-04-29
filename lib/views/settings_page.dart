import 'package:ekko/animation/expand.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/components/alerts.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/components/settings/router.dart';
import 'package:ekko/components/settings/panel.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/database/database.dart';
import 'package:ekko/database/latex_temp_db.dart';
import 'package:ekko/views/change_page.dart';
import 'package:ekko/views/land_page.dart';
import 'package:flutter/material.dart';


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
			ticket: this, initialValue: settingModes['acrylicMode'] ? 1: 0);
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
						// onPressed: () => Navigator.pop(context),
					),
				),
				body: ListView(
					children: [
						SettingPanel(
							title: const Text("Options"),
							children: [
								for(SettingItemEnum itm in SettingItemEnum.values) ...[
										ListTile(
										title: Text(itm.name.title()),
										trailing: const Icon(Icons.arrow_right),
										onTap: () => changeView(context, ChangePage(
											item: itm,
										), "ChangePage"),
									),
								]
							]
						),
						ListTile(
							title: const Text("Clear Temporary Data"),
							leading: const Icon(Icons.cleaning_services),
							onTap: (){
								Dialogs(context).ask(
									title: "Clean",
									content: "All the temporary files will be deleted.",
									action: () async {
										TempDB().init(force: true);
										SNK(context).message(
											const Icon(Icons.check_circle),
											"Temporary data has been removed!");
									}
								);
							},
						)
					],
				),
			),
		);
	}
}


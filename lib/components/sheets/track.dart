import 'package:ekko/components/blur/float_menu.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void inTrackSheet({
	required BuildContext context,
	required Function onLoad,
	required Function(String) onFilePick,
	required Function(bool) onScrollChange,
	required bool autoScrollValue,
}){
	ValueNotifier<bool> themeNotif = ValueNotifier<bool>(settingModes['dMode']);
	ValueNotifier<bool> scrollNotif = ValueNotifier<bool>(autoScrollValue);

	showDialog(
		context: context,
		builder: (_){
			return FloatMenu(
				header: Align(
					alignment: Alignment.centerRight,
					child: Padding(
						padding: const EdgeInsets.only(right: 8),
						child: IconButton(onPressed: () => Navigator.pop(context),
							icon: const Icon(Icons.close_rounded)),
					),
				),
				actions: [

					ListTile(
						leading: const Icon(Icons.file_open),
						title: const Text("Chose a file"),
						onTap:() async {
							FilePickerResult? result = await FilePicker.platform.pickFiles(
								type: FileType.custom,
								allowedExtensions: ['md']);
							if (result != null) {
								onFilePick(result.paths.first!);
							}
							// ignore: use_build_context_synchronously
							Navigator.pop(context);
						}
					),

					ListTile(
						leading: const Icon(Icons.dark_mode),
						trailing: IgnorePointer(child: Transform.scale(
							scale: 0.75,
							child: ValueListenableBuilder<bool>(
								valueListenable: themeNotif,
								builder: (BuildContext context, bool val, Widget? child) =>
									Switch(value: val, onChanged: (_){})
							)
						)),
						title: const Text("Switch Theme"),
						onTap: () async {
							bool val = !settingModes['dMode'];
							settingModes['dMode'] = val;
							themeNotif.value = val;
							Provider.of<ProviderManager>(context, listen: false).changeTmode(val ? ThemeMode.dark : ThemeMode.light);
							onLoad();
						}
					),

					ListTile(
						leading: const Icon(Icons.arrow_downward),
						trailing: IgnorePointer(child: Transform.scale(
							scale: 0.75,
							child: ValueListenableBuilder<bool>(
								valueListenable: scrollNotif,
								builder: (BuildContext context, bool val, Widget? child) =>
									Switch(value: val, onChanged: (_){})
							)
						)),
						title: const Text("Auto Scroll"),
						onTap: () async {
							scrollNotif.value = !scrollNotif.value;
							onScrollChange(scrollNotif.value);
						}
					),

				],
			);
		},
	);
}

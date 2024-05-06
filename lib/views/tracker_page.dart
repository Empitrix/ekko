import 'dart:async';
import 'dart:convert';

import 'package:ekko/components/sheets.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/generator.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class TrackerPage extends StatefulWidget {
	const TrackerPage({super.key});

	@override
	State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {

	TextEditingController controller = TextEditingController();
	ValueNotifier<Color> colorNotif = ValueNotifier<Color>(Colors.red);
	ValueNotifier<String> dataNotif = ValueNotifier<String>("");
	Timer? timer;


	File? _isPathValid(){
		File file = File(controller.text);
		if(!file.existsSync()){
			colorNotif.value = Colors.red;
		} else {
			colorNotif.value = settingModes['dMode'] ? Colors.blue : Colors.white;
			return file;
		}
		return null;
	}


	void readingCicle() async {
		timer = Timer.periodic(const Duration(seconds: 1), (Timer t){
			File? dataFile = _isPathValid();
			if(dataFile != null){
				try{
					dataNotif.value = dataFile
						.readAsStringSync(encoding: Encoding.getByName('UTF-8')!)
						.replaceAll("\r", "");
				}catch(e){
					dataNotif.value = "> [!CAUTION]\n> $e";
				}
			}
		});
	}


	@override
	void initState() {
		readingCicle();
		super.initState();
	}

	@override
	void dispose() {
		if(timer != null){ timer!.cancel(); }  // Dispose Timer
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			onPopInvoked: (didPop){
				if(didPop){ return; }
			},
			child: Scaffold(
				appBar: AppBar(
					leading: IconButton(
						onPressed: () => Navigator.pop(context),
						icon: const Icon(Icons.close)
					),
					title: ValueListenableBuilder<Color>(
						valueListenable: colorNotif,
						builder:(BuildContext context, Color clr, Widget? child){
							return TextField(
								controller: controller,
								style: TextStyle(color: clr),
								onChanged: (_){
									_isPathValid();
								},
								decoration: const InputDecoration(
									border: InputBorder.none,
									hintText: "File Path"
								),
							);
						}
					),
					actions: [
						Padding(
							padding: const EdgeInsets.only(right: 12),
							child: IconButton(
								icon: const Icon(Icons.more_vert),
								onPressed: () => inTrackSheet(
									context: context,
									onFilePick: (String filePath){
										controller.text = filePath;
									},
									onLoad: () => setState((){},
								)),
							),
						)
					],
				),
				body: Padding(padding: const EdgeInsets.all(12), child: ScrollConfiguration(
					behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
					child: SelectionArea(child: SingleChildScrollView(
						// controller: scrollCtrl,
						child: ValueListenableBuilder(
							valueListenable: dataNotif,
							builder: (BuildContext context, String data, Widget? child){
								return MDGenerator(
									content: data,
									noteId: -1,
									hotRefresh: () => setState(() {}),
								);
							},
						),
					)),
				)),
			),
		);
	}
}


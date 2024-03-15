import 'package:ekko/components/settings/router.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';


class ChangePage extends StatefulWidget {
	final SettingItemEnum item;

	const ChangePage({
		super.key,
		required this.item,
	});

	@override
	State<ChangePage> createState() => _ChangePageState();
}

class _ChangePageState extends State<ChangePage> with TickerProviderStateMixin{
	late SettingObject object;

	@override
	void initState() {
		object = getCurrentSetting(
			item: widget.item, context: context, ticker: this, setState: setState);
		object.init();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return PopScope(
			canPop: false,
			onPopInvoked: (didPop){
				if(didPop){ return; }
				Navigator.pop(context);
			},
			child: Scaffold(
				appBar: AppBar(
					leading: IconButton(
						icon: const Icon(Icons.arrow_back),
						onPressed: () => Navigator.pop(context)
					),
					title: Text(widget.item.name.title()),
				),
				body: ListView(
					children: [
						object.load()
					],
				)
			),
		);
	}
}


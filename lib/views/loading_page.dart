import 'package:ekko/config/navigator.dart';
import 'package:ekko/utils/loading.dart';
import 'package:ekko/views/home_page.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
	const LoadingPage({super.key});

	@override
	State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

	Future<void> init() async {
		// init 
		await essentialLoading(context);
		if(mounted){
			changeView(
				context, const HomePage(), isPush: true, isReplace: true);
		}
	}

	@override
	void initState() {
		init();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async => false,
			child: const Scaffold(
				body: Center(child: CircularProgressIndicator()),
			),
		);
	}
}
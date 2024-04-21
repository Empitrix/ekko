import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerIt extends StatelessWidget {
	final double widthRatio; 
	final double heightRatio;
	const ShimmerIt({super.key, required this.widthRatio, required this.heightRatio});
	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(5),
				border: Border.all(
					width: 2,
					color: settingModes['dMode'] ?
						Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.5):
						Colors.grey.shade500
				),
			),
			child: Shimmer.fromColors(
				baseColor: settingModes['dMode'] ?
					Theme.of(context).appBarTheme.backgroundColor!:
					Colors.grey.shade400,
				highlightColor: settingModes['dMode'] ?
					Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.5):
						Colors.grey.shade300,
				child: Container(
					color: settingModes['dMode'] ?
						Theme.of(context).appBarTheme.backgroundColor!:
						Colors.grey,
					width: widthRatio * MediaQuery.sizeOf(context).height / 100,
					height: heightRatio * MediaQuery.sizeOf(context).height / 100, 
				),
			)
		);
	}
}


class InLoadingPage extends StatelessWidget {
	const InLoadingPage({super.key});
	@override
	Widget build(BuildContext context) {
		return ScrollConfiguration(
			behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
			child: const SingleChildScrollView(
				physics: NeverScrollableScrollPhysics(),
				padding: EdgeInsets.all(12),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						ShimmerIt(widthRatio: 50, heightRatio: 8),
						SizedBox(height: 12),
						ShimmerIt(widthRatio: 70, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 75, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 55, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 45, heightRatio: 3),
						SizedBox(height: 20),
						ShimmerIt(widthRatio: 80, heightRatio: 30),
						SizedBox(height: 35),
						ShimmerIt(widthRatio: 70, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 75, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 75, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 45, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 60, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 80, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 30, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 80, heightRatio: 3),
						SizedBox(height: 5),
						ShimmerIt(widthRatio: 60, heightRatio: 3),
					]
				),
			)
		);
	}
}


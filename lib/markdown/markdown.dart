import 'package:ekko/backend/ccb.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';


class MarkdownWidget extends StatelessWidget {
	final String content;
	final double radius;
	final double height;
	const MarkdownWidget({
		super.key,
		required this.content,
		this.radius = 5,
		this.height = 0.0,
	});


	/* Strings */
	String _content(){
		// return content.trim()
		// 	.substring(3, content.trim().length - 3);
		return content.trim()
			.substring(3, content.trim().length - 3).trim();
	}
	// String _langName() {
	// 	return _content().trim().substring(
	// 		0, _content().trim().indexOf("\n")
	// 	).trim();
	// 	// return "N/A";
	// }

	String _langName(String input){
		RegExp regex = RegExp(r"```\s*\w+");
		RegExpMatch? out = regex.firstMatch(input);
		if(out == null){ return "N/A"; }
		String lang = out.group(0)!.trim().substring(3);
		lang = lang.trim();
		if(lang.trim().isEmpty){ return "N/A"; }
		return lang;
	}

	String _markdownData(){
		// return _content()
		// 	.replaceRange(0, _content().indexOf("\n") + 1, "");
		return _content()
			.replaceRange(0, _content().indexOf("\n") + 1, "");
	}

	/* Markdown Contexts */
	HighlightView highlightView(){
		return HighlightView(
			_markdownData(),
			language: _langName(content).toLowerCase(),
			tabSize: 2,
			// theme: gruvboxDarkTheme,
			theme: allMarkdownThemes[markdownThemeName]!,
			
		);
	}

	TextStyle markdownStyle(){
		return TextStyle(height: height);
	}

	/* Widgets */
	Widget header(BuildContext context){
		ValueNotifier<bool> onCopyNotifier = ValueNotifier<bool>(false);
		
		return Container(
			padding: const EdgeInsets.only(
				left: 10,
				right: 5
			),
			decoration: BoxDecoration(
				color: dMode ?
					Theme.of(context).colorScheme.background.aae(context) :
					Theme.of(context).colorScheme.onBackground.aae(context),
				borderRadius: BorderRadius.only(
					topLeft: Radius.circular(radius),
					topRight: Radius.circular(radius),
					bottomLeft: Radius.zero,
					bottomRight: Radius.zero
				)
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					RichText(
						text: TextSpan(
							text: _langName(content).title(),
							style: const TextStyle(
								fontWeight: FontWeight.w600,
								letterSpacing: 0.2
							)
						)
					),
					Container(
						margin: const EdgeInsets.all(2),
						width: 30, height: 30,
						child: IconButton(
							icon: ValueListenableBuilder(
								valueListenable: onCopyNotifier,
								builder: (_, onCopy, __) => Icon(
									onCopy ? Icons.check : Icons.copy,
									color: onCopy ? Colors.green : Colors.white,
									size: 15,  // DFLT:17
								),
							),
							onPressed: () async {
								CCB.copy(_markdownData());
								onCopyNotifier.value = true;
								await Future.delayed(const Duration(seconds: 1));
								onCopyNotifier.value = false;
							},
						)
					)
				],
			),
		);
	}

	Widget markdown(BuildContext context, ScrollController controller){
		Widget container = Container(
			width: double.infinity,
			padding: const EdgeInsets.all(10),
			decoration: BoxDecoration(
				color: highlightView().getBG().aae(context),
				borderRadius: BorderRadius.only(
					topLeft: Radius.zero,
					topRight: Radius.zero,
					bottomLeft: Radius.circular(radius),
					bottomRight: Radius.circular(radius)
				)
			),
			// child: Text.rich(highlightView().getSpan(
			// 	style: markdownStyle())),
			// child: Expanded(child: Text.rich(highlightView().getSpan(style: markdownStyle()))),
			// child: Text.rich(highlightView().getSpan(style: markdownStyle())),
			
			// child: SingleChildScrollView(child: Row(
			// 	children: [
			// 		// Expanded(child: Text.rich(highlightView().getSpan(style: markdownStyle())) )
			// 		SingleChildScrollView(child: Text.rich(highlightView().getSpan(style: markdownStyle())) )
			// 	],
			// )),
			
			// child: Text.rich(highlightView().getSpan(style: markdownStyle()))
			// child: SingleChildScrollView(
			// 	child: Column(
			// 		children: [
			// 			Text.rich(highlightView().getSpan(style: markdownStyle()))
			// 		],
			// 	),
			// )

			// child: Text.rich(highlightView().getSpan(style: markdownStyle()))
		
			child: wrapCodeMode ?
				Text.rich(highlightView().getSpan(style: markdownStyle())):
				Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Scrollbar(
							controller: controller,
							radius: const Radius.circular(2.4),
							thumbVisibility: false,
							child: SingleChildScrollView(
								controller: controller,
								scrollDirection: Axis.horizontal,
								child: Column(
									children: [
										Text.rich(highlightView().getSpan(style: markdownStyle())),
										const SizedBox(height: 10.5)  // Scroll-Bar size + 2.5 additional
									],
								),
							)
						)
						// SingleChildScrollView(
						// 	controller: controller,
						// 	scrollDirection: Axis.horizontal,
						// 	child: Column(
						// 		children: [
						// 			Text.rich(highlightView().getSpan(style: markdownStyle()))
						// 		],
						// 	),
						// )
					],
				)
		);
		return container;
	}

	@override
	Widget build(BuildContext context) {
		ScrollController horizontalMarkdown = ScrollController();
		return Container(
			// margin: const EdgeInsets.all(0),
			margin: const EdgeInsets.symmetric(vertical: 8),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					header(context),
					markdown(context, horizontalMarkdown),
				],
			),
		);
	}
}

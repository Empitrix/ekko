import 'package:ekko/backend/ccb.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/backend/indentation.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class MarkdownWidget extends StatelessWidget {
	final String content;
	final double radius;
	final double height;
	final double lessOpt;
	final bool deIndent;
	const MarkdownWidget({
		super.key,
		required this.content,
		this.radius = 5,
		this.height = 0.0,
		this.deIndent = true,
		this.lessOpt = -0.1 // value of (more / less) of transparency (*Acrylic)
	});


	/* Strings */
	String _content(){
		return content.trim()
			.substring(3, content.trim().length - 3).trim();
	}

	String _langName(String input){
		RegExp regex = RegExp(r"```\s*\w+");
		RegExpMatch? out = regex.firstMatch(input);
		if(out == null){ return "N/A"; }
		String lang = out.group(0)!.trim().substring(3);
		lang = lang.trim();
		if(lang.trim().isEmpty){ return "N/A"; }
		return lang;
	}

	// String _markdownData(){
	// 	return _content()
	// 		.replaceRange(0, _content().indexOf("\n") + 1, "");
	// }

	String _markdownData(){
		String data = _content()
			.replaceRange(0, _content().indexOf("\n") + 1, "");
		data = data.replaceAll("\t", " " * tabSize);
		if(deIndent){
			data = deIndentText(data).trimRight();
		}
		return data;
	}

	/* Markdown Contexts */
	HighlightView highlightView(){
		return HighlightView(
			_markdownData(),
			language: _langName(content).toLowerCase(),
			tabSize: tabSize,
			theme: allMarkdownThemes[markdownThemeName]!,
			
		);
	}

	TextStyle markdownStyle(){
		return TextStyle(
			height: height,
			fontFamily: "RobotoMono"
		);
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
					Theme.of(context).colorScheme.background.aae(context, lessOpt) :
					Theme.of(context).colorScheme.onBackground.aae(context, lessOpt),
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
							style: TextStyle(
								fontWeight: FontWeight.w600,
								fontFamily: "Rubik",
								// letterSpacing: letterSpacing
								letterSpacing: Provider.of<ProviderManager>(context).defaultStyle.letterSpacing,
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
									onCopy ? Icons.check : FontAwesomeIcons.solidCopy,
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
				color: highlightView().getBG().aae(context, lessOpt),
				borderRadius: BorderRadius.only(
					topLeft: Radius.zero,
					topRight: Radius.zero,
					bottomLeft: Radius.circular(radius),
					bottomRight: Radius.circular(radius)
				)
			),
			child: wrapCodeMode ?
				Text.rich(highlightView().getSpan(style: markdownStyle())):
				Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						MouseRegion(
							// cursor: SystemMouseCursors.resizeRight,
							cursor: SystemMouseCursors.resizeColumn,
							child: Scrollbar(
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
						),
					],
				)
		);
		return container;
	}

	@override
	Widget build(BuildContext context) {
		ScrollController horizontalMarkdown = ScrollController();
		return Container(
			decoration: BoxDecoration(
				color: dMode ?
					Theme.of(context).colorScheme.background.aae(context, lessOpt) :
					Theme.of(context).colorScheme.onBackground.aae(context, lessOpt),
				borderRadius: BorderRadius.circular(radius)
			),
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

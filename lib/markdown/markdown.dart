import 'package:ekko/backend/ccb.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/gruvbox-dark.dart';


class MarkdownWidget extends StatelessWidget {
	final String content;
	final double radius;
	final double height;
	const MarkdownWidget({
		super.key,
		required this.content,
		this.radius = 5,
		this.height = 0.0
	});

	/* Strings */
	String _content(){
		return content
			.substring(3, content.length - 3);
	}
	String _langName() {
		return _content().substring(
			0, _content().indexOf("\n")
		).trim();
	}
	String _markdownData(){
		return _content()
			.replaceRange(0, _content().indexOf("\n") + 1, "");
	}

	/* Markdown Contexts */
	HighlightView highlightView(){
		return HighlightView(
			_markdownData(),
			language: _langName(),
			tabSize: 2,
			theme: gruvboxDarkTheme,
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
				color: Theme.of(context).colorScheme.background,
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
							text: _langName().title(),
							style: const TextStyle(
								fontWeight: FontWeight.w600,
								letterSpacing: 0.2
							)
						)
					),
					Container(
						margin: const EdgeInsets.all(2),
						width: 34, height: 34,
						child: IconButton(
							icon: ValueListenableBuilder(
								valueListenable: onCopyNotifier,
								builder: (_, onCopy, __) => Icon(
									onCopy ? Icons.check : Icons.copy,
									color: onCopy ? Colors.green : Colors.white,
									size: 17,
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

	Widget markdown(BuildContext context){
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.all(10),
			decoration: BoxDecoration(
				color: highlightView().getBG(),
				borderRadius: BorderRadius.only(
					topLeft: Radius.zero,
					topRight: Radius.zero,
					bottomLeft: Radius.circular(radius),
					bottomRight: Radius.circular(radius)
				)
			),
			child: Text.rich(highlightView().getSpan(
				style: markdownStyle())),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: const EdgeInsets.all(0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					header(context),
					markdown(context),
				],
			),
		);
	}
}
import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/database/latex_temp_db.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ekko/utils/calc.dart';
import 'dart:io';


class InlineLatex extends InlineModule {
	InlineLatex(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){

		TextStyle ds = Provider.of<ProviderManager>(gOpt.context).defaultStyle;
		double defaultHeight = calcTextSize(gOpt.context, " ", ds).height;
		bool isInline = txt.substring(0, 2).replaceAll("\$", "").isNotEmpty;
		TempDB tdb = TempDB();
		FilterQuality filter = FilterQuality.medium;
		// FilterQuality filter = isDesktop() ? FilterQuality.medium : FilterQuality.medium;

		return WidgetSpan(
			child: FutureBuilder<String?>(
				future: tdb.getLatex(txt, true),
				builder: (BuildContext context, AsyncSnapshot<String?> snap){
					if(snap.hasData){
						if(snap.data != null){
							if(isInline){
								// return SizedBox(
								// 	height: defaultHeight - (28 * defaultHeight / 100),
								// 	child: Image.file(File(snap.data!), filterQuality: filter)
								// );
								return SizedBox(
									// height: defaultHeight - (28 * defaultHeight / 100) + 20,
									height: defaultHeight - (28 * defaultHeight / 100),
									// height: defaultHeight,
									// width: 20,
									// width: 20,
									// width: calcTextSize(context, txt, ds).width / 2,
									child: Image.file(File(snap.data!), filterQuality: filter)
								);
								// return FittedBox(
								// 	// fit: BoxFit.fitHeight,
								// 	// fit: BoxFit.contain,
								// 	child: Image.file(File(snap.data!), filterQuality: filter)
								// );
							}
							return Center(child: Image.file(File(snap.data!), filterQuality: filter));
						}
						return const SizedBox();
					}
					return const SizedBox();
				}
			)
		);
	}

	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'\$\$(.|\n)*?\$\$|\$(.|\n)*?\$'),
			style: const TextStyle(color: Colors.brown),
			action: (txt, match){
				List<TextSpan> spans = [];
				txt.splitMapJoin(
					RegExp(r'^(\$\$|\$)|(\$\$|\$)$', multiLine: true),
					onMatch: (Match end){
						spans.add(TextSpan(text: end.group(0)!, style: TextStyle(color: Colors.pink[600])));
						return "";
					},
					onNonMatch: (n){
						n.splitMapJoin(
							RegExp(r'(\\(\w+|\W))|(?<=\{)\w+(?=\})'),
							onMatch: (Match word){
								String m = word.group(0)!;
								if(m.replaceAll(RegExp(r'(?<!\\|\s)\w+'), "").isEmpty){
									// spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.cyan)));
									spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.green)));
								} else {
									if(m.contains(RegExp(r'\\\W'))){
										spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.red)));
									} else {
										spans.add(TextSpan(text: m, style: const TextStyle(color: Colors.blue)));
									}
								}
								return "";
							},
							onNonMatch: (non){
								// spans.add(TextSpan(text: non, style: const TextStyle(fontStyle: FontStyle.italic)));
								spans.add(TextSpan(text: non));
								return "";
							}
						);
						return "";
					}
				);
				return TextSpan(children: spans);
			}
		);
	}
}


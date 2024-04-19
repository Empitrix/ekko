import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/latex_server.dart';
import 'package:ekko/utils/calc.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:provider/provider.dart';

class InlineLatex extends InlineModule {
	InlineLatex(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){

		double defaultHeight = calcTextSize(gOpt.context, " ", Provider.of<ProviderManager>(gOpt.context).defaultStyle).height;
		bool isInline = txt.substring(0, 2).replaceAll("\$", "").isNotEmpty;
		// debugPrint("The $txt is ${isInline ? 'inline' : 'display'}");
		return WidgetSpan(
			child: FutureBuilder<Uint8List?>(
				future: latexPngAPI(txt),
				builder: (BuildContext context, AsyncSnapshot<Uint8List?> snap){
					if(snap.hasData){
						if(snap.data != null){
							if(isInline){
								return SizedBox(
									height: defaultHeight - (28 * defaultHeight / 100),
									child: Image.memory(snap.data!, filterQuality: FilterQuality.none)
								);
							}
							return Center(child: Image.memory(snap.data!, filterQuality: FilterQuality.none));
						}
						return const SizedBox();
					}
					return const SizedBox();
				}
			)
		);
	}
}


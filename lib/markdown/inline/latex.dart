import 'dart:io';

import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/database/latex_temp_db.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ekko/utils/calc.dart';


class InlineLatex extends InlineModule {
	InlineLatex(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){

		double defaultHeight = calcTextSize(gOpt.context, " ", Provider.of<ProviderManager>(gOpt.context).defaultStyle).height;
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
								return SizedBox(
									height: defaultHeight - (28 * defaultHeight / 100),
									child: Image.file(File(snap.data!), filterQuality: filter)
								);
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
}


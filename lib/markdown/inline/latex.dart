import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/latex_server.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class InlineLatex extends InlineModule {
	InlineLatex(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return WidgetSpan(
			child: FutureBuilder<Uint8List?>(
				future: latexPngAPI(txt),
				builder: (BuildContext context, AsyncSnapshot<Uint8List?> snap){
					if(snap.hasData){
						if(snap.data != null){
							return Center(child: Image.memory(snap.data!));
							// return Image.memory(snap.data!);
						}
						return const SizedBox();
					}
					return const SizedBox();
				}
			)
		);
	}
}


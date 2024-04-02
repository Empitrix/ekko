import 'package:ekko/components/divider.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';


class InlineDivder extends InlineModule {
	InlineDivder(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return const WidgetSpan(
			child: DividerLine(height: 3, lineSide: LineSide.none)
		);
	}
}


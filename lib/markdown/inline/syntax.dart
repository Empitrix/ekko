import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class InlineSyntax extends InlineModule {
	InlineSyntax(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return TextSpan(
			children: [
				const TextSpan(text: "\n"),
				WidgetSpan(
					child: MarkdownWidget(
						content: txt,
						height: Provider
							.of<ProviderManager>(gOpt.context).defaultStyle.height!,
					)
				),
				const TextSpan(text: "\n")
			]
		);
	}
}


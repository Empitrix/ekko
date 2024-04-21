import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/markdown.dart';
import 'package:ekko/markdown/markdown_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
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

	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?'),
			style: TextStyle(
				color: settingModes['dMode'] ? Colors.cyan: Colors.indigo
			),
			action: (String txt, Match match){
				Match fM = RegExp(r'\s?```').firstMatch(txt)!;  // First Match
				Match lM = RegExp(r'```\s?').allMatches(txt).last;  // Last
				Match? nM;
				try{
					nM = RegExp(r'(?<=(?:```))\s*\w+').firstMatch(txt)!;  // Name
				} catch(_) {}
				TextStyle store = const TextStyle(
					color: Colors.purpleAccent, fontWeight: FontWeight.bold);

				List<TextSpan> spans = (nM != null) ? [
					// First Part
					TextSpan(
						text: txt.substring(fM.start, fM.end),
						style: store),
					// Name Part
					TextSpan(
						text: txt.substring(nM.start, nM.end),
						style: TextStyle(color: settingModes['dMode'] ? Colors.grey : Colors.grey[700])),
					// Content Part
					/*
					TextSpan(
						text: txt.substring(nM.end, lM.start),
						style: TextStyle(color: dMode ? Colors.cyan: Colors.indigo)),
					*/
					HighlightView(
						txt.substring(nM.end, lM.start),
						language: txt.substring(nM.start, nM.end).trim().toLowerCase(),
						tabSize: 2,
						theme: allMarkdownThemes['atom-one-${settingModes['dMode'] ? "dark" : "light"}']!,
					).getSpan(style: const TextStyle(fontFamily: "SauceCodeProNerdFont")),

					// End Part
					TextSpan(
						text: txt.substring(lM.start, lM.end),
						style: store),
				] : [
					TextSpan(text: txt)
				];
				return TextSpan(children: spans);
			}
		);
	}
}


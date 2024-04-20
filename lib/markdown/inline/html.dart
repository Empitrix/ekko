import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/html/parser.dart';
import 'package:ekko/markdown/html/rendering.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class InlineHtml extends InlineModule{
	InlineHtml(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		bool toContinue = true;
		List<HighlightRule> rls = allSyntaxRules(gOpt: gOpt).sublist(1);

		// Detect default MD format
		for(HighlightRule r in rls){
			Match? m = r.regex.firstMatch(txt);
			if(m != null){
				if(m.group(0)!.length == txt.length){
					toContinue = false;
				}
			}
		}

		if(!toContinue){
			return applyRules(
				context: gOpt.context,
				content: txt,
				keyManager: gOpt.keyManager,
				rules: allSyntaxRules(gOpt: gOpt).sublist(1),
				id: gOpt.noteId
			);
		}

		String formatted = txt;
		formatted = formatted.replaceAll("\n", "");

		formatted = formatted.replaceAll(RegExp(r'^ +', multiLine: true), "");
		formatted = formatted.replaceAll(RegExp(r'(?<!\w>)(?<!\n)\n(?!\n)'), " ");
		formatted = formatted.replaceAll(RegExp(r'< *br *(\/)?>'), "\n");




		return htmlRendering(
			content: "",
			rawInput: htmlToJson(formatted),
			style: Provider.of<ProviderManager>(gOpt.context).defaultStyle,
			opt: opt,
			gOpt: gOpt
		);

		// List<InlineSpan> spans = [];
		// spans.add(htmlSpan);
		// // spans.add(const WidgetSpan(child: SizedBox(height: 50, child: Placeholder(),)));
		// // spans.add(const WidgetSpan(child: SizedBox(height: 0, width: double.infinity)));

		// return TextSpan(children: spans);
	}




	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'( )*(<.*>\s*)+?(?=\s$|$)|<.*>.*?<\/\w+>', multiLine: true),
			style: const TextStyle(),
			action: (String txt, Match match){
				List<TextSpan> spans = [];
				txt.splitMapJoin(
					RegExp(r'''(<\w+|\w+=(".*?"|'.*?')|>|\/>|<\/\w+>)''', multiLine: true),
					onMatch: (Match m){
						String txt = m.group(0)!;
						if(txt.contains(RegExp(r'''\w+=(".*?"|'.*?')'''))){
							txt.splitMapJoin(
								RegExp(r'\='),
								onMatch: (Match e){
									spans.add(TextSpan(
										text: e.group(0)!,
										style: TextStyle(color: Theme.of(opts.context).colorScheme.inverseSurface)
									));
									return "";
								},
								onNonMatch: (String non){
									if(non.contains(RegExp('''("|')'''))){
										spans.add(TextSpan(
											text: non,
											style: const TextStyle(color: Color(0xff719E07))
										));
									} else {
										spans.add(TextSpan(
											text: non,
											style: const TextStyle(color: Color(0xff268BD2))
										));
									}
									return "";
								}
							);
						} else {
							txt.splitMapJoin(
								RegExp(r'\w+'),
								onMatch: (Match m){
									spans.add(TextSpan(
										text: m.group(0)!,
										style: const TextStyle(color: Colors.green)
									));
									return "";
								},
								onNonMatch: (n){
									spans.add(TextSpan(
										text: n,
										style: const TextStyle(color: Colors.red)
									));
									return "";
								}
							);
						}
						return "";
					},
					onNonMatch: (String n){
						spans.add(TextSpan(text: n));
						return "";
					}
				);
				return TextSpan(children: spans);
			}
		);
	}
}


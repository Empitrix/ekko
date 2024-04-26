import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';



class BackqouteObj{
	late TextSpan span;
	late Color color;

	BackqouteObj({
		required this.span,
		required this.color
	});
}

class BackqouteOptStyle{
	final String name;
	final Color color;
	final IconData icon;
	BackqouteOptStyle({
		required this.name,
		required this.color,
		required this.icon
	});
}
BackqouteOptStyle _getQouteStyle(String txt){
	List<BackqouteOptStyle> opts = [
		BackqouteOptStyle(
			name: "note",
			color: Colors.blue,
			icon: FontAwesomeIcons.circleInfo
		),
		BackqouteOptStyle(
			name: "tip",
			color: Colors.green,
			icon: FontAwesomeIcons.lightbulb
		),
		BackqouteOptStyle(
			name: "important",
			color: Colors.purple,
			icon: FontAwesomeIcons.message
		),
		BackqouteOptStyle(
			name: "warning",
			color: Colors.amber,
			icon: FontAwesomeIcons.triangleExclamation
		),
		BackqouteOptStyle(
			name: "caution",
			color: Colors.red,
			icon: FontAwesomeIcons.circleExclamation
		),
	];
	BackqouteOptStyle? style = opts.firstWhere((e) => e.name.mini() == txt.mini());
	return style;
}

BackqouteObj getBackqouteElements(BuildContext context, String input){
	List<InlineSpan> spans = <InlineSpan>[];
	BackqouteObj? obj = BackqouteObj(span: const TextSpan(), color: Colors.grey);

	// ignore: avoid_init_to_null
	Color? lineColor = null;

	for(String line in input.split("\n")){
		line = line.substring(1).trim();
		if(RegExp(r"\[\!\w+\]").allMatches(line).length == 1 && lineColor == null){
			String nameTag = line.substring(2, line.length - 1);

			bool added = false;

			for(String vtn in ["NOTE", "TIP", "IMPORTANT", "WARNING", "CAUTION"]){
				if(vtn == nameTag){
					added = true;
					BackqouteOptStyle bqStyle = _getQouteStyle(nameTag);
					spans.add(WidgetSpan(
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Icon(bqStyle.icon, color: bqStyle.color, size: 20),
								const SizedBox(width: 8),
								Text(
									bqStyle.name.title(),
									style: TextStyle(
										color: bqStyle.color,
										fontWeight: FontWeight.bold,
										letterSpacing: 0.7,
										fontSize: Provider.of<ProviderManager>(context).defaultStyle.fontSize! + 1
									),
								)
							],
						)
					));
					lineColor = bqStyle.color;
					continue;
				}
			}

			if(added){ continue; }
		}

		spans.add(
			TextSpan(
				text: line,
				style: Provider.of<ProviderManager>(context).defaultStyle
			)
		);
		spans.add(const TextSpan(text: "\n"));
	}

	try{
		obj.span = TextSpan(children: spans.sublist(0, spans.length - 1));
	} catch(_){}
	obj.color = lineColor ?? Colors.grey;
	return obj;
}



class InlineBackqoute extends InlineModule {
	InlineBackqoute(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		BackqouteObj obj = getBackqouteElements(gOpt.context, txt);
		return WidgetSpan(
			child: IntrinsicHeight(
				child: Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Container(
							width: 3.5,
							height: double.infinity,
							decoration: BoxDecoration(
								color: obj.color,
								borderRadius: BorderRadius.circular(1)
							),
						),
						const SizedBox(width: 12),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text.rich(obj.span)
								],
							)
						)
					],
				),
			)
		);
	}

	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'^>\s+.*(?:\n>\s+.*)*'),
			style: const TextStyle(),
			action: (txt, match){
				TextStyle style = const TextStyle(fontStyle: FontStyle.italic);
				List<String> lines = txt.split("\n");
				String firstLineTxt = "${lines.first}\n";
				bool firstLineHasMatch = false;

				// Not Enough
				if(lines.length == 1){
					return TextSpan(text: txt, style: style);
				}

				if(firstLineTxt.contains(RegExp(r'\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]'))){
					firstLineHasMatch = true;
				}

				List<TextSpan> spans = [];
				firstLineTxt.splitMapJoin(
					RegExp(r'\w+| +'),
					onMatch: (Match match){
						String i = match.group(0)!;
						if(i.contains(RegExp(r'(NOTE|TIP|IMPORTANT|WARNING|CAUTION)'))){
							spans.add(TextSpan(text: i, style: TextStyle(
								color: Colors.red,
								// decoration: TextDecoration.underline,
								decorationThickness: 0.5,
								fontStyle: FontStyle.italic,
								decorationColor: Theme.of(opts.context).colorScheme.inverseSurface
							)));
						}else {
							spans.add(TextSpan(text: i, style: style));
						}
						return "";
					},
					onNonMatch: (n){
					 if(n.contains(RegExp(r'\[|\]')) && firstLineHasMatch){
							spans.add(TextSpan(text: n, style: TextStyle(
								color: Colors.pink,
								decoration: TextDecoration.underline,
								decorationThickness: 0.5,
								fontWeight: FontWeight.bold,
								decorationColor: Theme.of(opts.context).colorScheme.inverseSurface
							)));
						} else {
							spans.add(TextSpan(text: n, style: style));
						}
						return "";
					}
				);
				return TextSpan(
					children: [
						TextSpan(children: spans),
						TextSpan(text: lines.sublist(1).join("\n"), style: style),
					]
				);
			},
		);
	}
}

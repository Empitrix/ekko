import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


List<InlineSpan> applyBionic(String txt, TextStyle style){
	List<InlineSpan> spans = [];

	TextStyle bionicStyle = style.copyWith(
		fontWeight: FontWeight.bold,
		color: settingModes['dMode'] ?
			const Color(0xfff3f3f3):
			const Color(0xff030303)
	);

	txt.splitMapJoin(
		RegExp(r'\w+'),
		onMatch: (Match match){
			String txt = match.group(0)!;
			int idx = (txt.length / 2).ceil();
			String before = txt.substring(0, idx);
			String after = txt.substring(idx, txt.length);

			spans.add(TextSpan(children: [
				TextSpan(text: before, style: bionicStyle),
				TextSpan(text: after, style: style),
			]));
			return "";
		},
		onNonMatch: (String non){
			spans.add(TextSpan(text: non, style: style));
			return "";
		}
	);
	return spans;
}


class PlainRenderer extends StatelessWidget {
	final String content;
	final String search;
	final int index;
	final void Function(GlobalKey) onMatchAdd;

	const PlainRenderer({super.key,
		required this.content,
		required this.search,
		required this.index,
		required this.onMatchAdd,
	});

	@override
	Widget build(BuildContext context) {
		List<InlineSpan> spans = [];
		int idx = 0;

		// Styles
		TextStyle defualtStyle = Provider.of<ProviderManager>(context).defaultStyle.copyWith(
			fontFamily: settingModes['plainFontFamily']
		);
		TextStyle matchStyle = defualtStyle.merge(
			const TextStyle(color: Colors.black, backgroundColor: Colors.amberAccent));
		TextStyle currentMatchStyle = defualtStyle.merge(
			const TextStyle(color: Colors.black, backgroundColor: Colors.deepOrange));

		if(search.trim().isEmpty){
			if(settingModes['plainBionicMode']){
				return Text.rich(TextSpan(children: applyBionic(content, defualtStyle)));
			} else {
				return Text(content, style: defualtStyle);
			}
		}


		content.splitMapJoin(
			RegExp.escape(search),
			onMatch: (Match match){
				String text = match.group(0)!;
				GlobalKey k = GlobalKey();
				if(idx == index){
					spans.add(WidgetSpan(
						child: Text.rich(
							TextSpan(text: text, style: currentMatchStyle),
							key: k,
						)
					));
				} else {
					spans.add(WidgetSpan(
						child: Text.rich(
							TextSpan(text: text, style: matchStyle),
							key: k,
						)
					));
				}
				if(text.trim().isNotEmpty){
					onMatchAdd(k);
					idx++;
				}
				return "";
			},
			onNonMatch: (String non){
				if(settingModes['plainBionicMode']){
					spans.add(TextSpan(children: applyBionic(non, defualtStyle)));
				} else {
					spans.add(TextSpan(text: non, style: defualtStyle));
				}
				return "";
			}
		);

		return Text.rich(TextSpan(children: spans));
		// return SelectableText.rich(TextSpan(children: spans));
	}
}


import 'package:ekko/config/manager.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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

		if(search.trim().isEmpty){ return Text(content, style: defualtStyle); }

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
				spans.add(TextSpan(text: non, style: defualtStyle));
				return "";
			}
		);

		return Text.rich(TextSpan(children: spans));
		// return SelectableText.rich(TextSpan(children: spans));
	}
}


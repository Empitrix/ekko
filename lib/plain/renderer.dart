import 'package:ekko/config/manager.dart';
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
		TextStyle defualtStyle = Provider.of<ProviderManager>(context).defaultStyle;
		TextStyle matchStyle = defualtStyle.merge(
			const TextStyle(color: Colors.black, backgroundColor: Colors.amber));
		TextStyle currentMatchStyle = defualtStyle.merge(
			const TextStyle(color: Colors.black, backgroundColor: Colors.orange));

		if(search.trim().isEmpty){ return Text(content, style: defualtStyle); }

		content.splitMapJoin(
			RegExp.escape(search),
			onMatch: (Match match){
				GlobalKey k = GlobalKey();
				if(idx == index){
					spans.add(WidgetSpan(
						child: Text.rich(
							TextSpan(text: match.group(0)!, style: currentMatchStyle),
							key: k,
						)
					));
				} else {
					spans.add(WidgetSpan(
						child: Text.rich(
							TextSpan(text: match.group(0)!, style: matchStyle),
							key: k,
						)
					));
					// spans.add(TextSpan(text: match.group(0)!, style: matchStyle));
				}
				if(match.group(0)!.trim().isNotEmpty){
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
	}
}


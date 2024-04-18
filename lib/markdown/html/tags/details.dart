import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/nf_icons.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/html/rendering.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


InlineSpan htmlRawDetails({
	required Map raw,
	required RuleOption opt,
	required GeneralOption gOpt,
	required String content,
	required TextStyle style
}){

	List<InlineSpan> children = [];
	String summaryText = "";
	if(raw['children'] != null){
		for(Map itm in raw['children']){
			// Don't add Indentations
			if(itm['text'] != null && itm['text'].trim().isEmpty){ continue; }

			if(itm['tag'] != null){
				if(itm['tag'] == "summary" && summaryText.isEmpty){
					summaryText = (itm['children']).firstWhere((e) => e['text'] != null)['text'].trim() ?? "";
				} else {
					children.add(htmlRendering(
						content: content,
						opt: opt,
						gOpt: gOpt,
						rawInput: itm,
						style: style
					));
				}
			} else {
				children.add(formattingTexts(content: itm['text'].trim() ?? "", gOpt: gOpt));
			}
		}
	}

	ValueNotifier<bool> isOpenNotifier = ValueNotifier<bool>(false);

	return WidgetSpan(child: ValueListenableBuilder(
		valueListenable: isOpenNotifier,
		builder: (context, value, child){
			return Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					GestureDetector(
						onTap: (){ isOpenNotifier.value = !isOpenNotifier.value; },
						child: Row(
							children: [
								Transform.rotate(
									angle: getAngle(isOpenNotifier.value ? 180 : 90),
									child: NfFont(
										unicode: "\udb81\udd36", size: 12,
										color: Theme.of(context).colorScheme.inverseSurface).widget(),
								),
								const SizedBox(width: 6),
								Text.rich(TextSpan(
									text: summaryText,
									mouseCursor: SystemMouseCursors.click,
									style: Provider.of<ProviderManager>(gOpt.context).defaultStyle
								)),
							],
						),
					),
					const SizedBox(height: 4),
					if(isOpenNotifier.value) Text.rich(TextSpan(children: children))
				],
			);
		}
	));
}


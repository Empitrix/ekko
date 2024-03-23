/* Italic - Strike - Bold - Italic & Bold (BOTh) */
import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class InlineIBB extends InlineModule{
	InlineIBB(super.opt, super.gOpt);
	@override
	InlineSpan span(String txt){
		int specialChar = RegExp('\\${txt.substring(0, 1)}').allMatches(txt).length;
		if(specialChar % 2 != 0){ specialChar--; }
		specialChar = specialChar ~/ 2;

		TextStyle currentStyle = 
				specialChar == 3 ? const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic):
				specialChar == 2 ? const TextStyle(fontWeight: FontWeight.bold):
				const TextStyle(fontStyle: FontStyle.italic);

		currentStyle = currentStyle.merge(opt.forceStyle);

		// Update Size
		if(currentStyle.fontSize == null){
			currentStyle = currentStyle.copyWith(
				fontSize: Provider.of<ProviderManager>(gOpt.context).defaultStyle.fontSize
			);
		}

		List<InlineSpan> spans = [];
		txt.substring(specialChar, txt.length - specialChar).splitMapJoin(
			RegExp(r'(\*|\_).*?(\*|\_)'),
			onMatch: (Match match){
				String text = match.group(0)!;
				spans.add(TextSpan(
					text: text.substring(1, text.length - 1),
					recognizer: opt.recognizer,
					style: currentStyle.merge(const TextStyle(fontStyle: FontStyle.italic))
				));
				return "";
			},
			onNonMatch: (non){
				spans.add(TextSpan(
					text: non,
					recognizer: opt.recognizer,
					style: currentStyle,
				));
				return "";
			}
		);

		return TextSpan(children: spans);
	}
}



class InlineStrike extends InlineModule {
	InlineStrike(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		return TextSpan(
			text: txt.substring(2, txt.length - 2),
			recognizer: opt.recognizer,
			style: TextStyle(
				fontSize: 16,
				decorationColor: Theme.of(gOpt.context).colorScheme.inverseSurface,
				decorationStyle: TextDecorationStyle.solid,
				decoration: TextDecoration.lineThrough
			)
		);
	}
}


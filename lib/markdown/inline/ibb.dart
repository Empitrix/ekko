/* Italic - Strike - Bold - Italic & Bold (BOTh) */
import 'package:awesome_text_field/awesome_text_field.dart';
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



	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'(\*\*\*|\_\_\_).*?(\*\*\*|\_\_\_)|(\*\*|\_\_).*?(\*\*|\_\_)|(\*|\_).*?(\*|\_)'),
			style: const TextStyle(),
			action: (txt, match){
				int specialChar = RegExp(r'(\*|\_)').allMatches(txt).length;
				if(specialChar % 2 != 0){ specialChar--; }
				specialChar = specialChar ~/ 2;
				const TextStyle asteriskStyle = TextStyle(
					color: Colors.deepOrange, fontWeight: FontWeight.w500);
				// Get plain text style
				TextStyle plainStyle = 
					specialChar == 3 ? const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic):
					specialChar == 2 ? const TextStyle(fontWeight: FontWeight.bold):
					const TextStyle(fontStyle: FontStyle.italic);
				return TextSpan(
					children: [
						TextSpan(
							text: txt.substring(0, specialChar),
							style: asteriskStyle),
						TextSpan(
							text: txt.substring(specialChar, txt.length - specialChar),
							style: plainStyle),
						TextSpan(
							text: txt.substring(txt.length - specialChar),
							style: asteriskStyle),
					]
				);
			},
		);
	}
}

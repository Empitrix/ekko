import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/markdown/tools/key_manager.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


TextSpan formattingTexts({
	required BuildContext context,
	required String content,
	required Map variables,
	required int id,
	required GlobalKeyManager keyManager,
	required Function hotRefresh,
	TextStyle? forceStyle,
	TapGestureRecognizer? recognizer}){
	// using this function in rules list prevent to 'over-flow' error

	TextSpan applied = applyRules(
		context: context,
		content: content,
		id: id,
		recognizer: recognizer,
		keyManager: keyManager,
		forceStyle: forceStyle,
		rules: allSyntaxRules(
			context: context, variables: variables,
			noteId: id, hotRefresh: hotRefresh,
			keyManager: keyManager)
	);

	// print(applied.children?.length);

	return applied;
}


TextSpan endLineChar(){
	return const TextSpan(
		text: "\u000A",
		style: TextStyle(color: Colors.red, fontSize: 1)
	);
}


TextStyle getHeadlineStyle(BuildContext ctx, int idx){
	idx = idx - 1;
	return <TextStyle>[
		// 1
		TextStyle(
			color: Theme.of(ctx).colorScheme.inverseSurface,
			fontWeight: FontWeight.w600,
			letterSpacing: 0.9,
			height: 1.2,
			fontSize: 32
		),
		// 2
		TextStyle(
			color: Theme.of(ctx).colorScheme.inverseSurface,
			fontWeight: FontWeight.bold,
			letterSpacing: 0.9,
			fontSize: 24
		),
		// 3
		TextStyle(
			color: Theme.of(ctx).colorScheme.inverseSurface,
			fontWeight: FontWeight.w400,
			fontSize: 20
		),
		// 4
		TextStyle(
			color: Theme.of(ctx).colorScheme.inverseSurface,
			fontWeight: FontWeight.w300,
			fontSize: 16
		),
		// 5
		TextStyle(
			color: Theme.of(ctx).colorScheme.inverseSurface,
			fontWeight: FontWeight.w200,
			fontSize: 14
		),
		// 6
		TextStyle(
			color: Theme.of(ctx).colorScheme.inverseSurface,
			fontWeight: FontWeight.w100,
			fontSize: 13.6
		)
	][idx];
}



TextSpan ibbFormatting(String txt, RuleOption opt, [TextStyle? forceStyle]){
	/*Formatting for [ITALIC - BOLD - ITALIC & BOLD] (i)talic (b)bold (b)oth*/
	int specialChar = RegExp('\\${txt.substring(0, 1)}').allMatches(txt).length;
	if(specialChar % 2 != 0){ specialChar--; }
	specialChar = specialChar ~/ 2;

	TextStyle currentStyle = 
			specialChar == 3 ? const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic):
			specialChar == 2 ? const TextStyle(fontWeight: FontWeight.bold):
			const TextStyle(fontStyle: FontStyle.italic);

	currentStyle = currentStyle.merge(opt.forceStyle);
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

	// return TextSpan(
	// 	text: txt.substring(specialChar, txt.length - specialChar),
	// 	recognizer: opt.recognizer,
	// 	style: currentStyle
	// );
}


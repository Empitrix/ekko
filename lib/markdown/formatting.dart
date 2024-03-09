import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/markdown/tools/key_manager.dart';
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
	// bool fromHTML = false,
	// HTMLParser? htmlParser,
	TapGestureRecognizer? recognizer}){
	// using this function in rules list prevent to 'over-flow' error


	// content.splitMapJoin(
	// 	RegExp(r'<(\w+)(.*?)>([^<\1][\s\S]*?)?<\/\s*\1\s*>|<(\w+)[^>]*\s*\/?>'),
	// 	onMatch: (Match m){
	// 		print(m.group(0)!);
	// 		return "";
	// 	},
	// 	onNonMatch: (n){
	// 		// print(n);
	// 		return "";
	// 	}
	// );


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

	return applied;

	// if(htmlParser != null){
	// 	return htmlFormatting(
	// 		context: context,
	// 		content: content,
	// 		variables: variables,
	// 		forceStyle: forceStyle,
	// 		recognizer: recognizer,
	// 		htmlParser: htmlParser,
	// 		id: id,
	// 		hotRefresh: hotRefresh);
	// } else {
	// 	return applied;
	// }
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


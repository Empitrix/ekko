import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


TextSpan formattingTexts({
	required String content,
	required GeneralOption gOpt,
	TextStyle? forceStyle,
	TapGestureRecognizer? recognizer}){

	TextSpan applied = applyRules(
		context: gOpt.context,
		content: content,
		id: gOpt.noteId,
		recognizer: recognizer,
		keyManager: gOpt.keyManager,
		forceStyle: forceStyle,
		rules: allSyntaxRules(gOpt: gOpt)
	);

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


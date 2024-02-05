import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


TextSpan formattingTexts({
	required BuildContext context,
	required String content,
	required Map variables,
	TextStyle? mergeStyle,
	TapGestureRecognizer? recognizer}){
	// using this function in rules list prevent to 'over-flow' error
	// return <TextSpan>[
	return applyRules(
		context: context,
		content: content,
		recognizer: recognizer,
		rules: allSyntaxRules(context, variables)
	);

	// if(a[0].style != null){
	// 	a[0].style!.merge(mergeStyle);
	// } else {
	// 	a[0].style = mergeStyle;
	// }

	// return [TextSpan(children: [...a], style: mergeStyle, recognizer: recognizer)];
	// return a;
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

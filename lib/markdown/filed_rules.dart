import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/markdown/inline/backqoute.dart';
import 'package:ekko/markdown/inline/bullet_num.dart';
import 'package:ekko/markdown/inline/checkbox.dart';
import 'package:ekko/markdown/inline/divider.dart';
import 'package:ekko/markdown/inline/emoji.dart';
import 'package:ekko/markdown/inline/headerline.dart';
import 'package:ekko/markdown/inline/headlines.dart';
import 'package:ekko/markdown/inline/html.dart';
import 'package:ekko/markdown/inline/ibb.dart';
import 'package:ekko/markdown/inline/image.dart';
import 'package:ekko/markdown/inline/item.dart';
import 'package:ekko/markdown/inline/latex.dart';
import 'package:ekko/markdown/inline/links.dart';
import 'package:ekko/markdown/inline/monospace.dart';
import 'package:ekko/markdown/inline/strike.dart';
import 'package:ekko/markdown/inline/syntax.dart';
import 'package:ekko/markdown/inline/table.dart';
import 'package:ekko/markdown/inline/url.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:flutter/material.dart';


List<RegexFormattingStyle> allFieldRules(BuildContext context){

	TextStyle reApplyStyle = Theme.of(context).primaryTextTheme.bodyLarge!.copyWith(
		color: Theme.of(context).colorScheme.inverseSurface,
		fontFamily: "RobotoMono"
	);
	ReApplyFieldRules reApply = ReApplyFieldRules(context: context, style: reApplyStyle);

	HighlightOption opts = HighlightOption(context: context, reApply: reApply);


	return List<RegexFormattingStyle>.from(<RegexFormattingStyle?>[
		// {@Syntax}
		InlineSyntax.highlight(opts),
		// {@HTML}
		InlineHtml.highlight(opts),
		// {@Headline}
		InlineHeadline.highlight(opts),
		// {@Header Line}
		InlineHeaderLine.highlight(opts),
		// {@Divider}
		InlineDivder.highlight(opts),
		// {@Bulleted Item}
		InlineBulletNum.highlight(opts),
		// {@CheckBox}
		InlineCheckbox.highlight(opts),
		// {@Item}
		InlineItem.highlight(opts),
		// {@Table}
		InlineTable.highlight(opts),
		// {@Hyper-Link}
		InlineLink.highlight(opts),
		// {@Image-Link}
		InlineImage.highlight(opts),
		// {@Monospace}
		InlineMonospace.highlight(opts),
		// {@Latex}
		InlineLatex.highlight(opts),
		// {@URL}
		InlineURL.highlight(opts),
		// {@Italic-Bold-Italic&Bold}
		InlineIBB.highlight(opts),
		// {@Strike}
		InlineStrike.highlight(opts),
		// {@Backqoute}
		InlineBackqoute.highlight(opts),
		// {@Emoji}
		InlineEmoji.highlight(opts),
		// etc..

	].where((s){ return s != null;}));
}



class ReApplyFieldRules {
	final BuildContext context;
	final TextStyle style;
	ReApplyFieldRules({required this.context, required this.style});

	TextSpan parse(String input){
		return ApplyRegexFormattingStyle(
			content: input,
			rules: allFieldRules(context),
			textStyle: style
		).build();
	}
}


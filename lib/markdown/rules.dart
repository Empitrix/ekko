import 'package:ekko/markdown/inline/backqoute.dart';
import 'package:ekko/markdown/inline/checkbox.dart';
import 'package:ekko/markdown/inline/divider.dart';
import 'package:ekko/markdown/inline/emoji.dart';
import 'package:ekko/markdown/inline/headlines.dart';
import 'package:ekko/markdown/inline/html.dart';
import 'package:ekko/markdown/inline/image.dart';
import 'package:ekko/markdown/inline/isbb.dart';
import 'package:ekko/markdown/inline/item.dart';
import 'package:ekko/markdown/inline/links.dart';
import 'package:ekko/markdown/inline/monospace.dart';
import 'package:ekko/markdown/inline/syntax.dart';
import 'package:ekko/markdown/inline/table.dart';
import 'package:ekko/markdown/inline/url.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/models/rule.dart';

int lastIndent = 0;
int indentStep = 0;


List<HighlightRule> allSyntaxRules({required GeneralOption gOpt}){
	List<HighlightRule> rules = [
		// {@HTML}
		HighlightRule(
			label: "html",
			regex: RegExp(r'( )*(<.*>\s*)+?(?=\s$|$)|<.*>.*?<\/\w+>', multiLine: true),
			action: (txt, opt) => InlineHtml(opt, gOpt).span(txt)
		),

		// {@Syntax}
		HighlightRule(
			label: "markdown",
			regex: RegExp(r'\s?```([\s\S]*?)\n\s*```\s?', multiLine: true),
			action: (txt, opt) => InlineSyntax(opt, gOpt).span(txt),
		),

		// {@Headlines}
		HighlightRule(
			label: "headline",
			regex: RegExp(r"^#{1,6} [\s\S]*?$\s*"),
			action: (txt, opt) => InlineHeadline(opt, gOpt).span(txt)
		),

		// {@Divider}
		HighlightRule(
			label: "divider",
			regex: RegExp(r'^(\-\-\-|\+\+\+|\*\*\*)$'),
			trimNext: true,
			action: (_, __) => InlineDivder(__, gOpt).span(_),
		),

		// {@Checkbox}
		HighlightRule(
			label: "checkbox",
			regex: RegExp(r'^(-|\+|\*)\s{1}(\[ \]|\[x\])\s+(.*)$', multiLine: true),
			action: (txt, opt) => InlineCheckbox(opt, gOpt).span(txt)
		),

		// {@Item}
		HighlightRule(
			label: "item",
			regex: RegExp(r'^\s*(-|\+|\*)\s+.+$'),
			action: (txt, opt) => InlineItem(opt, gOpt).span(txt)
		),

		// {@Table}
		HighlightRule(
			label: "table",
			regex: RegExp(r'^( *?(?!semi)\|.*\|\s?)+'),
			action: (txt, opt) => InlineTable(opt, gOpt).span(txt),
		),

		// {@Hyper-Link}
		HighlightRule(
			label: "links",
			regex: RegExp(r'(?<!\!)\[((?:\[[^\]]*\]|[^\[\]])*)\]\(([\s\S]*?)\)|\[((?:\[[^\]]*\]|[^\[\]])*)\]\[([^\]]+)\]'),
			action: (txt, opt) => InlineLink(opt, gOpt).span(txt)
		),

		// {@Image-Link}
		HighlightRule(
			label: "link_image",
			regex: RegExp(r'\!\[([\s\S]*?)\](\(|\[)([\s\S]*?)(\)|\])'),
			action: (txt, opt) => InlineImage(opt, gOpt).span(txt),
		),

		// {@Monospace}
		HighlightRule(
			label: "monospace",
			regex: RegExp(r'\`(.|\n)*?\`', multiLine: false),
			action: (txt, opt) => InlineMonospace(opt, gOpt).span(txt),
		),

		// {@URL}
		HighlightRule(
			label: "url",
			regex: RegExp(r'(https\:|http\:|www)(\/\/|\.)([A-Za-z0-9@:%\.\_\+\~\#\=\/\?\-\&]*)'),
			action: (txt, opt) => InlineURL(opt, gOpt).span(txt)
		),

		// {@Italic-Bold, Bold, Italic}
		HighlightRule(
			label: "italic&bold_bold_italic",
			regex: RegExp(r'(\*\*\*|\_\_\_).*?(\*\*\*|\_\_\_)|(\*\*|\_\_).*?(\*\*|\_\_)|(\*|\_).*?(\*|\_)'),
			action: (txt, opt) => InlineIBB(opt, gOpt).span(txt),
		),
		
		// {@Straight}
		HighlightRule(
			label: "strike",
			regex: RegExp(r'~~.*~~'),
			action: (txt, opt) => InlineStrike(opt, gOpt).span(txt),
		),

		// {@Backqoute}
		HighlightRule(
			label: "backqoute",
			regex: RegExp(r'^>\s+.*(?:\n>\s+.*)*'),
			action: (txt, opt) => InlineBackqoute(opt, gOpt).span(txt)
		),

		// {@Emojies}
		HighlightRule(
			label: "emojies",
			regex: RegExp(r'\:\w+\:'),
			action: (txt, opt) => InlineEmoji(opt, gOpt).span(txt)
		),
		// etc..

	];

	return rules;
}


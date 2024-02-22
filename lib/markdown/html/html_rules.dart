import 'package:ekko/backend/backend.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/html/html_formatting.dart';
import 'package:ekko/markdown/html/html_parser.dart';
import 'package:ekko/markdown/html/html_utils.dart';
import 'package:ekko/markdown/image.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/models/html_rule.dart';
import 'package:flutter/material.dart';


List<HtmlHighlightRule> allHtmlRules(BuildContext context, Map variables, int noteId, Function hotRefresh, TextStyle? forceStyle){
	return [

		// {@Headlines}
		HtmlHighlightRule(
			label: "headlines",
			tag: HTMLTag.h1,
			action: (txt, opt){
				opt.forceStyle = getHeadlineStyle(context, 1);
				return WidgetSpan(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text.rich(htmlFormatting(
								context: context,
								content: txt,
								variables: variables,
								id: noteId,
								hotRefresh: hotRefresh,
								option: opt
							)),
							const Divider()
						],
					)
				);
				// return const TextSpan();
			},
		),
		
		// @{a-TAG}
		HtmlHighlightRule(
			label: "a",
			tag: HTMLTag.a,
			action: (_, opt){
				// print(opt.forceStyle!.color);

				opt.forceStyle = opt.forceStyle!.merge(const TextStyle(color: Colors.red));
				opt.recognizer = useLinkRecognizer(context, opt.data.attributes['href'] ?? "");

				return htmlFormatting(
					context: context,
					content: _,
					variables: variables,
					id: noteId,
					hotRefresh: hotRefresh,
					option: opt
				);
			},
		),

		HtmlHighlightRule(
			label: "paragraph",
			tag: HTMLTag.p,
			action: (txt, opt){
				return WidgetSpan(
					child: ApplyHtmlAlignment(
						alignment: getHtmlAlignment(
							opt.data.attributes['align'] ?? ""),
						children: [
							Text.rich(htmlFormatting(
								context: context,
								content: txt,
								variables: variables,
								id: noteId,
								hotRefresh: hotRefresh,
								option: opt
							))
						],
					)
				);
			}
		),


		HtmlHighlightRule(
			label: "img",
			tag: HTMLTag.img,
			action: (_, opt){
				// Wrong image
				if(opt.data.attributes["src"] == null){
					return htmlFormatting(
						context: context,
						content: _,
						variables: variables,
						id: noteId,
						hotRefresh: hotRefresh,
						option: opt
					);
				}
				// Get image format
				String link = opt.data.attributes["src"]!.trim();
				String format = link.substring(link.lastIndexOf(".") + 1);
				format = format.split("?")[0];
				format = vStr(format);

				// get image parser
				Map<String, dynamic> imgData = {
					"name": opt.data.attributes["alt"] ?? "",
					"url": opt.data.attributes["src"],
					"format": format == "svg" ? ImageType.svg : ImageType.picture
				};

				// sizes if they are exsits
				String? width = opt.data.attributes["width"];
				String? height = opt.data.attributes["height"];

				return WidgetSpan(child: SizedBox(
					width: width != null ? int.parse(width).toDouble() : null,
					height: height != null ? int.parse(height).toDouble() : null,
					child: Text.rich(showImageFrame("", opt.recognizer, variables, imgData)),
				));
			},
		),

		// etc..


	];
}

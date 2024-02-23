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
				opt.forceStyle = getHeadlineStyle(context, 1).merge(opt.forceStyle);
				return WidgetSpan(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							opt.data.attributes['align'] == null ?
							Text.rich(htmlFormatting(
								context: context,
								content: txt,
								variables: variables,
								id: noteId,
								hotRefresh: hotRefresh,
								option: opt
							)):
							ApplyHtmlAlignment(
								alignment: getHtmlAlignment(
									opt.data.attributes['align']!),
								children: [
									Text.rich(htmlFormatting(
										context: context,
										content: txt.trim(),  // IDK about triming
										variables: variables,
										id: noteId,
										hotRefresh: hotRefresh,
										option: opt
									))
								],
							),
							const Divider()
						],
					)
				);
			},
		),
		
		// @{a-TAG}
		HtmlHighlightRule(
			label: "a",
			tag: HTMLTag.a,
			action: (txt, opt){
				// Update font and style
				opt.forceStyle = const TextStyle(
					color: Colors.blue,
					decoration: TextDecoration.underline,
					decorationColor: Colors.blue).merge(opt.forceStyle);
				opt.recognizer = useLinkRecognizer(
					context, opt.data.attributes['href'] ?? "");

				// debugPrint("\n\n\nA-TAG detected: ${txt.replaceAll('\n', ' ')} -> ${opt.recognizer}");
				return htmlFormatting(
					context: context,
					content: txt,
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


		// {@Picture}
		HtmlHighlightRule(
			label: "picture",
			tag: HTMLTag.picture,
			action: (txt, opt){
				debugPrint("PICTURE DETECTED");
				return TextSpan(
					text: txt.trim(),
					style: opt.forceStyle,
					recognizer: opt.recognizer);
			}
		),

		// {@Source}
		HtmlHighlightRule(
			label: "source",
			tag: HTMLTag.source,
			action: (txt, opt){
				debugPrint("SOURCE DETECTED");
				return TextSpan(
					text: txt,
					style: opt.forceStyle,
					recognizer: opt.recognizer);
			}
		),

		// etc..


	];
}

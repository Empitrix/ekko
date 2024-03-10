import 'package:ekko/backend/backend.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/html/html_formatting.dart';
import 'package:ekko/markdown/html/html_parser.dart';
import 'package:ekko/markdown/html/html_utils.dart';
import 'package:ekko/markdown/image.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/markdown/tools/key_manager.dart';
import 'package:ekko/models/html_rule.dart';
import 'package:flutter/material.dart';


List<HtmlHighlightRule> allHtmlRules({
	required BuildContext context,
	required Map variables,
	required GlobalKeyManager keyManager,
	required int noteId,
	required Function hotRefresh,
	required TextStyle? forceStyle
}){
	return [

		// {@Headlines}
		HtmlHighlightRule(
			label: "headlines",
			tag: HTMLTag.h1,
			action: (txt, opt){
				// opt.forceStyle = getHeadlineStyle(context, 1).merge(opt.forceStyle);
				// opt.forceStyle = opt.forceStyle!.merge(getHeadlineStyle(context, 1));
				opt.forceStyle = getHeadlineStyle(context, 1).merge(opt.forceStyle);
				// debugPrint(">$txt<");
				return WidgetSpan(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							opt.data.attributes['align'] == null ?
							Text.rich(htmlFormatting(
								context: context,
								content: txt,
								keyManager: keyManager,
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
										keyManager: keyManager,
										hotRefresh: hotRefresh,
										option: opt
									))
								],
							),
							const Divider(),
							// const DividerLine(lineSide: LineSide.both)
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
					context, opt.data.attributes['href'] ?? "", keyManager);

				// debugPrint("\n\n\nA-TAG detected: ${txt.replaceAll('\n', ' ')} -> ${opt.recognizer}");
				return htmlFormatting(
					context: context,
					keyManager: keyManager,
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
								keyManager: keyManager,
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
				// print(opt.data.attributes);
				// Wrong image
				if(opt.data.attributes["src"] == null){
					return htmlFormatting(
						context: context,
						keyManager: keyManager,
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

				// String? width = opt.data.attributes["width"];
				// String? height = opt.data.attributes["height"];
				double? w = getHtmlSize(context, opt.data.attributes["width"], "w");
				double? h = getHtmlSize(context, opt.data.attributes["height"], "h");

				return WidgetSpan(child: SizedBox(
					// width: width != null ? int.parse(width).toDouble() : null,
					// height: height != null ? int.parse(height).toDouble() : null,
					width: w,
					height: h,
					// child: Text.rich(showImageFrame("", opt.recognizer, variables, imgData)),
					child: FittedBox(
						child: Text.rich(showImageFrame("", opt.recognizer, variables, imgData)),
					),
				));
			},
		),


		// {@Picture}
		HtmlHighlightRule(
			label: "picture",
			tag: HTMLTag.picture,
			action: (txt, opt){
				// debugPrint("PICTURE DETECTED");
				return htmlFormatting(
					context: context,
					content: txt,
					keyManager: keyManager,
					variables: variables,
					id: noteId,
					hotRefresh: hotRefresh,
					option: opt
				);
				// return TextSpan(
				// 	text: txt.trim(),
				// 	style: opt.forceStyle,
				// 	recognizer: opt.recognizer);
			}
		),

		// {@Source}
		HtmlHighlightRule(
			label: "source",
			tag: HTMLTag.source,
			action: (txt, opt){
				// debugPrint("SOURCE DETECTED: $txt");
				return const WidgetSpan(child: SizedBox());
				// return TextSpan(
				// 	text: txt,
				// 	style: opt.forceStyle,
				// 	recognizer: opt.recognizer);
			}
		),

		// {@Div}
		HtmlHighlightRule(
			label: "div",
			tag: HTMLTag.div,
			action: (txt, opt){
				// print(txt);
				return WidgetSpan(
					child: ApplyHtmlAlignment(
						alignment: getHtmlAlignment(
							opt.data.attributes['align']!),
						children: [
							Text.rich(htmlFormatting(
								context: context,
								keyManager: keyManager,
								content: txt.trim(),  // IDK about triming
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

		// {@U-underscore}
		HtmlHighlightRule(
			label: "u",
			tag: HTMLTag.u,
			action: (txt, opt){
				// // print("U: $txt");

				opt.forceStyle = TextStyle(
					decoration: TextDecoration.underline,
					decorationColor:
						opt.forceStyle!.decorationColor ??
						(dMode ? Colors.white : Colors.black)
						// Theme.of(context).colorScheme.inverseSurface.withOpacity(1)
				).merge(opt.forceStyle);

				return htmlFormatting(
					context: context,
					keyManager: keyManager,
					content: txt.trim(),  // IDK about triming
					variables: variables,
					id: noteId,
					hotRefresh: hotRefresh,
					option: opt
				);
			}
		),
		// etc..


	];
}

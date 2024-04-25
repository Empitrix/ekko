import 'package:ekko/backend/extensions.dart';
import 'package:ekko/markdown/html/tools.dart';
import 'package:ekko/markdown/image/frame_builder.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';

InlineSpan htmlRawImg(Map raw, RuleOption opt, GeneralOption gOpt, [caller = "src"]){
	if(raw['attributes'][caller] == null){ return const TextSpan(); }

	String link = raw['attributes'][caller]!.trim();
	String format = link.substring(link.lastIndexOf(".") + 1);
	format = format.split("?")[0].mini();

	// get image parser
	Map<String, dynamic> imgData = {
		"name": raw['attributes']["alt"] ?? "",
		"url": link,
		"format": format == "svg" ? ImageType.svg : ImageType.picture
	};

	double? w = getHtmlSize(gOpt.context, raw['attributes']["width"], "w");
	double? h = getHtmlSize(gOpt.context, raw['attributes']["height"], "h");

	return WidgetSpan(child: SizedBox(
		width: w,
		height: h,
		child: FittedBox(
			child: Text.rich(showImageFrame("", opt.recognizer, gOpt.variables, imgData)),
		),
	));
}


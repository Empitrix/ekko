import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/models/enums.dart';
import 'package:ekko/theme/colors.dart';
import 'package:flutter/material.dart';



List<String> breakPhrase(String input){
	List<String> words = [];
	RegExp regex = RegExp(r"\s*[^\s]+\s*");
	input.splitMapJoin(
		regex,
		onMatch: (match){
			String txt = match.group(0)!;
			words.add(txt);
			return txt;
		},
		onNonMatch: (txt){
			if(txt == ""){ return ""; }
			words.add(txt);
			return txt;
		}
	);
	return words;
}



class InlineMonospace extends InlineModule {
	InlineMonospace(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		txt = txt.replaceAll("\n", ' ');
		txt = txt.substring(1, txt.length - 1);

		double radius = 5;
		double padding = 5;

		List<String> words = breakPhrase(txt);
		List<InlineSpan> tags = [];
		for(String w in words){
			bool isFirst = words.indexOf(w) == 0;
			bool isLast = words.indexOf(w) == words.length - 1;
			if((settingModes['renderMode'] as RenderMode) == RenderMode.fancy){
				tags.add(
					WidgetSpan(child: Container(
						padding: EdgeInsets.only(
							left: isFirst ? padding : 0,
							right: isLast ? padding : 0
						),
						margin: EdgeInsets.zero,
						decoration: BoxDecoration(
							borderRadius: BorderRadius.only(
								topLeft: Radius.circular(
									isFirst ? radius : 0),
								bottomLeft: Radius.circular(
									isFirst ? radius : 0),
								topRight: Radius.circular(
									isLast ? radius : 0),
								bottomRight: Radius.circular(
									isLast ? radius : 0)
							),
							color: getMonoBgColor()
						),
						child: Text.rich(TextSpan(
							text: w,
							style: TextStyle(
								fontFamily: "RobotoMono",
								color: opt.recognizer != null ? Colors.blue : null
							),
							recognizer: opt.recognizer
						)),
					)
				));
			} else {
				tags.add(
					TextSpan(
						text: w,
						style: TextStyle(
							fontFamily: "RobotoMono",
							// backgroundColor: getMonoBgColor().withOpacity(0.8),
							background: Paint()
								..color = getMonoBgColor().withOpacity(1.0)
								..strokeCap = StrokeCap.round
								..style = PaintingStyle.fill
								..strokeWidth = 20
								..strokeJoin = StrokeJoin.round
							,
							color: opt.recognizer != null ? Colors.blue : null
						),
						recognizer: opt.recognizer
					)
				);
			}
		}
		return TextSpan(children: [
			...tags,
		]);
	}


	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexGroupStyle(
			regex: RegExp(r'\`.*?\`'),
			style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
			regexStyle: RegexStyle(
				regex: RegExp(r'\`'),
				style: const TextStyle(
					color: Colors.orange,
				),
			)
		);
	}

}


import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parser.dart';
import 'package:ekko/utils/calc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NumWidget extends StatelessWidget {
	final int indentLvl;
	final int num;
	final String content;
	final GeneralOption gOpt;
	final int maxValue;

	const NumWidget({
		super.key,
		required this.indentLvl,
		required this.num,
		required this.content,
		required this.maxValue,
		required this.gOpt
	});

	@override
	Widget build(BuildContext context) {


		debugPrint("Max Value: $maxValue");
		TextStyle numStyle = Provider.of<ProviderManager>(gOpt.context).defaultStyle;
		numStyle = numStyle.merge(const TextStyle(fontFamily: "RobotoMono"));

		return Text.rich(WidgetSpan(
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SizedBox(
						width: calcTextSize(gOpt.context, "$maxValue.", numStyle).width,
						child: SelectionContainer.disabled(
							child: Text.rich(TextSpan(text: "$num.", style: numStyle))
						),
					),
					const SizedBox(width: 5),
					Expanded(child: Text.rich(formattingTexts(gOpt: gOpt, content: content.trim())))
				],
			)
		));

		// spans.add(formattingTexts(gOpt: gOpt, content: content));
		// return Text.rich(TextSpan(children: spans));
	}
}



List<int> __getNums(List<String> lines){
	List<int> nums = [];
	for(String l in lines){
		nums.add(int.parse(
			l.substring(afterWhiteChar(l), firstCharPos(l, "."))
		));
	}
	return nums;
}

class InlineBulletNum extends InlineModule {
	InlineBulletNum(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		List<InlineSpan> spans = [];
		List<String> lines = txt.trim().split("\n");
		List<int> nums = __getNums(lines);
		int counter = 0;
		bool useCounter = nums.length != nums.toSet().length;

		for(int i = 0; i < lines.length; i++){
			counter++;
			int iLvl = afterWhiteChar(lines[i]);
			String content = lines[i].substring(firstCharPos(lines[i], ".") + 1);
			spans.add(WidgetSpan(child: NumWidget(
				indentLvl: iLvl,
				num: useCounter ? counter : nums[i],
				maxValue: useCounter ? lines.length : nums.last,
				content: content,
				gOpt: gOpt
			)));
			spans.add(const TextSpan(
				text: "\n\n", style: TextStyle(fontSize: 0.5)));
		}

		return TextSpan(children: spans);
	}
}


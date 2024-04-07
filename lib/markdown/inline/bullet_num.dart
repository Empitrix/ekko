import 'package:ekko/config/manager.dart';
import 'package:ekko/markdown/formatting.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/parser.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/*
int __getNum(int currentNum){
	int num = 1;
	// debugPrint(lastBulletNumStatus.toString());
	if(!(lastBulletNumStatus['state'] == currentNum)){
		num = currentNum;
	} else {
		num = lastBulletNumStatus['value']! + 1;
	}
	lastBulletNumStatus['state'] = currentNum;
	lastBulletNumStatus['value'] = num;
	debugPrint("$currentNum -> $num");
	return num;
}
*/

/*
int __getNum(int currentNum){
	// lastBulletNumStatus['state']
	// lastBulletNumStatus['value']
	// lastBulletNumStatus = {"written": 0, "returned": 1, "counter": 0};
	debugPrint(lastBulletNumStatus.toString());

	lastBulletNumStatus['written'];
	lastBulletNumStatus['returned'];
	lastBulletNumStatus['counter'];

	int num = 0;
	// if(currentNum == lastBulletNumStatus['written']){
	// 	lastBulletNumStatus['counter'] = lastBulletNumStatus['counter']! + 1;
	// 	num = lastBulletNumStatus['counter']!;
	// }


	lastBulletNumStatus['written'] = currentNum;
	lastBulletNumStatus['returned'] = num;
	return num;
}
*/


class NumWidget extends StatelessWidget {
	final int indentLvl;
	final int num;
	final String content;
	final GeneralOption gOpt;

	const NumWidget({
		super.key,
		required this.indentLvl,
		required this.num,
		required this.content,
		required this.gOpt
	});

	@override
	Widget build(BuildContext context) {
		List<InlineSpan> spans = [];
		TextStyle numStyle = Provider.of<ProviderManager>(gOpt.context).defaultStyle;

		spans.add(WidgetSpan(
			child: SelectionContainer.disabled(
				child: Text.rich(TextSpan(text: "$num. ", style: numStyle))
			)
		));

		spans.add(formattingTexts(gOpt: gOpt, content: content));

		return Text.rich(TextSpan(children: spans));
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
		// List<NumWidget> numWidgets = [];
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
				// num: useCounter ? counter : 0,
				// num: 0,
				content: content,
				gOpt: gOpt
			)));

			// spans.add(const TextSpan(text: "\n"));
			spans.add(endLineChar());
		}

		return TextSpan(children: spans);
	}

}


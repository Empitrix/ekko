import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/nf_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


Widget textTag(
	{
		required String txt,
		required BuildContext context,
		TextStyle style = const TextStyle(),
		Color color = const Color(0xffB73855),
		EdgeInsets? padding,
		EdgeInsets? margin
	}
){
	/* Tag clip widget */
	Map<String, dynamic> keywordDetect = {};
	Color faceCrl = Theme.of(context).colorScheme.inverseSurface;

	List<Map<String, dynamic>> keyWords = [
		{ "word": "todo", "color": Colors.blue },
		{ "word": "warning", "color": Colors.amber },
		{ "word": "important", "color": Colors.purpleAccent },
		{ "word": "readme", "color": Colors.grey },
		{ "word": "github", "color": Colors.black },
		{ "word": "task", "color": Colors.teal },
		{ "word": "example", "color": Colors.green },
	];

	List<Map<String, dynamic>> special = [
		{ "icon": FontAwesomeIcons.java, "word": "java", "color": Colors.orange },
		{ "icon": FontAwesomeIcons.github, "word": "github", "color": Colors.grey },
		{ "icon": FontAwesomeIcons.lightbulb, "word": "idea", "color": Colors.deepPurpleAccent },
		{ "icon": FontAwesomeIcons.rust, "word": "rust", "color": const Color(0xffb7410e) },
		{ "icon": NfFont(unicode: "\ue609", color: faceCrl), "word": "markdown", "color": Colors.grey },
		{ "icon": NfFont(unicode: "\ue235", color: faceCrl), "word": "python", "color": const Color(0xff4584b6) },
		{ "icon": NfFont(unicode: "\udb81\udee6", color: faceCrl), "word": "typescript", "color": const Color(0xff007acc) },
		{ "icon": NfFont(unicode: "\udb80\udf1e", color: faceCrl), "word": "javascript", "color": const Color(0xffF0DB4F) },
		{ "icon": NfFont(unicode: "\uebca", color: faceCrl), "word": "bash", "color": const Color(0xff282E34) },
		{ "icon": NfFont(unicode: "\udb82\ude0a", color: faceCrl), "word": "powershell", "color": const Color(0xff002353) },
		{ "icon": NfFont(unicode: "\udb81\ude68", color: faceCrl), "word": "test", "color": Colors.deepPurple },
		{ "icon": Icons.edit, "word": "edit", "color": Colors.blueGrey },
	];

	Map<String, dynamic> specialDetect = special.firstWhere(
		(e) => vStr(e["word"]) == vStr(txt),
		orElse: () => {}
	);

	// print(specialDetect.isEmpty);
	if(specialDetect.isEmpty){
		keywordDetect = keyWords.firstWhere(
			(e) => vStr(e["word"]) == vStr(txt),
			orElse: () => { "word": txt, "color": color }
		);
	}

	return Container(
		padding: padding ?? const EdgeInsets.symmetric(horizontal: 5),
		margin: margin ?? const EdgeInsets.only(right: 5),
		height: margin == null ? 23 : isDesktop() ? 20 : 17,
		decoration: BoxDecoration(
			border: specialDetect.isNotEmpty ?
				Border.all(width: 1.0, color: specialDetect["color"]) :
				Border.all(width: 1.0, color: keywordDetect["color"]),
			color: specialDetect.isNotEmpty ?
				specialDetect["color"].withOpacity(0.5) :
				keywordDetect["color"].withOpacity(0.5),
			borderRadius: BorderRadius.circular(25),
		),
		child: specialDetect.isNotEmpty ? Padding(
			padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
			child: FittedBox(child: IntrinsicWidth(child: Row(
				children: [
					specialDetect["icon"] is IconData ?
						Icon(specialDetect["icon"], size: style.fontSize ?? 20):
						specialDetect["icon"] is NfFont ? specialDetect["icon"].widget():
						specialDetect["icon"],
					const SizedBox(width: 5),
					Text(txt.trim(), style: style)
				],
			))
		)) : FittedBox(child:Text(txt.trim(), style: style)),
	);
}


import 'package:ekko/components/nf_icons.dart';
import 'package:flutter/material.dart';
import 'dart:math';


class TagData {
	final String icon;
	final Color color;
	TagData({required this.icon, required this.color});
}


int getColorNum(String c){
	c = c.toUpperCase().replaceAll("#", "");
	if(c.length == 6){
		c += "FF";
	}
	return int.parse(c, radix: 16);
}



Color getForeground(Color backgroundColor, {double bias = 0.0}) {
	int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
		pow(backgroundColor.green, 2) * 0.587 +
		pow(backgroundColor.blue, 2) * 0.114).round();
	return v < 130 + bias ? Colors.white : Colors.black;
}




TagData getTagData(BuildContext context, String text){
	text = text.toLowerCase().trim();
	Map<String, dynamic> selectedIcon = {};

	List<Map<String, dynamic>> icons = [
		{"i": "\ue235", "w": "python", "c": const Color(0xFF4584b6)},
		{"i": "\ue64c", "w": "dart", "c": const Color(0xFF2BB7F6)},
		{"i": "\udb81\udee6", "w": "typescript", "c": const Color(0xFF007acc)},
		{"i": "\udb80\udf1e", "w": "javascript", "c": const Color(0xFFF0DB4F)},
		{"i": "\uebca", "w": "bash", "c": const Color(0xFF282E34)},
		{"i": "\udb82\ude0a", "w": "powershell", "c": const Color(0xFF002353)},
		{"i": "\ue256", "w": "java", "c": const Color(0xFFFFA500)},
		{"i": "\ue7a8", "w": "rust", "c": const Color(0xFFb7410e)},
		{"i": "\uf09b", "w": "github", "c": const Color(0xFF6c727a)},
		{"i": "\ue702", "w": "git", "c": const Color(0xFF6c727a)},
		{"i": "\ue73e", "w": "markdown", "c": const Color(0xFF6c727a)},
		{"i": "\udb81\ude68", "w": "test", "c": Colors.purple},
		{"i": "\ue736", "w": "html", "c": const Color(0xFFE5532D)},
		{"i": "\ue62e", "w": "electron", "c": const Color(0xFF37384A)},
		{"i": "\ue60b", "w": "json", "c": Colors.amber},
		{"i": "\ue620", "w": "lua", "c": const Color(0xFF080884)},
	];

	for(Map<String, dynamic> icon in icons){
		if(text.contains(icon['w']!)){
			selectedIcon = icon;
			break;
		}
	}

	if(selectedIcon.isNotEmpty){
		return TagData(
			color: selectedIcon['c']! is String ?
				Color(getColorNum(selectedIcon['c']!)):
				selectedIcon['c']! as Color,
			icon: selectedIcon['i']!
		);
	}

	return TagData(color: Colors.grey, icon: "");
}


class TextTag extends StatelessWidget {
	final String tag;
	const TextTag({super.key, required this.tag});

	@override
	Widget build(BuildContext context) {
		TagData tagData = getTagData(context, tag);
		Color foregroundColor = getForeground(tagData.color);
		return Container(
			height: 20,
			margin: const EdgeInsets.only(right: 5, bottom: 2),
			// padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
			padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
			decoration: BoxDecoration(
				color: tagData.color,
				borderRadius: BorderRadius.circular(12),
				border: Border.all(color: tagData.color, width: 1)
			),
			child: SizedBox(
				height: 22,
				child: IntrinsicWidth(child: Row(
					crossAxisAlignment: CrossAxisAlignment.end,
					children: [
						if(tagData.icon != "") NfFont(
							unicode: tagData.icon, color: foregroundColor, size: 16).widget(),
						Text("${tagData.icon != '' ? ' ': ''}${tag.trim()}",
							style: TextStyle(
							color: foregroundColor,
							fontWeight: FontWeight.w600,
							fontSize: 12))
					]
				)),
			)
		);
	}
}

/*

color: alphaForeground(_colors[index].color) ? Colors.white : Colors.black,


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

*/

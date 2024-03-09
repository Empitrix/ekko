import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/config/manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class BackqouteOptStyle{
	final String name;
	final Color color;
	final IconData icon;
	BackqouteOptStyle({
		required this.name,
		required this.color,
		required this.icon
	});
}
BackqouteOptStyle _getQouteStyle(String txt){
	List<BackqouteOptStyle> opts = [
		BackqouteOptStyle(
			name: "note",
			color: Colors.blue,
			icon: FontAwesomeIcons.circleInfo
		),
		BackqouteOptStyle(
			name: "tip",
			color: Colors.green,
			icon: FontAwesomeIcons.lightbulb
		),
		BackqouteOptStyle(
			name: "important",
			color: Colors.purple,
			icon: FontAwesomeIcons.message
		),
		BackqouteOptStyle(
			name: "warning",
			color: Colors.amber,
			icon: FontAwesomeIcons.triangleExclamation
		),
		BackqouteOptStyle(
			name: "caution",
			color: Colors.red,
			icon: FontAwesomeIcons.circleExclamation
		),
	];
	BackqouteOptStyle? style = opts.firstWhere((e) => vStr(e.name) == vStr(txt));
	return style;
}


class BackqouteObj{
	late TextSpan span;
	late Color color;

	BackqouteObj({
		required this.span,
		required this.color
	});
}

BackqouteObj getBackqouteElements(BuildContext context, String input){
	List<InlineSpan> spans = <InlineSpan>[];
	BackqouteObj? obj = BackqouteObj(span: const TextSpan(), color: Colors.grey);

	// ignore: avoid_init_to_null
	Color? lineColor = null;

	for(String line in input.split("\n")){
		line = line.substring(1).trim();
		if(RegExp(r"\[\!\w+\]").allMatches(line).length == 1 && lineColor == null){
			String nameTag = line.substring(2, line.length - 1);
			// if(["note", "tip", "important", "warning", "caution"].contains(nameTag)){
			// print(nameTag);

			bool added = false;

			for(String vtn in ["NOTE", "TIP", "IMPORTANT", "WARNING", "CAUTION"]){
				if(vtn == nameTag){
					added = true;
					BackqouteOptStyle bqStyle = _getQouteStyle(nameTag);
					spans.add(WidgetSpan(
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Icon(bqStyle.icon, color: bqStyle.color, size: 20),
								const SizedBox(width: 8),
								Text(
									bqStyle.name.title(),
									style: TextStyle(
										color: bqStyle.color,
										fontWeight: FontWeight.bold,
										letterSpacing: 0.7,
										fontSize: Provider.of<ProviderManager>(context).defaultStyle.fontSize! + 1
									),
								)
							],
						)
					));
					lineColor = bqStyle.color;
					continue;
				}
			}

			if(added){ continue; }
			
			// if(["NOTE", "TIP", "IMPORTANT", "WARNING", "CAUTION"].contains(nameTag)){
			// 	BackqouteOptStyle bqStyle = _getQouteStyle(nameTag);
			// 	spans.add(WidgetSpan(
			// 		child: Row(
			// 			crossAxisAlignment: CrossAxisAlignment.center,
			// 			children: [
			// 				Icon(bqStyle.icon, color: bqStyle.color, size: 20),
			// 				const SizedBox(width: 8),
			// 				Text(
			// 					bqStyle.name.title(),
			// 					style: TextStyle(
			// 						color: bqStyle.color,
			// 						fontWeight: FontWeight.bold,
			// 						letterSpacing: 0.7,
			// 						fontSize: Provider.of<ProviderManager>(context).defaultStyle.fontSize! + 1
			// 					),
			// 				)
			// 			],
			// 		)
			// 	));
			// 	lineColor = bqStyle.color;
			// 	continue;
			// }
		}

		spans.add(
			TextSpan(
				text: line,
				style: Provider.of<ProviderManager>(context).defaultStyle
			)
		);
		spans.add(const TextSpan(text: "\n"));
	}

	try{
		obj.span = TextSpan(children: spans.sublist(0, spans.length - 1));
	} catch(_){}
	// obj.span = TextSpan(children: spans.sublist(0, 1));
	obj.color = lineColor ?? Colors.grey;
	return obj;
}

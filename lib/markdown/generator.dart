import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:flutter/material.dart';

Map<String, String> variables = {};


String _updateVariablesMap(String inpt){
	String data = "";
	inpt.splitMapJoin(
		RegExp(r'\[.*?\]\s*\:\s*\s*(https?:\/\/\S+)'),
		onMatch: (Match m){
			String txt = m.group(0)!;
			RegExp r = RegExp(r']\s*\:');
			String key = txt.split(r).first.replaceAll(RegExp(r'(\[|\])'), '').trim();
			// String key = txt.split(r).first.trim() + "]";
			String value = txt.split(r).last.trim();
			variables[key] = value;
			return "";
		},
		onNonMatch: (String n){
			data += n;
			return "";
		}
	);
	return data;
}


class MDGenerator extends StatelessWidget {
	final String content;
	const MDGenerator({
		super.key,
		required this.content,
	});

	@override
	Widget build(BuildContext context) {

		String data = "";

		// Apply rules and add to widgetTree
		lastIndent = 0;
		indentStep = 0;

		data = _updateVariablesMap(content).trim();

		for(String key in variables.keys.toList()){

			// if(key.contains('iOS FFI')){
			// 	debugPrint(key);
			// }

			// RegExp r = RegExp(r'\[\s*' + key + r'\s*\](?=(\(|\[))');
			RegExp r = RegExp(r'(?<=(\)|\]))\[\s*' + key + r'\s*\]');
			// if(r.firstMatch(data) != null){
			// 	debugPrint(r.firstMatch(data)!.group(0)!);
			// }

			 data = data.replaceAll(
				// RegExp('\\[\\s*$key\\s*\\]'),
				// RegExp('\\[\\s*$key\\s*\\](?=(\\(|\\[))'),
				// RegExp(r'\[\s*' + key + r'\s*\](?=(\(|\[))'),
				r,
				// "[${variables[key]!}]"
				// "(${variables[key]!})"
				// "[${variables[key]!}]"
				"(${variables[key]!})"
				// "(${variables[key]!})"
				// "[$key](${variables[key]!})"
			);
		}



		// Un-Completed Variables
		for(String key in variables.keys.toList()){
			// RegExp r = RegExp('(?<!(\\]|\\)))\\[(?:(?!\\[\\s*$key\\s*\\]).)*\\](?!(\\[|\\())');
			// RegExp r = RegExp(r'(?<!(\]|\)))\[(?:(?!\[\s*' + key + r'\s*\]).)*\](?!(\[|\())');
			// RegExp r = RegExp(r'(?<!\])\[(?:(?!\[\s*' + key + r'\s*\]).)*?\](?!\[|\()');
			RegExp r = RegExp(r'(?<!\]|\))\[(\s*' + key + r'\s*)*?\](?!\[|\()');
			data.splitMapJoin(
				r,
				onMatch: (Match m){
					String txt = m.group(0)!;
					data = data.replaceAll(
						txt,
						"$txt(${variables[key]!})"
					);
					return "";
				}
			);
		}

		data += "\n";


		// See the text result
		// debugPrint("${'- ' * 20}\n$data\n${'- ' * 20}");


		TextSpan spanWidget = applyRules(
			context: context,
			// content: content,
			// variables: variables
			content: data,
			rules: allSyntaxRules(context, variables)
		);

		return Text.rich(spanWidget);
	}
}


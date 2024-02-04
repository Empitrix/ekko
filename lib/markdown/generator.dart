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
			data = data.replaceAll(
				RegExp('\\[\\s*$key\\s*\\]'),
				"[${variables[key]!}]"
			);
		}

		TextSpan spanWidget = applyRules(
			context: context,
			// content: content,
			content: data,
			rules: allSyntaxRules(context)
		);

		return Text.rich(spanWidget);
	}
}


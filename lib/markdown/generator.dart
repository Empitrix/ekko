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
	final int noteId;
	final Function hotRefresh;
	const MDGenerator({
		super.key,
		required this.content,
		required this.noteId,
		required this.hotRefresh
	});

	@override
	Widget build(BuildContext context) {

		String data = "";

		// Apply rules and add to widgetTree
		lastIndent = 0;
		indentStep = 0;

		data = _updateVariablesMap(content).trim();

		// Ignore comments
		data = data.replaceAll(RegExp(r'^\s?\[\/\/\]\:\s*\#\s*(.*?)$', multiLine: true), "");


		for(String key in variables.keys.toList()){
			RegExp r = RegExp(r'(?<=(\)|\]))\[\s*' + key + r'\s*\]');
			 data = data.replaceAll(
				r,
				"(${variables[key]!})"
			);
		}

		// Un-Completed Variables
		for(String key in variables.keys.toList()){
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


		/*
			NOTE:
				Put images in a row (remove end-line char in `[!...]`) 
				this can be optional could be as GitHub Flavored Markdown (GFM) options
				---
				if there is not need to this happned or in future was a problem for enging
				this part can be deleted and instead of `rowInData` can be only data += '\n'
				and don't need to formatize the images that contaisn [![]...] regex!
		*/
		// {@Image-GFM}
		bool isFirst = true;
		String rowInData = "";
		data.splitMapJoin(
			// Two way to use regex (for all the white-spaces || for only one end-line (\n))
			// RegExp(r'\s*\[\!.*(\)|\])'),
			RegExp(r'\n\[\!.*(\)|\])'),
			onMatch: (Match m){
				rowInData += "${isFirst ? '\n' : ''}${m.group(0)!.trim()}";
				isFirst = false;
				return "";
			},
			onNonMatch: (n){
				rowInData += n;
				return "";
			}
		);



		// Apply GFM end-line
		// String gfmEndlined = "";

		// rowInData.splitMapJoin(
		// 	RegExp(r'\n+'),
		// 	onMatch: (Match m){
		// 		// One less
		// 		gfmEndlined += m.group(0)!.substring(1);
		// 		return "";
		// 	},
		// 	onNonMatch: (n){
		// 		gfmEndlined += n;
		// 		return "";
		// 	}
		// );
		// data = "$gfmEndlined\n";


		data = "$rowInData\n";

		/* {@GFM end} */
		// Other (not GFM): ```dart
		// 	data += "\n";
		// ```


		TextSpan spanWidget = applyRules(
			context: context,
			id: noteId,
			// content: content,
			// variables: variables
			content: data,
			rules: allSyntaxRules(context, variables, noteId, hotRefresh)
		);

		return Text.rich(spanWidget);
	}
}


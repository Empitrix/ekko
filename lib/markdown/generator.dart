import 'package:ekko/markdown/cases.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/rules.dart';
import 'package:ekko/markdown/tools/key_manager.dart';
import 'package:ekko/markdown/tools/pre_formatting.dart';
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

		GlobalKeyManager keyManager = GlobalKeyManager();
		String data = "";

		// Apply rules and add to widgetTree
		lastIndent = 0;
		indentStep = 0;

		// lastBulletNum = 0;
		// lastBulletNumStatus = {"state": 0, "value": 1};
		lastBulletNumStatus = {"written": 0, "returned": 1, "counter": 0};

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
		// {@Image-GFM} (remove spaces between images)
		bool isFirst = true;
		String rowInData = "";
		data.splitMapJoin(
			// Two way to use regex (for all the white-spaces || for only one end-line (\n))
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

		data = "$rowInData\n";

		data = preFormat(
			input: data,
			regex: RegExp(r'(?<=\()\n(?=(?!( )+[0,9,\+\-\*]))'),
			stringMatch: FormattingAction.non
		);

		data = "$data\n";


		String updateUnbreaking = "";
		data.splitMapJoin(
			RegExp(r'\n^ +.*$(?=\n(?=[0-9]|\-|\+\*))', multiLine: true),
			onMatch: (Match m){
				updateUnbreaking += m.group(0)!.replaceAll(RegExp(r'^\s*', multiLine: true), " ");
				return "";
			},
			onNonMatch: (String n){
				updateUnbreaking += n;
				return "";
			}
		);
		data = "$updateUnbreaking\n";


		GeneralOption gOpt = GeneralOption(
			context: context,
			keyManager: keyManager,
			variables: variables,
			noteId: noteId,
			hotRefresh: hotRefresh
		);

		TextSpan spanWidget = applyRules(
			context: context,
			keyManager: keyManager,
			id: noteId,
			content: data,
			rules: allSyntaxRules(gOpt: gOpt)
		);

		return Text.rich(spanWidget);
	}
}


import 'package:awesome_text_field/awesome_text_field.dart';
import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/table.dart';
import 'package:ekko/markdown/table_field.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class InlineTable extends InlineModule {
	InlineTable(super.opt, super.gOpt);

	@override
	InlineSpan span(String txt){
		InlineSpan? outTable = runZoned((){
			return getTableSpan(txt: txt, gOpt: gOpt);
		// ignore: deprecated_member_use
		}, onError: (e, s){
			debugPrint("Index ERR on Loading: $e");
		});
		if(outTable != null){
			return outTable;
		}
		return TextSpan(text: txt);
	}



	static RegexFormattingStyle? highlight(HighlightOption opts){
		return RegexActionStyle(
			regex: RegExp(r'(?!smi)(\|[\s\S]*?)\|(?:\n)$'),
			style: const TextStyle(),
			action: (String txt, _){
				TextStyle borderStyle = const TextStyle(color: Colors.orange);
				if(txt.trim().split("\n").length < 3){
					return TextSpan(text: txt);}
				List<String> lines = txt.split('\n');
				return TextSpan(children: [
					formatTableBorder(
						TextSpan(text: "${lines[0]}\n",
							style: const TextStyle(
								fontWeight: FontWeight.bold, color: Colors.cyan)),
						borderStyle),
					formatTableBorder(
						TextSpan(text: "${lines[1]}\n"), borderStyle),
					formatTableBorder(
						TextSpan(text: lines.sublist(2).join("\n")), borderStyle, true)
				]);
			}
		);
	}
}


import 'package:ekko/markdown/inline_module.dart';
import 'package:ekko/markdown/table.dart';
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
}


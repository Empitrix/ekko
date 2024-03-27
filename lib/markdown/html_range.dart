import 'package:flutter/material.dart';

class Range{
	final int start;
	final int end;
	final String data;

	Range({
		required this.start,
		required this.end,
		required this.data
	});
}


List<Range> detectRawHtml(String txt){
	List<Range> matches = [];
	debugPrint("/-/ " * 15);
	txt.splitMapJoin(
		// RegExp(r'^( )*(<.*>(\s*|))+', multiLine: true),
		// RegExp(r'^( )*(<.*>(\s*|))+', multiLine: true),
		RegExp(r'^( )*(<.*>(\s*))+', multiLine: true),
		onMatch: (Match m){
			print(m.group(0)!);
			Range cr = Range(
				start: m.start,
				end: m.end,
				data: m.group(0)!
			);
			matches.add(cr);
			return "";
		},
		onNonMatch: (n){
			return "";
		}
	);
	return matches;
}


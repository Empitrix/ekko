// import 'package:flutter/material.dart';

class Range{
	final int start;
	final int end;
	final String data;

	Range({
		required this.start,
		required this.end,
		required this.data
	});

	@override
	String toString() {
		return "Instance of '[$start, $end]'";
	}

	bool hasRange(){
		return start != end;
	}
}


class HTMLElement{
	final String? tag;
	final List<HTMLElement?> children;
	final Map<Object, String> attributes;
	final String? text;

	HTMLElement({
		required this.tag,
		required this.attributes,
		required this.children,
		this.text
	});

	String? getAttribute(Object name){
		return attributes[name];
	}
}




List<Range> detectRawHtml(String txt){
	List<Range> matches = [];
	// debugPrint("/-/ " * 15);
	txt.splitMapJoin(
		// RegExp(r'^( )*(<.*>(\s*|))+', multiLine: true),
		// RegExp(r'^( )*(<.*>(\s*|))+', multiLine: true),
		RegExp(r'^( )*(<.*>(\s*))+', multiLine: true),
		onMatch: (Match m){
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



String cleanHtmlParts(String input){
	return input;
}



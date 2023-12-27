List<String> breakPhrase(String input){
	List<String> words = [];
	RegExp regex = RegExp(r"\s*[^\s]+\s*");
	input.splitMapJoin(
		regex,
		onMatch: (match){
			String txt = match.group(0)!;
			words.add(txt);
			return txt;
		},
		onNonMatch: (txt){
			if(txt == ""){ return ""; }
			words.add(txt);
			return txt;
		}
	);
	return words;
}


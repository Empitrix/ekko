enum FormattingAction {
	trim,
	asItIs,
	non,
}

String preFormat({
	required String input,
	required RegExp regex,
	FormattingAction stringMatch = FormattingAction.asItIs,
	FormattingAction stringNonMatch = FormattingAction.asItIs,
}){
	/* Formmating text by given regex for GFM style */
	String formatted = "";
	input.splitMapJoin(
		regex,
		onMatch: (Match match){
			String matchData = match.group(0)!;
			if(stringMatch == FormattingAction.asItIs){
				formatted += matchData;
			} else if (stringMatch == FormattingAction.trim){
				formatted += matchData.trim();
			}
			return "";
		},
		onNonMatch: (String non){
			if(stringNonMatch == FormattingAction.asItIs){
				formatted += non;
			} else if (stringNonMatch == FormattingAction.trim){
				formatted += non.trim();
			}
			return "";
		}
	);
	return formatted;
}


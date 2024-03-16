String deIndentText(String input){
	/* Remove white-space indentation */

	bool haveIndent = false;
	/* Searching for indentation in every line */
	for(String line in input.split("\n")){
		if(line.trim().isEmpty){ continue; }
		if(line.substring(0, 1) == " "){
			haveIndent = true;
		} else {
			haveIndent = false;
			break;
		}
	}

	if(haveIndent){
		/* Remove indentation by <1> step */
		String data = "";
		for(String line in input.split("\n")){
			if(line.trim().isEmpty){ continue; }
			data += "${line.substring(1)}\n";
		}
		// checking again
		return deIndentText(data);
	}

	// if there is no indenatoin <<return>>
	return input;
}

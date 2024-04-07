int afterWhiteChar(String sample){
	int counter = 0;
	for(String c in sample.split("")){
		if(c == " " || c == "\n"){
			counter++;
		} else {
			break;
		}
		// if(c != char){}
	}
	return counter;
}

int firstCharPos(String sample, String char){
	int counter = 0;
	bool founded = false;
	for(String c in sample.split("")){
		if(c == char){
			founded = true;
			break;
		}
		counter++;
	}
	if(founded){
		return counter;
	}
	return -1;
}


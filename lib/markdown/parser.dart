import 'package:ekko/backend/extensions.dart';
import 'package:ekko/markdown/parsers.dart';
import 'package:ekko/markdown/rules.dart';

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


void getIlvl(String txt){
	int iLvl = getIndentationLevel(txt);
	int step = iLvl - lastIndent;
	if(step != 0){
		if(step < 0 && step != -1){
			step ++;
		}
		if(step > 0 && step != 1){
			step --;
		}
	}
	indentStep += step;
	if(iLvl != lastIndent){ lastIndent = iLvl; }
	// return indentStep;
}


String extractLatexPattern(String pattern){
	bool isInline = pattern.substring(0, 2).replaceAll("\$", "").isNotEmpty;
	return pattern.middle(isInline ? 1 : 2);
}

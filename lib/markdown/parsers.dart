import 'package:ekko/backend/launcher.dart';
import 'package:ekko/markdown/tools/key_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


Widget onLeadingText({
	/* One lading item that have also a text*/
	required Widget leading,
	required TextSpan text,
	double widgetSpacing = 12,
	double spacing = 0,
	double topMargin = 0
}){
	return Row(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			SizedBox(width: spacing),
			Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children:[
					SizedBox(height: topMargin),
					leading
				]
			),
			SizedBox(width: widgetSpacing),
			Expanded(child: Text.rich(text))
		],
	);
}


int getIndentationLevel(String line) {
 // Count leading spaces or tabs
 RegExp regex = RegExp(r'^[ \t]+');
 String indentation = regex.stringMatch(line) ?? '';
 // Determine the indentation level (each indent is 2 spaces)
 int indentationLevel = (indentation.length / 2).round();
 return indentationLevel;
}


double getNonRenderedWidgetSize(Widget input){
	// Works for: SizedBox, Icon, (**add more if needed!)
	double size = 0;
	// ignore: invalid_use_of_protected_member
	Widget element = input.createElement().widget; 
	if(element is Icon){
		if(element.size != null){
			size = element.size!;
		}
	} else if(element is SizedBox){
		if(element.width != null){
			size = element.width!;
		}
	} else {
		return 0;
	}
	return size;
}


TapGestureRecognizer useLinkRecognizer(BuildContext context, String link, GlobalKeyManager keyManager){
	link = link.trim();

	// Check if link did not exsited
	if(link.isEmpty){ return TapGestureRecognizer()..onTap = (){}; }

	if(link.substring(0, 1) == "#"){
		return TapGestureRecognizer()..onTap = () async {
			GlobalKey? hKey = keyManager.getGlobalKey(link.trim().substring(1));
			if(hKey != null && hKey.currentContext != null){
				/* There is a glich that need to do this for 3 times for accurecy */
				for(int i = 0; i < 3; i++){
					await Scrollable.ensureVisible(
						hKey.currentContext!,
						duration: const Duration(milliseconds: 300)
					);
				}
			} else {
				debugPrint("Couldn't found: $link header");
			}
		};
	}
	return TapGestureRecognizer()..onTap = () async {
		await launchThis(
			context: context, url: link);
		debugPrint("Opening: $link"); 
	};
}


String parseEmojiString(String txt, List<Map<String, dynamic>> emojies){
	txt = txt.substring(1, txt.length - 1);
	for(Map emoji in emojies){
		for(String alias in emoji['a']){
			if(alias.contains(txt)){
				return emoji['e'];
			}
		}
	}
	return txt;
}


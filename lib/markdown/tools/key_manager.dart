import 'package:flutter/material.dart';


class GlobalKeyManager {
	List<Map<String, GlobalKey>> keys = [];

	GlobalKey? addNewKey(String keyStr){
		keyStr = keyStr.trim().toLowerCase().replaceAll(RegExp(r'\W'), "-");
		bool canAdd = true;
		for(Map k in keys){
			if(k.keys.toList().first == keyStr){
				canAdd = false;
			}
		}
		if(!canAdd){ return null; }
		GlobalKey curretnK = GlobalKey();
		Map<String, GlobalKey> par = {keyStr: curretnK};
		keys.add(par);
		return curretnK;
	}

	GlobalKey? getGlobalKey(String keyStr){
		keyStr = keyStr.trim().toLowerCase().replaceAll(RegExp(r'\W'), "-");
		GlobalKey? gKey;
		for(Map k in keys){
			if(k.keys.toList().first == keyStr){
				return k[keyStr];
			}
		}
		return gKey;
	}
}

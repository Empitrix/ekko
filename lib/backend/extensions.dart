import 'package:ekko/config/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


extension TitleExtension on String { 
	String title() { 
		return "${this[0].toUpperCase()}${substring(1)}"; 
	}
}

extension MiniExtension on String { 
	String mini() {  return toLowerCase().trim(); }
}

// extension ColorExtentions on Color {
// 	Color aae(BuildContext context, [double less = 0 ]){
// 		return withOpacity(
// 			Provider.of<ProviderManager>(context, listen: false).acrylicOpacity - less);
// 	}
// }

extension ColorExtention on Color {
	Color aae(BuildContext context, [double less = 0 ]){
		double value = Provider.of<ProviderManager>(context, listen: false).acrylicOpacity - less;
		if(value > 1){
			value = 1;
		}
		if(value < 0){
			value = 0;
		}
		return withOpacity(value);
	}
}



extension MergeExtention on Map {
	Map merge(Map? secondary, {bool force = false}){
		if(secondary == null){ return this; }
		// Map merged = {};
		Map merged = this;
		for(String ck in secondary.keys.toList()){
			if(merged.containsKey(ck) && force){
				// Update values that already in
				merged[ck] = secondary[ck];
			} else {
				merged[ck] = secondary[ck];
			}
		}
		return merged;
	}
}


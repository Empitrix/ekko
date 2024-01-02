import 'package:ekko/config/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


extension StringExtensions on String { 
	String title() { 
		return "${this[0].toUpperCase()}${substring(1)}"; 
	}
}


// extension ColorExtentions on Color {
// 	Color aae(BuildContext context, [double less = 0 ]){
// 		return withOpacity(
// 			Provider.of<ProviderManager>(context, listen: false).acrylicOpacity - less);
// 	}
// }

extension ColorExtentions on Color {
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

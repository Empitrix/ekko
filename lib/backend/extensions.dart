import 'package:ekko/config/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension StringExtensions on String { 
	String title() { 
		return "${this[0].toUpperCase()}${substring(1)}"; 
	}
}


extension ColorExtentions on Color {
	Color aae(BuildContext context){
		return withOpacity(
			Provider.of<ProviderManager>(context, listen: false).acrylicOpacity);
	}
}

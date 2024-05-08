import 'package:ekko/backend/extensions.dart';
import 'package:ekko/models/file_out.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';

String formatLocalName(String name, [bool protect = true]){
	name = name.replaceAll(RegExp(r'(\\|\/|\||\:|\*|\?|\"|\<|\>)'), "").trim();
	if(name.isEmpty && protect){ return "file"; }
	return name;
}


String _getValidName(String fileName){
	fileName = formatLocalName(fileName, false);
	if(fileName.isEmpty){ fileName = "New Markdown.md"; }

	// Update file name contains (md) if not exists
	if(fileName.split(".").last.mini() != "md"){ fileName += ".md"; }
	return fileName;
}



Future<FileOut?> getMdFilePath([BuildContext? context, String fileName = "New Markdown.md"]) async {
	fileName = _getValidName(fileName);

	String? result;

	result = await FilePicker.platform.saveFile(
		type: FileType.custom,
		allowedExtensions: ['md'],
		fileName: fileName
	);
	
	if(result == null){ return null; }

	// Add file contains(format) if it not exists
	if(result.trim().split(".").last.trim() != "md"){
		result = "$result.md";
	}

	return FileOut(
		file: File(result),
		name: basename(result)
	);
}


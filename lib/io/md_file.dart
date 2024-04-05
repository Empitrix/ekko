import 'package:ekko/io/path_routing.dart';
import 'package:ekko/models/file_out.dart';
import 'package:flutter/material.dart';
import 'dart:convert';



class MDFile {
	static Future<bool> write(BuildContext context, String data, String fileName) async {
		/* Write as markdown file */
		FileOut? selectedFile = await getMdFilePath(context, fileName);
		if(selectedFile == null){ return false; }

		// Create file if not exsits
		if(!selectedFile.file.existsSync()){
			selectedFile.file.createSync(recursive: true);
		}

		// Wirte data on
		selectedFile.file.writeAsStringSync(
			data,
			encoding: Encoding.getByName("UTF-8")!
		);
		return true;
	}
	
	static Future<FileContentOut?> read() async {
		/* Read markdown file */
		FileOut? selectedFile = await getMdFilePath();
		// Nothing is there for reading
		if(selectedFile == null){ return null; }
		
		return FileContentOut(
			name: selectedFile.name,
			content: await selectedFile.file.readAsString(
				encoding: Encoding.getByName("UTF-8")!
			),
		);
	}
}


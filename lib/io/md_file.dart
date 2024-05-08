import 'package:ekko/components/alerts.dart';
import 'package:ekko/io/path_routing.dart';
import 'package:ekko/models/file_out.dart';
import 'package:flutter/material.dart';
import 'dart:convert';



class MDFile {
	static Future<void> write(BuildContext context, String data, String fileName) async {
		SNK snk = SNK(context);
		/* Write as markdown file */
		FileOut? selectedFile = await getMdFilePath(context, fileName);
		if(selectedFile == null){ return; }

		try{
			// Create file if not exsits
			if(!selectedFile.file.existsSync()){
				selectedFile.file.createSync(recursive: true);
			}
			// Wirte data on
			selectedFile.file.writeAsStringSync(
				data,
				encoding: Encoding.getByName("UTF-8")!
			);
			snk.message(
				const Icon(Icons.file_open_rounded),
				"File exported!");
		}catch(e){
			snk.message(
				const Icon(Icons.file_open_rounded),
				"Failed to export");
		}
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


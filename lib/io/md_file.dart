import 'package:ekko/io/path_routing.dart';
import 'package:ekko/models/file_out.dart';
import 'dart:convert';


class MDFile {
	static Future<void> write(String data) async {
		/* Write as markdown file */
		FileOut? selectedFile = await getMdFilePath();
		// End the function 
		if(selectedFile == null){ return; }
		// Wirte data on
		selectedFile.file.writeAsStringSync(
			data,
			encoding: Encoding.getByName("UTF-8")!
		);
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


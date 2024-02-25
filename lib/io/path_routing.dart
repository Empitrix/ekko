import 'package:ekko/backend/backend.dart';
import 'package:ekko/models/file_out.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:io';


Future<FileOut?> getMdFilePath([String fileName = "New Markdown.md"]) async {

	// Update file name if it's not valid for system-file
	fileName = fileName.replaceAll(RegExp(r'(\\|\/|\||\:|\*|\?|\"|\<|\>)'), "").trim();
	if(fileName.isEmpty){ fileName = "New Markdown.md"; }

	// Update file name contains (md) if not exists
	if(vStr(fileName.split(".").last) != "md"){ fileName += ".md"; }

	// Get file by md format
	// FilePickerResult? result = await FilePicker.platform.saveFile(
	String? result = await FilePicker.platform.saveFile(
		type: FileType.custom,
		allowedExtensions: ['md'],
		fileName: fileName
	);

	
	if(result != null){
		// Add file contains if it not exists
		if(result.trim().split(".").last.trim() != "md"){ result += ".md"; }

		// return File(result.files.single.path!);
		return FileOut(
			// file: File(result.files.single.path!),
			file: File(result),
			name: basename(result)
		);
	}
	// File did not selected
	return null;
}


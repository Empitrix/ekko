import 'package:ekko/models/file_out.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<FileOut?> getMdFilePath() async {
	// Get file by md format
	FilePickerResult? result = await FilePicker.platform.pickFiles(
		type: FileType.custom,
		allowedExtensions: ['md'],
	);
	
	if(result != null){
		// return File(result.files.single.path!);
		return FileOut(
			file: File(result.files.single.path!),
			name: result.files.single.name
		);
	}
	// File did not selected
	return null;
}


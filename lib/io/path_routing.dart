import 'package:permission_handler/permission_handler.dart';
import 'package:ekko/backend/extensions.dart';
import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/dialogs.dart';
import 'package:ekko/models/file_out.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';


String _getValidName(String fileName){
	fileName = fileName.replaceAll(RegExp(r'(\\|\/|\||\:|\*|\?|\"|\<|\>)'), "").trim();
	if(fileName.isEmpty){ fileName = "New Markdown.md"; }

	// Update file name contains (md) if not exists
	if(fileName.split(".").last.mini() != "md"){ fileName += ".md"; }
	return fileName;
}



Future<FileOut?> getMdFilePath([BuildContext? context, String fileName = "New Markdown.md"]) async {

	/*
	// Update file name if it's not valid for system-file
	fileName = fileName.replaceAll(RegExp(r'(\\|\/|\||\:|\*|\?|\"|\<|\>)'), "").trim();
	if(fileName.isEmpty){ fileName = "New Markdown.md"; }
	// Update file name contains (md) if not exists
	if(vStr(fileName.split(".").last) != "md"){ fileName += ".md"; }
	*/

	fileName = _getValidName(fileName);



	String? result;

	if(isDesktop()){
		result = await FilePicker.platform.saveFile(
			type: FileType.custom,
			allowedExtensions: ['md'],
			fileName: fileName
		);
	} else {
		Dialogs dialogs = Dialogs(context!);

		if (await Permission.manageExternalStorage.request().isDenied) {
			openAppSettings();
		}

		bool isFileSelected = false;
		// Get file name
		await dialogs.asyncTextFieldDialog(
			title: "File Name",
			hint: "Name",
			loadedText: fileName,
			action: (inputName) async {
				fileName = _getValidName(inputName);
				isFileSelected = true;
			}
		).then((_) async {
			if(isFileSelected){
				// get export directory
				result = await FilePicker.platform.getDirectoryPath(
					dialogTitle: "Select Directory"
				);
			}
		});

		if(result != null){
			result = getUniqueFileName(result!, "$result/$fileName");}
	}

	
	if(result == null){ return null; }

	// Add file contains if it not exists
	if(result!.trim().split(".").last.trim() != "md"){
		result = "$result.md";}

	return FileOut(
		file: File(result!),
		name: basename(result!)
	);
}


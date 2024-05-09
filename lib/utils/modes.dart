import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData modeIcon(NoteMode mode){
	switch (mode) {
		case NoteMode.web:
			return Icons.language;
		case NoteMode.copy:
			return FontAwesomeIcons.copy;
		case NoteMode.markdown:
			return FontAwesomeIcons.markdown;
		case NoteMode.plaintext:
			return FontAwesomeIcons.fileLines;
	}
}

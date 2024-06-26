import 'package:flutter/material.dart';


class SearchBarIntent extends Intent {
	const SearchBarIntent();
}

class AddNoteIntent extends Intent {
	const AddNoteIntent();
}

class SubmitNoteIntent extends Intent {
	const SubmitNoteIntent();
}

class DrawerPageIntent extends Intent {
	const DrawerPageIntent();
}

//## Display Page
class GoToEditPageIntent extends Intent {
	const GoToEditPageIntent();
}

class ClosePageIntent extends Intent {
	const ClosePageIntent();
}

// Scroll Moving
class MoveDownIntent extends Intent {
	const MoveDownIntent();
}

class MoveUpIntent extends Intent {
	const MoveUpIntent();
}

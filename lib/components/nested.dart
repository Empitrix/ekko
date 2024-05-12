import 'package:ekko/backend/backend.dart';
import 'package:ekko/components/sheets/note.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/models/note.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class NestedSearchObj extends ChangeNotifier{
	final List<GlobalKey> keys;
	late int current;

	NestedSearchObj({
		required this.keys,
		required this.current,
	});

	void clear(){
		keys.clear();
		notifyListeners();
	}

	void addKey(GlobalKey key){
		keys.add(key);
		notifyListeners();
	}

	GlobalKey? first(){
		if(keys.isNotEmpty){
			current = 0;
			return keys.first;
		}
		return null;
	}

	GlobalKey? next(){
		if(current != keys.length - 1){
			current++;
			notifyListeners();
			return keys[current - 1];
		}
		return null;
	}

	GlobalKey? previus(){
		if(current - 1 >= 0){
			current--;
			notifyListeners();
			return keys[current];
		}
		return null;
	}

	@override
	String toString() {
		if(keys.isEmpty){
			return "0/0";
		}
		return "${current + 1}/${keys.length}";
	}
}


class NestedList extends StatelessWidget {
	final ScrollController controller;
	final Note note;
	final FocusNode contextFocus;
	final void Function() onClose;
	final TextSelectionControls selectionControls;
	final TextEditingController searchController;
	final ValueNotifier<String> searchNotifier;
	final void Function(String)? onChanged;
	final NestedSearchObj searchObj;
	final void Function() onNext;
	final void Function() onPrevius;
	final Widget child;

	const NestedList({super.key,
		required this.controller,
		required this.note,
		required this.child,
		required this.contextFocus,
		required this.onClose,
		required this.selectionControls,
		required this.searchController,
		required this.searchNotifier,
		required this.searchObj,
		required this.onNext,
		required this.onPrevius,
		this.onChanged,
	});

	@override
	Widget build(BuildContext context) {

		if(note.mode == NoteMode.plaintext){
			return Column(
				children: [
					AppBar(
						title: Column(
							mainAxisAlignment: MainAxisAlignment.start,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								TextField(
									controller: searchController,
									onChanged: (String txt){
										if(onChanged != null){
											onChanged!(txt);
										}
										searchNotifier.value = txt;
									},
									style: const TextStyle(fontSize: 18),
									decoration: InputDecoration(
										hintText: "Search",
										hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
										border: InputBorder.none
									),
								),
							]
						),
						actions: [
							ListenableBuilder(
								listenable: searchObj,
								builder: (context, child){
									return Text(searchObj.toString(),
										style: const TextStyle(color: Colors.white));
								}
							),
							SizedBox(height:double.infinity, width: 28, child: InkWell(
								onTap: onPrevius,
								child: const Icon(Icons.arrow_drop_up),
							)),
							SizedBox(height:double.infinity, width: 28, child: InkWell(
								onTap: onNext,
								child: const Icon(Icons.arrow_drop_down),
							)),
							Container(
								margin: const EdgeInsets.all(5),
								child: IconButton(
									icon: const Icon(Icons.more_vert),
									onPressed: (){
										inViewNoteSheet(
											context: context,
											note: note
										);
									}
								),
							)
						],
						leading: IconButton(
							icon: const Icon(Icons.close),
							onPressed: onClose,
						),
					),
					Expanded(child: SelectionArea(
						focusNode: contextFocus,
						selectionControls: selectionControls,
						contextMenuBuilder: (context, editableTextState) => AdaptiveTextSelectionToolbar.buttonItems(
							anchors: editableTextState.contextMenuAnchors,
							buttonItems: editableTextState.contextMenuButtonItems,
						),
						child: ListView(
							controller: controller,
							padding: const EdgeInsets.only(
								right: 12, left: 12,
								top: 12, bottom: 85
							),
							children: [const SizedBox(height: 10), child],
						),
					))
				],
			);
		}

		return NestedScrollView(
			controller: controller,
			floatHeaderSlivers: true,
			physics: const ScrollPhysics(),
			headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
				return <Widget>[
					SliverAppBar(
						floating: false,
						pinned: Platform.isLinux || note.mode == NoteMode.plaintext,
						title: Column(
							mainAxisAlignment: MainAxisAlignment.start,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: note.mode == NoteMode.plaintext ? [
								TextField(
									controller: searchController,
									onChanged: (String txt){
										if(onChanged != null){
											onChanged!(txt);
										}
										searchNotifier.value = txt;
									},
									style: const TextStyle(fontSize: 18),
									decoration: InputDecoration(
										hintText: "Search",
										hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
										border: InputBorder.none
									),
								),
							] : [
								Text(
									note.title,
									overflow: TextOverflow.fade,
									style: Theme.of(context).appBarTheme.titleTextStyle
								),
								Text(
									differenceFromNow(note.lastEdit),
									style: TextStyle(
										fontSize: 14,
										overflow: TextOverflow.fade,
										color: settingModes['dMode'] ? Colors.grey : Colors.grey[400]
									)
								)
							],
						),
						actions: [
							if(note.mode == NoteMode.plaintext) Row(
								children: [
									ListenableBuilder(
										listenable: searchObj,
										builder: (context, child){
											return Text(searchObj.toString());
										}
									),
									SizedBox(height:double.infinity, width: 28, child: InkWell(
										onTap: onPrevius,
										child: const Icon(Icons.arrow_drop_up),
									)),
									SizedBox(height:double.infinity, width: 28, child: InkWell(
										onTap: onNext,
										child: const Icon(Icons.arrow_drop_down),
									)),
								],
							),
							Container(
								margin: const EdgeInsets.all(5),
								child: IconButton(
									icon: const Icon(Icons.more_vert),
									onPressed: (){
										inViewNoteSheet(
											context: context,
											note: note
										);
									}
								),
							)
						],
						forceElevated: false,
						leading: IconButton(
							icon: const Icon(Icons.close),
							onPressed: onClose,
						),
					),
				];
			},
			body: SelectionArea(
				focusNode: contextFocus,
				selectionControls: selectionControls,
				contextMenuBuilder: (context, editableTextState) => AdaptiveTextSelectionToolbar.buttonItems(
					anchors: editableTextState.contextMenuAnchors,
					buttonItems: editableTextState.contextMenuButtonItems,
				),
				child: ListView(
					padding: const EdgeInsets.only(
						right: 12, left: 12,
						top: 12, bottom: 85
					),
					children: [const SizedBox(height: 10), child],
				),
			)
		);
	}
}

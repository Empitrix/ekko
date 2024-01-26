import 'package:flutter/material.dart';


List<String> _addMatch(TextEditingController ctrl, ValueNotifier<List<String>> tags){
	ctrl.text.splitMapJoin(
		RegExp(r'\w+\s'),
		onMatch: (Match m){
			List<String> cloned = tags.value;
			if(!cloned.contains(m.group(0)!.trim())){
				cloned.add(m.group(0)!.trim());
			}
			tags.value = cloned.toList();
			ctrl.text = " ";
			return "";
		},
	);
	if(ctrl.text.isEmpty && tags.value.isNotEmpty){
		ctrl.text = tags.value.last;
		List<String> cloned = tags.value;
		cloned.removeLast();
		tags.value = cloned.toList();
	}
	return tags.value;
}


class TagField extends StatelessWidget {
	final TextStyle style;
	final TextStyle tagStyle;
	final TextEditingController controller;
	final ValueNotifier<List<String>> tags;
	final FocusNode? focusNode;
	final bool autofocus;
	final Function? onEnd;

	const TagField({
		super.key,
		required this.controller,
		required this.tags,
		this.style = const TextStyle(),
		this.tagStyle = const TextStyle(),
		this.autofocus = false,
		this.focusNode,
		this.onEnd
	});



	@override
	Widget build(BuildContext context) {

		ScrollController scroll = ScrollController();

		if(controller.text.isNotEmpty){
			controller.text = "${controller.text} ";
			tags.value = _addMatch(controller, tags).toList();
		}

		return GestureDetector(
			onHorizontalDragUpdate: (DragUpdateDetails details){
				scroll.jumpTo(scroll.offset - details.primaryDelta!);
			},
			child: SingleChildScrollView(
				controller: scroll,
				scrollDirection: Axis.horizontal,
				child: Row(
					children: [
						ValueListenableBuilder(
							valueListenable: tags,
							builder: (_, tgs, __){
								return MouseRegion(
									cursor: SystemMouseCursors.move,
									child: Row(
										children: [
											for(String tag in tags.value) Container(
												padding: const EdgeInsets.symmetric(horizontal: 5),
												margin: const EdgeInsets.only(right: 5),
												decoration: BoxDecoration(
													border: Border.all(width: 2, color: Colors.cyan),
													color: Colors.cyan.withOpacity(0.5),
													borderRadius: BorderRadius.circular(25),
												),
												child: Text(
													tag.trim(),
													style: tagStyle,
												),
											),
										],
									)
								);
							},
						),

						IntrinsicWidth(
							child: TextField(
								autofocus: autofocus,
								focusNode: focusNode,
								onSubmitted: (_){
									if(controller.text.trim().isNotEmpty){
										List<String> last = tags.value;
										last.add(controller.text.trim());
										tags.value = last.toList();
										controller.text = "";
									}
									if(onEnd != null){
										onEnd!();
										controller.text = " ";
									}
								},
								style: style,
								controller: controller,
								decoration: const InputDecoration(border: InputBorder.none),
								onChanged: (word){
									tags.value = _addMatch(controller, tags).toList();
								},
							)
						)
					],
				),
			),
		);
	}
}


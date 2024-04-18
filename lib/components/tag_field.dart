import 'package:ekko/animation/expand.dart';
import 'package:ekko/components/nf_icons.dart';
import 'package:ekko/components/tag.dart';
import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';


class AddTagButton extends StatelessWidget {
	final FocusNode focus;
	final void Function() onPressed; 

	const AddTagButton({
		super.key,
		required this.onPressed,
		required this.focus
	});

	@override
	Widget build(BuildContext context) {
		return IntrinsicWidth(
			child: Material(
				color: dMode ? Theme.of(context).colorScheme.tertiaryContainer : const Color(0xffa2a8fa),
				borderRadius: BorderRadius.circular(12),
				child: InkWell(
					borderRadius: BorderRadius.circular(12),
					onTap: onPressed,
					child: Container(
						clipBehavior: Clip.antiAlias,
						padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
						decoration: BoxDecoration(
							borderRadius: BorderRadius.circular(12),
							color: Colors.transparent
						),
						child: Row(
							children: [
								NfFont(unicode: "\udb81\udf22", size: 19, color: const  Color(0xffdddFFF)).widget(),
								const SizedBox(width: 7),
								const Text("Add a tag", style: TextStyle(color: Color(0xffdddFFF))),
								
							],
						)
					),
				)
			)
		);
	}
}


class TagField extends StatelessWidget {
	final GenAnimation anim;
	final TextEditingController controller;
	final ValueNotifier<List<String>> tags;

	const TagField({
		super.key,
		required this.anim,
		required this.tags,
		required this.controller,
	});

	@override
	Widget build(BuildContext context) {
		FocusNode fieldFocus = FocusNode();
		ScrollController scroll = ScrollController();
		/* Auto close when not focused */
		fieldFocus.addListener((){
			if(!fieldFocus.hasFocus){
				anim.controller.forward();
				controller.text = "";
			}
		});

		return Row(
			children: [
				expandAnimation(
					animation: anim.animation,
					reverse: true,
					mode: ExpandMode.width,
					// body: IntrinsicWidth(
					body: SizedBox(
						width: 140,
						child: TextField(
							focusNode: fieldFocus,
							controller: controller,
							decoration: const InputDecoration(
								hintText: "Tag...",
								border: InputBorder.none
							),
							onSubmitted: (data){
								fieldFocus.unfocus();
								anim.controller.forward();
								controller.text = "";
								if(data.trim().isEmpty){ return; }
								// Adding
								data = data.replaceAll('|', '');
								tags.value = [data, ...tags.value];
							},
						),
					)
				),
				expandAnimation(
					animation: anim.animation,
					mode: ExpandMode.width,
					body: AddTagButton(
						onPressed: () async {
							await anim.controller.reverse();
							fieldFocus.requestFocus();
						},
						focus: FocusNode()
					)
				),
				const SizedBox(width: 12),
				Expanded(child: GestureDetector(
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
													for(String tag in tags.value) TextTag(
														tag: tag,
														onDelete: (name){
															tags.value.remove(name);
															tags.value = [...tags.value];
														}
													)
												],
											)
										);
									},
								),
							]
						)
					)
				)),
			],
		);
	}
}


import 'package:ekko/utils/calc.dart';
import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
	final TextEditingController controller;
	final Function onSubmitted;
	final FocusNode focusNode;
	const TitleTextField({
		super.key,
		required this.controller,
		required this.onSubmitted,
		required this.focusNode
	});

	@override
	Widget build(BuildContext context) {
		ValueNotifier<int> index = ValueNotifier<int>(0);
		int contentLength = 0;

		TextStyle indexStyle(BuildContext context, int index){
			return [
				Theme.of(context).primaryTextTheme.headlineLarge!,
				Theme.of(context).primaryTextTheme.headlineMedium!,
				Theme.of(context).primaryTextTheme.headlineSmall!,
			][index].copyWith(
				color: Theme.of(context).colorScheme.inverseSurface
			);
		}
		// Convert SizedBox to Container just in case of padding/margin
		return SizedBox(
			child: ValueListenableBuilder(
				valueListenable: index,
				builder: (context, value, child) => TextField(
					onSubmitted: (_) => onSubmitted(),
					focusNode: focusNode,
					autofocus: true,
					style: indexStyle(context, value),
					// maxLines: _index.value == 2 ? 2 : 1,
					onChanged: (txt){
						double width = calcTextSize(
							context,
							txt,
							indexStyle(context, index.value)).width;
						if(txt.isEmpty){
							index.value = 0;
							return;
						}
						if(
								(width + 24) > (MediaQuery.of(context).size.width - 24) &&
								(contentLength < txt.length)
							){
							if(index.value < 2){
								index.value++;
							}
						} else {
							if(index.value > 0 && (contentLength > txt.length)){
								index.value--;
							}
						}
						contentLength = txt.length;
					},
					decoration: const InputDecoration(
						border: InputBorder.none,
						hintText: "Title",
					),
				),
			)
		);
	}
}

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



class DescriptionTextFiled extends StatelessWidget {
	final TextEditingController controller;
	final FocusNode focusNode;
	final Function onSubmitted;
	const DescriptionTextFiled({
		super.key,
		required this.controller,
		required this.focusNode,
		required this.onSubmitted
	});

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			height: 30,
			child: TextField(
				controller: controller,
				focusNode: focusNode,
				style: Theme.of(context).primaryTextTheme.titleLarge!
					.copyWith(
						color: Theme.of(context).colorScheme.inverseSurface),
				onSubmitted: (_) => onSubmitted(),
				decoration: const InputDecoration(
					border: InputBorder.none,
					hintText: "Description"
				),
			),
		);
	}
}


class ContentTextFiled extends StatelessWidget {
	final TextEditingController controller;
	final FocusNode focusNode;
	final Function onSubmitted;
	const ContentTextFiled({
		super.key,
		required this.controller,
		required this.focusNode,
		required this.onSubmitted
	});

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					TextField(
						controller: controller,
						focusNode: focusNode,
						maxLines: null,
						style: Theme.of(context).primaryTextTheme.bodyLarge!
							.copyWith(
								color: Theme.of(context).colorScheme.inverseSurface),
						onSubmitted: (_) => onSubmitted(),
						decoration: const InputDecoration(
							border: InputBorder.none,
							hintText: "Content"
						),
					),

					MouseRegion(
						cursor: SystemMouseCursors.text,
						child: SizedBox(
							height: MediaQuery.of(context).size.height - 125,
							child: GestureDetector(
								onTap: (){
									controller.value = TextEditingValue(
										text: controller.value.text,
										selection: const TextSelection.collapsed(offset: -1),
									);
									focusNode.requestFocus();
								},
							),
						),
					)

				],
			),
		);
	}
}


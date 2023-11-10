import 'package:ekko/utils/calc.dart';
import 'package:flutter/material.dart';

// int _index = 0;
ValueNotifier<int> _index = ValueNotifier<int>(0);
int _contentLength = 0;

TextStyle _indexStyle(BuildContext context, int index){
	return [
		Theme.of(context).primaryTextTheme.headlineLarge!,
		Theme.of(context).primaryTextTheme.headlineMedium!,
		Theme.of(context).primaryTextTheme.headlineSmall!,
	][index].copyWith(
		color: Theme.of(context).colorScheme.inverseSurface
	);
}

class ModifyField extends StatelessWidget {
	final TextEditingController controller;
	final String name;
	const ModifyField({
		super.key,
		required this.controller,
		required this.name
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			child: ValueListenableBuilder(
				valueListenable: _index,
				builder: (context, value, child) => TextField(
					style: _indexStyle(context, value),
					// maxLines: _index.value == 2 ? 2 : 1,
					onChanged: (txt){
						double width = calcTextSize(
							context,
							txt,
							_indexStyle(context, _index.value)).width;
						if(txt.isEmpty){
							_index.value = 0;
							return;
						}
						if(
								(width + 24) > (MediaQuery.of(context).size.width - 24) &&
								(_contentLength < txt.length)
							){
							if(_index.value < 2){
								_index.value++;
							}
						} else {
							if(_index.value > 0 && (_contentLength > txt.length)){
								_index.value--;
							}
						}
						_contentLength = txt.length;
					},
					decoration: InputDecoration(
						border: InputBorder.none,
						hintText: name,
					),
				),
			)
		);
	}
}

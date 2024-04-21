import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


String _getTextValue(Text text){
	/* Get String of the input Text widget */
	if(text.data == null){
		if(text.textSpan != null){
			return text.textSpan!.toPlainText();
		} else {
			return "";
		}
	} else {
		return text.data!;
	}
}

Widget _getTextWidget(Widget input, TextStyle? style){
	/* Apply styles if the input widgets are Text widget */
	if(input is Text){
		return Text(
			_getTextValue(input),
			style: style,
		);
	}
	return input;
}


class BlurAlertDialog extends StatelessWidget {
	final Widget title;
	final Widget content;
	final List<Widget> actions;
	final double blurValue;
	const BlurAlertDialog({
		super.key,
		required this.title,
		required this.content,
		required this.actions,
		this.blurValue = 3.14
	});

	@override
	Widget build(BuildContext context) {

		TextStyle blurDefaultStyle = TextStyle(
			color: settingModes['dMode'] ? Colors.white : Colors.black
		);

		Widget titleWidget = _getTextWidget(
			title,
			Theme.of(context).primaryTextTheme.titleLarge!.merge(
				blurDefaultStyle
			)
		);

		Widget contentWidget = _getTextWidget(
			content,
			Theme.of(context).primaryTextTheme.titleMedium!.merge(
				blurDefaultStyle
			)
		);
		
		return Dialog(
			backgroundColor: Colors.transparent,
			surfaceTintColor: Colors.transparent,
			elevation: 0,
			clipBehavior: Clip.hardEdge,
			shadowColor: Colors.transparent,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(12)
			),
			child: ClipRect(
				child: BackdropFilter(
					filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
					child: Container(
						padding: const EdgeInsets.all(12),
						width: 200, height: 200,
						constraints: const BoxConstraints(
							minWidth: 200, minHeight: 200
						),
						decoration: BoxDecoration(
							color: (settingModes['dMode'] ? Colors.black : Colors.white).withOpacity(0.5),
							borderRadius: BorderRadius.circular(12),
						),
						// child: title
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								titleWidget,
								const SizedBox(height: 5),
								contentWidget,
								const Expanded(child: SizedBox()),
								Row(
									mainAxisAlignment: MainAxisAlignment.end,
									children: [
										for(Widget action in actions) Row(
											children: [
												const SizedBox(width: 12),
												action
											],
										)
									]
								)
							],
						)
					),
				),
			)
		);
	}
}


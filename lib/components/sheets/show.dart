import 'package:flutter/material.dart';

// Custom context builder
typedef ContextBuilder = Widget Function(BuildContext context);

// Apply options for any sheet via show function
void showSheet({
	required BuildContext context, required ContextBuilder builder}){
	showModalBottomSheet(
		context: context,
		showDragHandle: true,
		shape: const RoundedRectangleBorder(
			borderRadius: BorderRadius.only(
				topRight: Radius.circular(12),
				topLeft: Radius.circular(12),
			)
		),
		builder: builder
	);
}

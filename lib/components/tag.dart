import 'package:flutter/material.dart';


Widget textTag(
	String txt,
	{
		TextStyle style = const TextStyle(),
		Color color = const Color(0xffB73855),
		EdgeInsets? padding,
		EdgeInsets? margin
	}
){
	return Container(
		padding: padding ?? const EdgeInsets.symmetric(horizontal: 5),
		margin: margin ?? const EdgeInsets.only(right: 5),
		decoration: BoxDecoration(
			border: Border.all(width: 1.5, color: color),
			color: color.withOpacity(0.5),
			borderRadius: BorderRadius.circular(25),
		),
		child: Text(
			txt.trim(),
			style: style,
		),
	);
}

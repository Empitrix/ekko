import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';

Color getMonoBgColor(){
	return dMode ?
		const Color(0xff343942).withOpacity(0.7) :
		const Color(0xffC2C7D0).withOpacity(0.5);
}



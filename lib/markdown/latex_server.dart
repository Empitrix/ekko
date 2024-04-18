import 'package:ekko/config/public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';


Future<Uint8List?> latexPngAPI(String latexString) async {
	http.Response res = await http.post(
		Uri.parse(const String.fromEnvironment('latex_api')),
		headers: { "Content-Type": "application/json" },
		encoding: Encoding.getByName('UTF-8'),
		body: const JsonEncoder().convert({
			"latex": latexString,
			"euler": false,
			"dMode": dMode
		})
	);

	if(res.statusCode == 200){
		Map output = const JsonDecoder().convert(res.body);
		if(output['msg'] == null){
			Uint8List data = Uint8List.fromList(List<int>.from(output['data']));
			return data;
		} else {
			debugPrint("error on server");
			return null;
		}
	} else {
		debugPrint("Failed");
		return null;
	}
}


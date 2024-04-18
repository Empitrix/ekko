// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';


void main() async {
	File file = File(path.join(Directory.current.absolute.path, "tmp", 'file.png'));
	if(!file.existsSync()){ file.createSync(recursive: true); }

	http.Response res = await http.post(
		Uri.parse("http://127.0.0.1:5000/latex"),
		headers: { "Content-Type": "application/json" },
		encoding: Encoding.getByName('UTF-8'),
		body: const JsonEncoder().convert({ "latex": r"$$f(x) = x^2 - x^\frac{1}{\pi}$$" })
	);

	if(res.statusCode == 200){
		Map output = const JsonDecoder().convert(res.body);
		if(output['msg'] == null){
			Uint8List data = Uint8List.fromList(List<int>.from(output['data']));
			file.writeAsBytesSync(data);
			print("File Written as: ${file.path}");
		} else {
			print("Failed: ${output['msg']}");
		}
	} else {
		print("SERVER FAILED!(code ${res.statusCode})");
	}
}


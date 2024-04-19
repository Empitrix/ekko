import 'package:ekko/config/public.dart';
import 'package:ekko/database/dfi.dart';
import 'package:ekko/markdown/latex_server.dart';
import 'package:ekko/markdown/parser.dart';
import 'dart:typed_data';
import 'dart:io';


class TempDB {
	final dbFile =  File(tempDbPath);
	final TempOffice tO = TempOffice();

	Future<void> init() async {
		Map init = {
			"latex": [],
		};
		if(!dbFile.existsSync()){
			dbFile.createSync(recursive: true);
			await tO.write(init);
		}
	}

	Future<bool> addLatex(String pattern) async {
		Uint8List? light = await latexPngAPI(pattern, false);
		Uint8List? dark = await latexPngAPI(pattern, true);

		// Failed
		if(light == null || dark == null){ return false; }

		Map obj = {
			"latex": extractLatexPattern(pattern),
			"light": light,
			"dark": dark
		};

		// Add into db
		Map data = await tO.read();
		data['latex'].add(obj);
		await tO.write(data);
		return true;
	}

	Future<Uint8List?> getLatex(String pattern, [bool isAction = false]) async {
		Map data = await tO.read();
		for(Map l in data['latex']){
			if(l['latex'] == extractLatexPattern(pattern)){
				// return dMode ? l['dark'] : l['light'];
				return Uint8List.fromList(List<int>.from(dMode ? l['dark'] : l['light']));
			}
		}

		if(isAction){
			bool status = await addLatex(pattern);
			if(status == true){
				return getLatex(pattern);
			}
		}

		return null;
	}

}



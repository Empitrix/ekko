import 'package:ekko/config/public.dart';
import 'package:ekko/database/dfi.dart';
import 'package:ekko/markdown/latex_server.dart';
import 'package:ekko/markdown/parser.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data';
import 'dart:io';

// int __getUniqueId(List<int> ids){
// 	return ids.length + 1;
// }


class TempDB {
	final File dbFile =  File(tempDbPath);
	final Directory tF = Directory(tempFolder);
	final TempOffice tO = TempOffice();

	Future<void> init({bool force = false}) async {
		Map init = {
			"latex": [],
		};
		if(!dbFile.existsSync() || force){
			dbFile.createSync(recursive: true);
			await tO.write(init);
			tF.createSync(recursive: true);
			if(force){
				try{
					tF.deleteSync(recursive: true);
					tF.createSync(recursive: true);
				}catch(_){/**/}
			}
		}
	}

	// Future<void> cleaner() async {
	// 	List<Map> saved = [];
	// 	Map data = await tO.read();
	// 	for(Map i in data['latex']){
	// 		for(Map j in data['latex']){
	// 			if(i['latex'] == j['latex']){
	// 				try{
	// 					File(j['light']).deleteSync(recursive: true); 
	// 					File(j['dark']).deleteSync(recursive: true); 
	// 				}catch(_){ print(_); }
	// 			}
	// 			saved.add(i);
	// 		}
	// 	}
	// 	data['latex'] = saved;
	// 	await tO.write(data);
	// }

	Future<bool> addLatex(String pattern) async {
		Uint8List? light = await latexPngAPI(pattern, false);
		Uint8List? dark = await latexPngAPI(pattern, true);

		// Failed
		if(light == null || dark == null){ return false; }

		// id = id + 1;
		int id = DateTime.now().millisecondsSinceEpoch.toInt();

		File d = File(path.join(tF.absolute.path, "${id}_dark.png"));
		File l = File(path.join(tF.absolute.path, "${id}_light.png"));
		d.writeAsBytesSync(dark);
		l.writeAsBytesSync(light);


		Map obj = {
			"latex": extractLatexPattern(pattern),
			"id": id,
			"light": l.absolute.path,
			"dark": d.absolute.path
		};

		// Add into db
		Map data = await tO.read();
		data['latex'].add(obj);
		await tO.write(data);
		// await cleaner();
		return true;
	}

	Future<String?> getLatex(String pattern, [bool isAction = false]) async {
		Map data = await tO.read();
		for(Map l in data['latex']){
			if(l['latex'] == extractLatexPattern(pattern)){
				// return dMode ? l['dark'] : l['light'];
				// return Uint8List.fromList(List<int>.from(dMode ? l['dark'] : l['light']));
				return (settingModes['dMode'] ? l['dark'] : l['light']).toString();
			}
		}

		if(isAction){
			// int id = (data['latex'] as List).isEmpty ? 0 : (data['latex'] as List).last['id'];
			// bool status = await addLatex(pattern, id);
			bool status = await addLatex(pattern);
			if(status == true){
				return getLatex(pattern);
			}
		}

		return null;
	}

}



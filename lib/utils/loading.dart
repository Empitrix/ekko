import 'package:ekko/config/public.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<void> updateDbPath() async {
  dbPath = p.join(
    (await getApplicationSupportDirectory()).absolute.path,
    "ekko.db"
  );
}
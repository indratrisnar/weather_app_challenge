import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Dir {
  static String _path = '';

  static init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    _path = directory.path;
  }

  static String backgroundImagePath(String cityName) {
    return '$_path/$cityName.png';
  }
}

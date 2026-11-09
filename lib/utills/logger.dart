import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Logger {
  static Future<File> _getLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final logDir = Directory('${directory.path}/logs');

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    final now = DateTime.now();
    final fileName = '${now.year}_${_pad(now.month)}_${_pad(now.day)}_${_pad(now.hour)}.log';
    final file = File('${logDir.path}/$fileName');

    if (!await file.exists()) {
      await file.create();
    }

    return file;
  }

  static Future<void> log(String message) async {
    final file = await _getLogFile();
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('$timestamp: $message\n', mode: FileMode.append);
  }

  static Future<List<FileSystemEntity>> listLogFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final logDir = Directory('${directory.path}/logs');

    if (await logDir.exists()) {
      return logDir.listSync();
    }
    return [];
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}

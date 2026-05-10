import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:my_sports_tracker/presentation/utils/custom_print.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/services/app_analytics.dart';

class DataTransferService {
  static CustomPrint customPrint = CustomPrint();
  static AppAnalytics appAnalytics = AppAnalytics();
  static Future<String> getDownloadsPath() async {
    final directory = await getExternalStorageDirectory();
    return '${directory!.path}/Download/tournament_data/';
  }

  /// Export players to JSON file in Downloads
  static Future<String?> exportData({bool isSeries = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final exportJson =
          isSeries
              ? prefs.getString('series') ?? '[]'
              : prefs.getString('players') ?? '[]';

      final decoded = jsonDecode(exportJson) as List;

      customPrint.print(message: 'List length: ${decoded.length}');

      if (exportJson == '[]') return null;

      final downloadsPath = '/storage/emulated/0/Download/mySportsTracker';
      final directory = Directory(downloadsPath);
      await directory.create(recursive: true);

      final filePath =
          '$downloadsPath/${isSeries ? "series_backup_" : "players_backup_"}${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File(filePath);
      await file.writeAsString(exportJson);
      String? temp = await saveToDownloadsAndShare(
        exportJson,
        filePath,
        filePath,
      );
      customPrint.print(message: 'Temp: $temp');

      return filePath;
    } catch (e, stack) {
      customPrint.print(message: 'Export failed: $e');
      appAnalytics.logCrashlytics(
        exception: e,
        stack: stack,
        printDetails: true,
        reason: 'Export failed for ${isSeries ? "series" : "players"}',
      );
      return null;
    }
  }

  static Future<String?> saveToDownloadsAndShare(
    String data,
    String fileName,
    String filePath,
  ) async {
    try {
      // For Android 10+, use MediaStore (no permission needed)
      if (Platform.isAndroid) {
        final uri = await _saveToMediaStore(data, fileName);
        final params = ShareParams(files: [XFile(filePath)]);
        SharePlus.instance.share(params);
        return filePath;
      }
      return null;
    } catch (e, stack) {
      customPrint.print(message: 'Save failed: $e');
      appAnalytics.logCrashlytics(
        exception: e,
        stack: stack,
        printDetails: true,
        reason: 'Saving file failed',
      );
      return null;
    }
  }

  static Future<Future> _saveToMediaStore(
    String jsonData,
    String fileName,
  ) async {
    final resolver = MethodChannel('your_channel').invokeMethod(
      'saveToDownloads',
      {'content': jsonData, 'fileName': fileName},
    );
    return resolver;
  }

  /// Import players from JSON file
  static Future<String> importPlayers(
    String filePath, {
    bool isSeries = false,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return '';

      final content = await file.readAsString();

      return content;
    } catch (e, stack) {
      customPrint.print(message: 'Import failed: $e');
      appAnalytics.logCrashlytics(
        exception: e,
        stack: stack,
        printDetails: true,
        reason: 'Import failed for ${isSeries ? "series" : "players"}',
      );
      return '';
    }
  }
}

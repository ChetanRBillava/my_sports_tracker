import 'dart:io';
import 'dart:typed_data';

import 'package:my_sports_tracker/presentation/utils/custom_print.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/services/app_analytics.dart';

class ScreenshotControllers {
  CustomPrint customPrint = CustomPrint();
  static AppAnalytics appAnalytics = AppAnalytics();

  Uint8List? imageBytes;

  Future<void> captureScreenshot({
    required String displayText,
    required String key,
    bool isPlayerStat = false,
    required ScreenshotController controller,
  }) async {
    try {
      final image = await controller.capture();

      imageBytes = image;

      // Save/share logic here
      await shareScreenshot(
        imageBytes: imageBytes!,
        displayText: displayText,
        // '${isPlayerStat ? '' : filters[selectedFilter].monthName?.toUpperCase()} ${key.replaceAll('_', ' ').toUpperCase()}',
      );
    } catch (e, stack) {
      customPrint.print(
        message: 'Exception caught in captureScreenshot: $key - $e',
      );
      appAnalytics.logCrashlytics(
        exception: e,
        stack: stack,
        printDetails: true,
        reason: 'Screenshot capture failed for $key',
      );
    }
  }

  Future<void> shareScreenshot({
    required Uint8List imageBytes,
    required String displayText,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/screenshot.png');
    await file.writeAsBytes(imageBytes);
    final params = ShareParams(text: displayText, files: [XFile(file.path)]);
    SharePlus.instance.share(params);
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../presentation/utils/custom_print.dart';

class AppAnalytics {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
  static CustomPrint customPrint = CustomPrint();

  void logViewAnalytics({
    required String screenName,
    required String screenClass,
  }) {
    customPrint.print(
      message: 'Logging screen view for: $screenName - $screenClass',
    );
    analytics.logScreenView(screenName: screenName, screenClass: screenClass);
  }

  void logEventAnalytics({
    required String eventName,
    required Map<String, Object> parameters,
  }) {
    customPrint.print(message: 'Logging event: $eventName');
    analytics.logEvent(name: eventName, parameters: parameters);
  }

  void logCrashlytics({
    required dynamic exception,
    StackTrace? stack,
    dynamic reason,
    Iterable<Object> information = const [],
    bool fatal = false,
    bool printDetails = false,
    String? logMessage,
  }) {
    crashlytics.log(
      logMessage ??
          'Logging app crash for: $exception :: fatal - $fatal : reason - $reason',
    );

    crashlytics.recordError(
      exception,
      stack,
      fatal: fatal,
      reason: reason,
      printDetails: printDetails,
    );
  }
}

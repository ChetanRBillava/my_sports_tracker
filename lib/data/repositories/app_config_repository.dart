import 'package:flutter/foundation.dart';
import 'package:my_sports_tracker/core/services/app_analytics.dart';

import '../../presentation/utils/custom_print.dart';
import '../api/api_client.dart';
import '../api/api_urls.dart';
import '../models/api_response/api_response_model.dart';

class AppConfigRepository {
  AppAnalytics appAnalytics = AppAnalytics();
  CustomPrint customPrint = CustomPrint();

  AppConfigRepository();

  Future<bool> testApi() async {
    customPrint.print(message: 'Testing DB Connection');

    try {
      ApiResponseModel response = await ApiClient.getApiCall(
        url: ApiUrls.testApiUrl,
      );

      if (response.success == true) {
        customPrint.print(message: 'Response: ${response.message}');
        return true;
      } else {
        if (response.error != null) {
          appAnalytics.logCrashlytics(
            exception: 'Dio Exception',
            printDetails: true,
            reason: response.message,
            logMessage: response.error,
          );
        }
        return false;
      }
    } catch (e, stack) {
      customPrint.print(message: 'Exception caught for testApi: $e');

      appAnalytics.logCrashlytics(
        exception: e,
        stack: stack,
        printDetails: true,
        reason: 'Exception caught for testApi',
      );
      return false;
    }
  }
}

import 'package:flutter/foundation.dart';

import '../api/api_client.dart';
import '../api/api_urls.dart';
import '../models/api_response/api_response_model.dart';

class AppConfigRepository {
  AppConfigRepository();

  Future<bool> testApi() async {
    print('Testing DB Connection');

    try {
      ApiResponseModel response = await ApiClient.getApiCall(
        url: ApiUrls.testApiUrl,
      );
      if (kDebugMode) {
        print('Response: ${response.message}');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Exception caught for testApi: $e');
      }
      return false;
    }
  }
}

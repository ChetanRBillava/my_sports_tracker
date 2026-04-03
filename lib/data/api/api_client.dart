import 'package:dio/dio.dart';

import '../models/api_response/api_response_model.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  static Future<ApiResponseModel> getApiCall({required String url}) async {
    final response = await dio.get(url);
    ApiResponseModel apiResponseModel = ApiResponseModel.fromJson(
      response.data,
    );

    return apiResponseModel;
  }

  static Future<ApiResponseModel> postApiCall({
    required String url,
    required Object data,
  }) async {
    final response = await dio.post(url, data: data);
    ApiResponseModel apiResponseModel = ApiResponseModel.fromJson(
      response.data,
    );
    return apiResponseModel;
  }
}

import 'package:dio/dio.dart';
import 'package:my_sports_tracker/presentation/utils/custom_print.dart';

import '../models/api_response/api_response_model.dart';

class ApiClient {
  static CustomPrint customPrint = CustomPrint();
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  static Future<ApiResponseModel> getApiCall({required String url}) async {
    try {
      final response = await dio.get(url);
      ApiResponseModel apiResponseModel = ApiResponseModel.fromJson(
        response.data,
      );
      return apiResponseModel;
    } catch (e) {
      return await processException(e);
    }
  }

  static Future<ApiResponseModel> postApiCall({
    required String url,
    required Object data,
  }) async {
    try {
      final response = await dio.post(url, data: data);
      ApiResponseModel apiResponseModel = ApiResponseModel.fromJson(
        response.data,
      );
      return apiResponseModel;
    } catch (e) {
      return await processException(e);
    }
  }

  static Future<ApiResponseModel> processException(Object e) async {
    DioException dioException = e as DioException;
    DioExceptionType dioExceptionType = dioException.type;
    String logMessage =
        'DIO Exception caught: ${dioExceptionType.name} :: Reason - ${dioException.message}, Error - ${dioException.error}, Response: ${dioException.response}`';
    customPrint.print(message: logMessage);
    return ApiResponseModel(
      success: false,
      message: 'API Exception ${dioExceptionType.name}',
      error: logMessage,
    );
  }
}

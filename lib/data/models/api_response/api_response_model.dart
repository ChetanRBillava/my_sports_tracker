import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'api_response_model.g.dart';

@JsonSerializable()
class ApiResponseModel {
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  dynamic data;
  @JsonKey(name: "error")
  dynamic error;

  ApiResponseModel({this.success, this.message, this.data, this.error});

  ApiResponseModel copyWith({
    bool? success,
    String? message,
    dynamic data,
    dynamic error,
  }) => ApiResponseModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    error: error ?? this.error,
  );

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);
}

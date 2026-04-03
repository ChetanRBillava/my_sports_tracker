import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'stat_filter_model.g.dart';

@JsonSerializable()
class StatFilterModel {
  @JsonKey(name: "manOfTheMatch")
  String? month;
  @JsonKey(name: "monthName")
  String? monthName;
  @JsonKey(name: "year")
  String? year;

  StatFilterModel({this.month, this.year, this.monthName});

  StatFilterModel copyWith({String? month, String? monthName, String? year}) =>
      StatFilterModel(
        month: month ?? this.month,
        monthName: monthName ?? this.monthName,
        year: year ?? this.year,
      );

  factory StatFilterModel.fromJson(Map<String, dynamic> json) =>
      _$StatFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatFilterModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory StatFilterModel.fromMap(Map<String, dynamic> json) => StatFilterModel(
    month: json["month"],
    monthName: json["monthName"],
    year: json["year"],
  );

  Map<String, dynamic> toMap() => {
    "month": month,
    "monthName": monthName,
    "year": year,
  };
}

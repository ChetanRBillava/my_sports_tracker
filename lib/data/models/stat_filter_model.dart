import 'dart:convert';

class StatFilterModel {
  String? month, monthName, year;

  StatFilterModel({this.month, this.year, this.monthName});

  StatFilterModel copyWith({String? month, String? monthName, String? year}) =>
      StatFilterModel(
        month: month ?? this.month,
        monthName: monthName ?? this.monthName,
        year: year ?? this.year,
      );

  factory StatFilterModel.fromJson(String str) =>
      StatFilterModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

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

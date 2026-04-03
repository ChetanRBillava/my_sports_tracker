// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatFilterModel _$StatFilterModelFromJson(Map<String, dynamic> json) =>
    StatFilterModel(
      month: json['manOfTheMatch'] as String?,
      year: json['year'] as String?,
      monthName: json['monthName'] as String?,
    );

Map<String, dynamic> _$StatFilterModelToJson(StatFilterModel instance) =>
    <String, dynamic>{
      'manOfTheMatch': instance.month,
      'monthName': instance.monthName,
      'year': instance.year,
    };

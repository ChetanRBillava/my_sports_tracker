// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverModel _$OverModelFromJson(Map<String, dynamic> json) => OverModel(
  bowlers:
      (json['bowlers'] as List<dynamic>)
          .map((e) => PlayerMiniModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  over: (json['over'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$OverModelToJson(OverModel instance) => <String, dynamic>{
  'bowlers': instance.bowlers,
  'over': instance.over,
};

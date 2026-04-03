// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => PlayerModel(
  id: json['id'] as String,
  name: json['name'] as String,
  stats:
      json['stats'] == null
          ? null
          : PlayerStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'stats': instance.stats,
    };

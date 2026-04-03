// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesModel _$SeriesModelFromJson(Map<String, dynamic> json) => SeriesModel(
  id: json['id'] as String,
  name: json['name'] as String,
  date: json['date'] as String,
  players:
      (json['players'] as List<dynamic>)
          .map((e) => PlayerMiniModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  team1:
      (json['team1'] as List<dynamic>)
          .map((e) => PlayerMiniModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  team2:
      (json['team2'] as List<dynamic>)
          .map((e) => PlayerMiniModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  matches:
      (json['matches'] as List<dynamic>)
          .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$SeriesModelToJson(SeriesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date,
      'players': instance.players,
      'team1': instance.team1,
      'team2': instance.team2,
      'matches': instance.matches,
    };

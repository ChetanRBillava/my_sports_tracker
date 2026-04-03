// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel(
  team1:
      (json['team1'] as List<dynamic>)
          .map((e) => PlayerMiniModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  team2:
      (json['team2'] as List<dynamic>)
          .map((e) => PlayerMiniModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  innings:
      (json['innings'] as List<dynamic>)
          .map((e) => InningModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  toss: (json['toss'] as num).toInt(),
  batOrBowl: (json['batOrBowl'] as num).toInt(),
  wonBy: (json['wonBy'] as num).toInt(),
  maxBalls: (json['maxBalls'] as num).toInt(),
  stats:
      json['stats'] == null
          ? null
          : MatchStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) =>
    <String, dynamic>{
      'team1': instance.team1,
      'team2': instance.team2,
      'innings': instance.innings,
      'toss': instance.toss,
      'batOrBowl': instance.batOrBowl,
      'wonBy': instance.wonBy,
      'maxBalls': instance.maxBalls,
      'stats': instance.stats,
    };

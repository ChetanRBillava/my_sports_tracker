// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerStatsModel _$PlayerStatsModelFromJson(Map<String, dynamic> json) =>
    PlayerStatsModel(
      batting:
          json['batting'] == null
              ? null
              : PlayerBattingStats.fromJson(
                json['batting'] as Map<String, dynamic>,
              ),
      bowling:
          json['bowling'] == null
              ? null
              : PlayerBowlingStats.fromJson(
                json['bowling'] as Map<String, dynamic>,
              ),
      match:
          json['match'] == null
              ? null
              : PlayerMatchStats.fromJson(
                json['match'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$PlayerStatsModelToJson(PlayerStatsModel instance) =>
    <String, dynamic>{
      'batting': instance.batting,
      'bowling': instance.bowling,
      'match': instance.match,
    };

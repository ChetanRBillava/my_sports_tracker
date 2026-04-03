// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_bowling_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerBowlingStats _$PlayerBowlingStatsFromJson(Map<String, dynamic> json) =>
    PlayerBowlingStats(
      wickets: (json['wickets'] as num?)?.toInt(),
      runs: (json['runs'] as num?)?.toInt(),
      balls: (json['balls'] as num?)?.toInt(),
      dots: (json['dots'] as num?)?.toInt(),
      wides: (json['wides'] as num?)?.toInt(),
      noBalls: (json['noBalls'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayerBowlingStatsToJson(PlayerBowlingStats instance) =>
    <String, dynamic>{
      'wickets': instance.wickets,
      'runs': instance.runs,
      'balls': instance.balls,
      'dots': instance.dots,
      'wides': instance.wides,
      'noBalls': instance.noBalls,
    };

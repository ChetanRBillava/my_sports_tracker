// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_batting_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerBattingStats _$PlayerBattingStatsFromJson(Map<String, dynamic> json) =>
    PlayerBattingStats(
      runs: (json['runs'] as num?)?.toInt(),
      balls: (json['balls'] as num?)?.toInt(),
      fours: (json['fours'] as num?)?.toInt(),
      sixes: (json['sixes'] as num?)?.toInt(),
      dots: (json['dots'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayerBattingStatsToJson(PlayerBattingStats instance) =>
    <String, dynamic>{
      'runs': instance.runs,
      'balls': instance.balls,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'dots': instance.dots,
    };

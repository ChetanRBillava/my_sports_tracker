// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_match_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerMatchStats _$PlayerMatchStatsFromJson(Map<String, dynamic> json) =>
    PlayerMatchStats(
      played: (json['played'] as num?)?.toInt(),
      won: (json['won'] as num?)?.toInt(),
      motm: (json['motm'] as num?)?.toInt(),
      superOvers: (json['superOvers'] as num?)?.toInt(),
      superOversWon: (json['superOversWon'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayerMatchStatsToJson(PlayerMatchStats instance) =>
    <String, dynamic>{
      'played': instance.played,
      'won': instance.won,
      'motm': instance.motm,
      'superOvers': instance.superOvers,
      'superOversWon': instance.superOversWon,
    };

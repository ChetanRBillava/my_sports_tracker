// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inning_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InningModel _$InningModelFromJson(Map<String, dynamic> json) => InningModel(
  currentBattingTeam: (json['currentBattingTeam'] as num).toInt(),
  currentBatsman: (json['currentBatsman'] as num).toInt(),
  currentBowler: (json['currentBowler'] as num).toInt(),
  totalRuns: (json['totalRuns'] as num).toInt(),
  totalWickets: (json['totalWickets'] as num).toInt(),
  totalBalls: (json['totalBalls'] as num).toInt(),
  overs:
      (json['overs'] as List<dynamic>)
          .map((e) => OverModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  batting:
      (json['batting'] as List<dynamic>)
          .map((e) => BattingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  bowling:
      (json['bowling'] as List<dynamic>)
          .map((e) => BowlingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  superOver: json['superOver'] as bool?,
);

Map<String, dynamic> _$InningModelToJson(InningModel instance) =>
    <String, dynamic>{
      'currentBattingTeam': instance.currentBattingTeam,
      'currentBatsman': instance.currentBatsman,
      'currentBowler': instance.currentBowler,
      'totalRuns': instance.totalRuns,
      'totalWickets': instance.totalWickets,
      'totalBalls': instance.totalBalls,
      'overs': instance.overs,
      'batting': instance.batting,
      'bowling': instance.bowling,
      'superOver': instance.superOver,
    };

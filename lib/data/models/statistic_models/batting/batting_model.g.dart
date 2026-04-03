// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BattingModel _$BattingModelFromJson(Map<String, dynamic> json) => BattingModel(
  player: PlayerMiniModel.fromJson(json['player'] as Map<String, dynamic>),
  runs: (json['runs'] as num).toInt(),
  balls: (json['balls'] as num).toInt(),
  fours: (json['fours'] as num).toInt(),
  sixes: (json['sixes'] as num).toInt(),
  strikeRate: (json['strikeRate'] as num).toDouble(),
  out: json['out'] as bool,
);

Map<String, dynamic> _$BattingModelToJson(BattingModel instance) =>
    <String, dynamic>{
      'player': instance.player,
      'runs': instance.runs,
      'balls': instance.balls,
      'fours': instance.fours,
      'sixes': instance.sixes,
      'strikeRate': instance.strikeRate,
      'out': instance.out,
    };

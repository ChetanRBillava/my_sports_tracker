// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowling_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BowlingModel _$BowlingModelFromJson(Map<String, dynamic> json) => BowlingModel(
  player: PlayerMiniModel.fromJson(json['player'] as Map<String, dynamic>),
  balls: (json['balls'] as num).toInt(),
  runs: (json['runs'] as num).toInt(),
  wides: (json['wides'] as num).toInt(),
  noBalls: (json['noBalls'] as num).toInt(),
  wickets: (json['wickets'] as num).toInt(),
);

Map<String, dynamic> _$BowlingModelToJson(BowlingModel instance) =>
    <String, dynamic>{
      'player': instance.player,
      'balls': instance.balls,
      'runs': instance.runs,
      'wides': instance.wides,
      'noBalls': instance.noBalls,
      'wickets': instance.wickets,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchStatsModel _$MatchStatsModelFromJson(
  Map<String, dynamic> json,
) => MatchStatsModel(
  manOfTheMatch:
      json['manOfTheMatch'] == null
          ? null
          : ManOfTheMatchModel.fromJson(
            json['manOfTheMatch'] as Map<String, dynamic>,
          ),
  bestBatting:
      json['bestBatting'] == null
          ? null
          : BattingModel.fromJson(json['bestBatting'] as Map<String, dynamic>),
  bestBowling:
      json['bestBowling'] == null
          ? null
          : BowlingModel.fromJson(json['bestBowling'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MatchStatsModelToJson(MatchStatsModel instance) =>
    <String, dynamic>{
      'manOfTheMatch': instance.manOfTheMatch,
      'bestBatting': instance.bestBatting,
      'bestBowling': instance.bestBowling,
    };

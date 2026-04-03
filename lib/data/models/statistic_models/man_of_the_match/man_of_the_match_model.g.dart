// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'man_of_the_match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManOfTheMatchModel _$ManOfTheMatchModelFromJson(Map<String, dynamic> json) =>
    ManOfTheMatchModel(
      player:
          json['player'] == null
              ? null
              : PlayerMiniModel.fromJson(
                json['player'] as Map<String, dynamic>,
              ),
      batting:
          json['batting'] == null
              ? null
              : BattingModel.fromJson(json['batting'] as Map<String, dynamic>),
      bowling:
          json['bowling'] == null
              ? null
              : BowlingModel.fromJson(json['bowling'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ManOfTheMatchModelToJson(ManOfTheMatchModel instance) =>
    <String, dynamic>{
      'player': instance.player,
      'batting': instance.batting,
      'bowling': instance.bowling,
    };

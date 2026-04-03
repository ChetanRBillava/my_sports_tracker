import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:my_sports_tracker/data/models/player_models/player_mini/player_mini_model.dart';

import '../batting/batting_model.dart';
import '../bowling/bowling_model.dart';
import '../man_of_the_match/man_of_the_match_model.dart';

part 'match_stats_model.g.dart';

@JsonSerializable()
class MatchStatsModel {
  @JsonKey(name: "manOfTheMatch")
  ManOfTheMatchModel? manOfTheMatch;
  @JsonKey(name: "bestBatting")
  BattingModel? bestBatting;
  @JsonKey(name: "bestBowling")
  BowlingModel? bestBowling;

  MatchStatsModel({this.manOfTheMatch, this.bestBatting, this.bestBowling});

  MatchStatsModel copyWith({
    ManOfTheMatchModel? manOfTheMatch,
    BattingModel? bestBatting,
    BowlingModel? bestBowling,
  }) => MatchStatsModel(
    manOfTheMatch: manOfTheMatch ?? this.manOfTheMatch,
    bestBatting: bestBatting ?? this.bestBatting,
    bestBowling: bestBowling ?? this.bestBowling,
  );

  factory MatchStatsModel.fromJson(Map<String, dynamic> json) =>
      _$MatchStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchStatsModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory MatchStatsModel.fromMap(Map<String, dynamic> json) => MatchStatsModel(
    manOfTheMatch:
        json["manOfTheMatch"] == null
            ? null
            : ManOfTheMatchModel.fromMap(json["manOfTheMatch"]),
    bestBatting:
        json["bestBatting"] == null
            ? null
            : BattingModel.fromMap(json["bestBatting"]),
    bestBowling:
        json["bestBowling"] == null
            ? null
            : BowlingModel.fromMap(json["bestBowling"]),
  );

  Map<String, dynamic> toMap() => {
    "manOfTheMatch": manOfTheMatch?.toMap(),
    "bestBatting": bestBatting?.toMap(),
    "bestBowling": bestBowling?.toMap(),
  };
}

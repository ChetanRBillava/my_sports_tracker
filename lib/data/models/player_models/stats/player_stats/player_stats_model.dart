import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../player_batting_stats/player_batting_stats.dart';
import '../player_bowling_stats/player_bowling_stats.dart';
import '../player_match_stats/player_match_stats.dart';

part 'player_stats_model.g.dart';

@JsonSerializable()
class PlayerStatsModel {
  @JsonKey(name: "batting")
  PlayerBattingStats? batting;
  @JsonKey(name: "bowling")
  PlayerBowlingStats? bowling;
  @JsonKey(name: "match")
  PlayerMatchStats? match;

  PlayerStatsModel({this.batting, this.bowling, this.match});

  PlayerStatsModel copyWith({
    PlayerBattingStats? batting,
    PlayerBowlingStats? bowling,
    PlayerMatchStats? match,
  }) => PlayerStatsModel(
    batting: batting ?? this.batting,
    bowling: bowling ?? this.bowling,
    match: match ?? this.match,
  );

  factory PlayerStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatsModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory PlayerStatsModel.fromMap(Map<String, dynamic> json) =>
      PlayerStatsModel(
        batting:
            json["batting"] == null
                ? PlayerBattingStats(
                  runs: 0,
                  balls: 0,
                  dots: 0,
                  fours: 0,
                  sixes: 0,
                )
                : PlayerBattingStats.fromMap(json["batting"]),
        bowling:
            json["bowling"] == null
                ? PlayerBowlingStats(
                  wickets: 0,
                  runs: 0,
                  balls: 0,
                  dots: 0,
                  wides: 0,
                  noBalls: 0,
                )
                : PlayerBowlingStats.fromMap(json["bowling"]),
        match:
            json["match"] == null
                ? PlayerMatchStats(
                  played: 0,
                  won: 0,
                  superOvers: 0,
                  superOversWon: 0,
                )
                : PlayerMatchStats.fromMap(json["match"]),
      );

  Map<String, dynamic> toMap() => {
    "batting": batting?.toMap(),
    "bowling": bowling?.toMap(),
    "match": match?.toMap(),
  };
}

import 'dart:convert';

import 'package:my_sports_tracker/data/models/player_mini_model.dart';

import 'batting_model.dart';
import 'bowling_model.dart';

class MatchStatsModel {
  ManOfTheMatch? manOfTheMatch;
  BattingModel? bestBatting;
  BowlingModel? bestBowling;

  MatchStatsModel({this.manOfTheMatch, this.bestBatting, this.bestBowling});

  MatchStatsModel copyWith({
    ManOfTheMatch? manOfTheMatch,
    BattingModel? bestBatting,
    BowlingModel? bestBowling,
  }) => MatchStatsModel(
    manOfTheMatch: manOfTheMatch ?? this.manOfTheMatch,
    bestBatting: bestBatting ?? this.bestBatting,
    bestBowling: bestBowling ?? this.bestBowling,
  );

  factory MatchStatsModel.fromJson(String str) =>
      MatchStatsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MatchStatsModel.fromMap(Map<String, dynamic> json) => MatchStatsModel(
    manOfTheMatch:
        json["manOfTheMatch"] == null
            ? null
            : ManOfTheMatch.fromMap(json["manOfTheMatch"]),
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

class ManOfTheMatch {
  PlayerMiniModel? player;
  BattingModel? batting;
  BowlingModel? bowling;

  ManOfTheMatch({this.player, this.batting, this.bowling});

  ManOfTheMatch copyWith({
    PlayerMiniModel? player,
    BattingModel? batting,
    BowlingModel? bowling,
  }) => ManOfTheMatch(
    player: player ?? this.player,
    batting: batting ?? this.batting,
    bowling: bowling ?? this.bowling,
  );

  factory ManOfTheMatch.fromJson(String str) =>
      ManOfTheMatch.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ManOfTheMatch.fromMap(Map<String, dynamic> json) => ManOfTheMatch(
    player:
        json["player"] == null ? null : PlayerMiniModel.fromMap(json["player"]),
    batting:
        json["batting"] == null ? null : BattingModel.fromMap(json["batting"]),
    bowling:
        json["bowling"] == null ? null : BowlingModel.fromMap(json["bowling"]),
  );

  Map<String, dynamic> toMap() => {
    "player": player?.toMap(),
    "batting": batting?.toMap(),
    "bowling": bowling?.toMap(),
  };
}

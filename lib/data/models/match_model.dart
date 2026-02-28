import 'dart:convert';

import 'package:my_sports_tracker/data/models/player_mini_model.dart';

import 'batting_model.dart';
import 'bowling_model.dart';
import 'inning_model.dart';
import 'match_stats_model.dart';

class MatchModel {
  List<PlayerMiniModel> team1;
  List<PlayerMiniModel> team2;
  List<InningModel> innings;
  int toss;
  int batOrBowl;
  int wonBy;
  int maxBalls;
  MatchStatsModel? stats;

  MatchModel({
    required this.team1,
    required this.team2,
    required this.innings,
    required this.toss,
    required this.batOrBowl,
    required this.wonBy,
    required this.maxBalls,
    this.stats,
  });

  MatchModel copyWith({
    List<PlayerMiniModel>? team1,
    List<PlayerMiniModel>? team2,
    List<InningModel>? innings,
    int? toss,
    int? batOrBowl,
    int? wonBy,
    int? maxBalls,
    MatchStatsModel? stats,
  }) => MatchModel(
    team1: team1 ?? this.team1,
    team2: team2 ?? this.team2,
    innings: innings ?? this.innings,
    toss: toss ?? this.toss,
    batOrBowl: batOrBowl ?? this.batOrBowl,
    wonBy: wonBy ?? this.wonBy,
    maxBalls: maxBalls ?? this.maxBalls,
    stats: stats ?? this.stats,
  );

  factory MatchModel.fromJson(String str) =>
      MatchModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MatchModel.fromMap(Map<String, dynamic> json) => MatchModel(
    team1:
        (json['team1'] as List<dynamic>)
            .map(
              (playerMap) =>
                  PlayerMiniModel.fromMap(Map<String, dynamic>.from(playerMap)),
            )
            .toList(),
    team2:
        (json['team2'] as List<dynamic>)
            .map(
              (playerMap) =>
                  PlayerMiniModel.fromMap(Map<String, dynamic>.from(playerMap)),
            )
            .toList(),
    innings:
        (json['innings'] as List<dynamic>)
            .map(
              (playerMap) =>
                  InningModel.fromMap(Map<String, dynamic>.from(playerMap)),
            )
            .toList(),
    toss: json["toss"],
    batOrBowl: json["batOrBowl"],
    wonBy: json["wonBy"],
    maxBalls: json["maxBalls"],
    stats:
        json["stats"] == null ? null : MatchStatsModel.fromMap(json["stats"]),
  );

  Map<String, dynamic> toMap() => {
    'team1': team1.map((p) => p.toMap()).toList(),
    'team2': team2.map((p) => p.toMap()).toList(),
    'innings': innings.map((p) => p.toMap()).toList(),
    "toss": toss,
    "batOrBowl": batOrBowl,
    "wonBy": wonBy,
    "maxBalls": maxBalls,
    "stats": stats?.toMap(),
  };
}

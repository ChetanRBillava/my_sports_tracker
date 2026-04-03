import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:my_sports_tracker/data/models/player_models/player_mini/player_mini_model.dart';

import '../../statistic_models/batting/batting_model.dart';
import '../../statistic_models/bowling/bowling_model.dart';
import '../inning/inning_model.dart';
import '../../statistic_models/match_stats/match_stats_model.dart';

part 'match_model.g.dart';

@JsonSerializable()
class MatchModel {
  @JsonKey(name: "team1")
  List<PlayerMiniModel> team1;
  @JsonKey(name: "team2")
  List<PlayerMiniModel> team2;
  @JsonKey(name: "innings")
  List<InningModel> innings;
  @JsonKey(name: "toss")
  int toss;
  @JsonKey(name: "batOrBowl")
  int batOrBowl;
  @JsonKey(name: "wonBy")
  int wonBy;
  @JsonKey(name: "maxBalls")
  int maxBalls;
  @JsonKey(name: "stats")
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

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchModelToJson(this);

  String toRawJson() => json.encode(toMap());

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

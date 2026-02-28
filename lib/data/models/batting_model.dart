import 'dart:convert';

import 'package:my_sports_tracker/data/models/player_mini_model.dart';

class Batting {
  PlayerMiniModel player;
  int runs;
  int balls;
  int fours;
  int sixes;
  double strikeRate;
  bool out;

  Batting({
    required this.player,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    required this.out,
  });

  Batting copyWith({
    PlayerMiniModel? player,
    int? runs,
    int? balls,
    int? fours,
    int? sixes,
    double? strikeRate,
    bool? out,
  }) => Batting(
    player: player ?? this.player,
    runs: runs ?? this.runs,
    balls: balls ?? this.balls,
    fours: fours ?? this.fours,
    sixes: sixes ?? this.sixes,
    strikeRate: strikeRate ?? this.strikeRate,
    out: out ?? this.out,
  );

  factory Batting.fromJson(String str) => Batting.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Batting.fromMap(Map<String, dynamic> json) => Batting(
    player: PlayerMiniModel.fromMap(json["player"]),
    runs: json["runs"],
    balls: json["balls"],
    fours: json["fours"],
    sixes: json["sixes"],
    strikeRate: json["strikeRate"]?.toDouble(),
    out: json["out"],
  );

  Map<String, dynamic> toMap() => {
    "player": player.toMap(),
    "runs": runs,
    "balls": balls,
    "fours": fours,
    "sixes": sixes,
    "strikeRate": strikeRate,
    "out": out,
  };
}

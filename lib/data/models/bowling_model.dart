import 'dart:convert';

import 'package:my_sports_tracker/data/models/player_mini_model.dart';

class Bowling {
  PlayerMiniModel player;
  int balls;
  int runs;
  int wides;
  int noBalls;
  int wickets;

  Bowling({
    required this.player,
    required this.balls,
    required this.runs,
    required this.wides,
    required this.noBalls,
    required this.wickets,
  });

  Bowling copyWith({
    PlayerMiniModel? player,
    int? balls,
    int? runs,
    int? wides,
    int? noBalls,
    int? wickets,
  }) => Bowling(
    player: player ?? this.player,
    balls: balls ?? this.balls,
    runs: runs ?? this.runs,
    wides: wides ?? this.wides,
    noBalls: noBalls ?? this.noBalls,
    wickets: wickets ?? this.wickets,
  );

  factory Bowling.fromJson(String str) => Bowling.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Bowling.fromMap(Map<String, dynamic> json) => Bowling(
    player: PlayerMiniModel.fromMap(json["player"]),
    balls: json["balls"],
    runs: json["runs"],
    wides: json["wides"],
    noBalls: json["noBalls"],
    wickets: json["wickets"],
  );

  Map<String, dynamic> toMap() => {
    "player": player.toMap(),
    "balls": balls,
    "runs": runs,
    "wides": wides,
    "noBalls": noBalls,
    "wickets": wickets,
  };
}

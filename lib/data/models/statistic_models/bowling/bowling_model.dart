import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:my_sports_tracker/data/models/player_models/player_mini/player_mini_model.dart';

part 'bowling_model.g.dart';

@JsonSerializable()
class BowlingModel {
  @JsonKey(name: "player")
  PlayerMiniModel player;
  @JsonKey(name: "balls")
  int balls;
  @JsonKey(name: "runs")
  int runs;
  @JsonKey(name: "wides")
  int wides;
  @JsonKey(name: "noBalls")
  int noBalls;
  @JsonKey(name: "wickets")
  int wickets;

  BowlingModel({
    required this.player,
    required this.balls,
    required this.runs,
    required this.wides,
    required this.noBalls,
    required this.wickets,
  });

  BowlingModel copyWith({
    PlayerMiniModel? player,
    int? balls,
    int? runs,
    int? wides,
    int? noBalls,
    int? wickets,
  }) => BowlingModel(
    player: player ?? this.player,
    balls: balls ?? this.balls,
    runs: runs ?? this.runs,
    wides: wides ?? this.wides,
    noBalls: noBalls ?? this.noBalls,
    wickets: wickets ?? this.wickets,
  );

  factory BowlingModel.fromJson(Map<String, dynamic> json) =>
      _$BowlingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BowlingModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory BowlingModel.fromMap(Map<String, dynamic> json) => BowlingModel(
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

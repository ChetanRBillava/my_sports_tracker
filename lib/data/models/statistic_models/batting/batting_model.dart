import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:my_sports_tracker/data/models/player_models/player_mini/player_mini_model.dart';

part 'batting_model.g.dart';

@JsonSerializable()
class BattingModel {
  @JsonKey(name: "player")
  PlayerMiniModel player;
  @JsonKey(name: "runs")
  int runs;
  @JsonKey(name: "balls")
  int balls;
  @JsonKey(name: "fours")
  int fours;
  @JsonKey(name: "sixes")
  int sixes;
  @JsonKey(name: "strikeRate")
  double strikeRate;
  @JsonKey(name: "out")
  bool out;

  BattingModel({
    required this.player,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    required this.out,
  });

  BattingModel copyWith({
    PlayerMiniModel? player,
    int? runs,
    int? balls,
    int? fours,
    int? sixes,
    double? strikeRate,
    bool? out,
  }) => BattingModel(
    player: player ?? this.player,
    runs: runs ?? this.runs,
    balls: balls ?? this.balls,
    fours: fours ?? this.fours,
    sixes: sixes ?? this.sixes,
    strikeRate: strikeRate ?? this.strikeRate,
    out: out ?? this.out,
  );

  factory BattingModel.fromJson(Map<String, dynamic> json) =>
      _$BattingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BattingModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory BattingModel.fromMap(Map<String, dynamic> json) => BattingModel(
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

import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'player_batting_stats.g.dart';

@JsonSerializable()
class PlayerBattingStats {
  @JsonKey(name: "runs")
  int? runs;
  @JsonKey(name: "balls")
  int? balls;
  @JsonKey(name: "fours")
  int? fours;
  @JsonKey(name: "sixes")
  int? sixes;
  @JsonKey(name: "dots")
  int? dots;

  PlayerBattingStats({
    this.runs,
    this.balls,
    this.fours,
    this.sixes,
    this.dots,
  });

  PlayerBattingStats copyWith({
    int? runs,
    int? balls,
    int? fours,
    int? sixes,
    int? dots,
  }) => PlayerBattingStats(
    runs: runs ?? this.runs,
    balls: balls ?? this.balls,
    fours: fours ?? this.fours,
    sixes: sixes ?? this.sixes,
    dots: dots ?? this.dots,
  );

  factory PlayerBattingStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerBattingStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerBattingStatsToJson(this);

  String toRawJson() => json.encode(toMap());

  factory PlayerBattingStats.fromMap(Map<String, dynamic> json) =>
      PlayerBattingStats(
        runs: json["runs"],
        balls: json["balls"],
        fours: json["fours"],
        sixes: json["sixes"],
        dots: json["dots"],
      );

  Map<String, dynamic> toMap() => {
    "runs": runs,
    "balls": balls,
    "fours": fours,
    "sixes": sixes,
    "dots": dots,
  };
}

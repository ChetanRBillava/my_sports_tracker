import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'player_bowling_stats.g.dart';

@JsonSerializable()
class PlayerBowlingStats {
  @JsonKey(name: "wickets")
  int? wickets;
  @JsonKey(name: "runs")
  int? runs;
  @JsonKey(name: "balls")
  int? balls;
  @JsonKey(name: "dots")
  int? dots;
  @JsonKey(name: "wides")
  int? wides;
  @JsonKey(name: "noBalls")
  int? noBalls;

  PlayerBowlingStats({
    this.wickets,
    this.runs,
    this.balls,
    this.dots,
    this.wides,
    this.noBalls,
  });

  PlayerBowlingStats copyWith({
    int? wickets,
    int? runs,
    int? balls,
    int? dots,
    int? wides,
    int? noBalls,
  }) => PlayerBowlingStats(
    wickets: wickets ?? this.wickets,
    runs: runs ?? this.runs,
    balls: balls ?? this.balls,
    dots: dots ?? this.dots,
    wides: wides ?? this.wides,
    noBalls: noBalls ?? this.noBalls,
  );

  factory PlayerBowlingStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerBowlingStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerBowlingStatsToJson(this);

  String toRawJson() => json.encode(toMap());

  factory PlayerBowlingStats.fromMap(Map<String, dynamic> json) =>
      PlayerBowlingStats(
        wickets: json["wickets"],
        runs: json["runs"],
        balls: json["balls"],
        dots: json["dots"],
        wides: json["wides"],
        noBalls: json["noBalls"],
      );

  Map<String, dynamic> toMap() => {
    "wickets": wickets,
    "runs": runs,
    "balls": balls,
    "dots": dots,
    "wides": wides,
    "noBalls": noBalls,
  };
}

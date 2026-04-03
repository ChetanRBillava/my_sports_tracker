import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'player_match_stats.g.dart';

@JsonSerializable()
class PlayerMatchStats {
  @JsonKey(name: "played")
  int? played;
  @JsonKey(name: "won")
  int? won;
  @JsonKey(name: "motm")
  int? motm;
  @JsonKey(name: "superOvers")
  int? superOvers;
  @JsonKey(name: "superOversWon")
  int? superOversWon;

  PlayerMatchStats({
    this.played,
    this.won,
    this.motm,
    this.superOvers,
    this.superOversWon,
  });

  PlayerMatchStats copyWith({
    int? played,
    int? won,
    int? mom,
    int? superOvers,
    int? superOversWon,
  }) => PlayerMatchStats(
    played: played ?? this.played,
    won: won ?? this.won,
    motm: mom ?? this.motm,
    superOvers: superOvers ?? this.superOvers,
    superOversWon: superOversWon ?? this.superOversWon,
  );

  factory PlayerMatchStats.fromJson(Map<String, dynamic> json) =>
      _$PlayerMatchStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerMatchStatsToJson(this);

  String toRawJson() => json.encode(toMap());

  factory PlayerMatchStats.fromMap(Map<String, dynamic> json) =>
      PlayerMatchStats(
        played: json["played"],
        won: json["won"],
        motm: json["mom"],
        superOvers: json["superOvers"],
        superOversWon: json["superOversWon"],
      );

  Map<String, dynamic> toMap() => {
    "played": played,
    "won": won,
    "mom": motm,
    "superOvers": superOvers,
    "superOversWon": superOversWon,
  };
}

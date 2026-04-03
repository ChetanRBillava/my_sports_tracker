import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:my_sports_tracker/data/models/player_models/player_mini/player_mini_model.dart';

import '../../statistic_models/batting/batting_model.dart';
import '../../statistic_models/bowling/bowling_model.dart';
import '../over/over_model.dart';

part 'inning_model.g.dart';

@JsonSerializable()
class InningModel {
  @JsonKey(name: "currentBattingTeam")
  int currentBattingTeam;
  @JsonKey(name: "currentBatsman")
  int currentBatsman;
  @JsonKey(name: "currentBowler")
  int currentBowler;
  @JsonKey(name: "totalRuns")
  int totalRuns;
  @JsonKey(name: "totalWickets")
  int totalWickets;
  @JsonKey(name: "totalBalls")
  int totalBalls;
  @JsonKey(name: "overs")
  List<OverModel> overs;
  @JsonKey(name: "batting")
  List<BattingModel> batting;
  @JsonKey(name: "bowling")
  List<BowlingModel> bowling;
  @JsonKey(name: "superOver")
  bool? superOver;

  InningModel({
    required this.currentBattingTeam,
    required this.currentBatsman,
    required this.currentBowler,
    required this.totalRuns,
    required this.totalWickets,
    required this.totalBalls,
    required this.overs,
    required this.batting,
    required this.bowling,
    required this.superOver,
  });

  InningModel copyWith({
    int? currentBattingTeam,
    int? currentBatsman,
    int? currentBowler,
    int? totalRuns,
    int? totalWickets,
    int? totalBalls,
    List<OverModel>? overs,
    List<BattingModel>? batting,
    List<BowlingModel>? bowling,
    bool? superOver,
  }) => InningModel(
    currentBattingTeam: currentBattingTeam ?? this.currentBattingTeam,
    currentBatsman: currentBatsman ?? this.currentBatsman,
    currentBowler: currentBowler ?? this.currentBowler,
    totalRuns: totalRuns ?? this.totalRuns,
    totalWickets: totalWickets ?? this.totalWickets,
    totalBalls: totalBalls ?? this.totalBalls,
    overs: overs ?? this.overs,
    batting: batting ?? this.batting,
    bowling: bowling ?? this.bowling,
    superOver: superOver ?? this.superOver,
  );

  factory InningModel.fromJson(Map<String, dynamic> json) =>
      _$InningModelFromJson(json);

  Map<String, dynamic> toJson() => _$InningModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory InningModel.fromMap(Map<String, dynamic> json) => InningModel(
    currentBattingTeam: json["currentBattingTeam"],
    currentBatsman: json["currentBatsman"],
    currentBowler: json["currentBowler"],
    totalRuns: json["totalRuns"],
    totalWickets: json["totalWickets"],
    totalBalls: json["totalBalls"],
    overs: List<OverModel>.from(json["overs"].map((x) => OverModel.fromMap(x))),
    batting: List<BattingModel>.from(
      json["batting"].map((x) => BattingModel.fromMap(x)),
    ),
    bowling: List<BowlingModel>.from(
      json["bowling"].map((x) => BowlingModel.fromMap(x)),
    ),
    superOver: json["superOver"],
  );

  Map<String, dynamic> toMap() => {
    "currentBattingTeam": currentBattingTeam,
    "currentBatsman": currentBatsman,
    "currentBowler": currentBowler,
    "totalRuns": totalRuns,
    "totalWickets": totalWickets,
    "totalBalls": totalBalls,
    "overs": List<dynamic>.from(overs.map((x) => x.toMap())),
    "batting": List<dynamic>.from(batting.map((x) => x.toMap())),
    "bowling": List<dynamic>.from(bowling.map((x) => x.toMap())),
    "superOver": superOver,
  };
}

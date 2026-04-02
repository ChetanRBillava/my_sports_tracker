import 'dart:convert';

import 'package:my_sports_tracker/data/models/player_mini_model.dart';

import 'batting_model.dart';
import 'bowling_model.dart';

class InningModel {
  int currentBattingTeam;
  int currentBatsman;
  int currentBowler;
  int totalRuns;
  int totalWickets;
  int totalBalls;
  List<Over> overs;
  List<BattingModel> batting;
  List<BowlingModel> bowling;
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
    List<Over>? overs,
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

  factory InningModel.fromJson(String str) =>
      InningModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InningModel.fromMap(Map<String, dynamic> json) => InningModel(
    currentBattingTeam: json["currentBattingTeam"],
    currentBatsman: json["currentBatsman"],
    currentBowler: json["currentBowler"],
    totalRuns: json["totalRuns"],
    totalWickets: json["totalWickets"],
    totalBalls: json["totalBalls"],
    overs: List<Over>.from(json["overs"].map((x) => Over.fromMap(x))),
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

class Over {
  List<PlayerMiniModel> bowlers;
  List<String> over;

  Over({required this.bowlers, required this.over});

  Over copyWith({List<PlayerMiniModel>? bowlers, List<String>? over}) =>
      Over(bowlers: bowlers ?? this.bowlers, over: over ?? this.over);

  factory Over.fromJson(String str) => Over.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Over.fromMap(Map<String, dynamic> json) => Over(
    bowlers: List<PlayerMiniModel>.from(
      json["bowlers"].map((x) => PlayerMiniModel.fromMap(x)),
    ),
    over: List<String>.from(json["over"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "bowlers": List<dynamic>.from(bowlers.map((x) => x.toMap())),
    "over": List<dynamic>.from(over.map((x) => x)),
  };
}

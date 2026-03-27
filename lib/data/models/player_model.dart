import 'dart:convert';

class PlayerModel {
  String id;
  String name;
  Stats? stats;

  PlayerModel({required this.id, required this.name, this.stats});

  PlayerModel copyWith({String? id, String? name, Stats? stats}) => PlayerModel(
    id: id ?? this.id,
    name: name ?? this.name,
    stats: stats ?? this.stats,
  );

  factory PlayerModel.fromJson(String str) =>
      PlayerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromMap(Map<String, dynamic> json) => PlayerModel(
    id: json["id"],
    name: json["name"],
    stats: json["stats"] == null ? null : Stats.fromMap(json["stats"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "stats": stats?.toMap(),
  };
}

class Stats {
  BattingStats? batting;
  BowlingStats? bowling;
  MatchStats? match;

  Stats({this.batting, this.bowling, this.match});

  Stats copyWith({
    BattingStats? batting,
    BowlingStats? bowling,
    MatchStats? match,
  }) => Stats(
    batting: batting ?? this.batting,
    bowling: bowling ?? this.bowling,
    match: match ?? this.match,
  );

  factory Stats.fromJson(String str) => Stats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Stats.fromMap(Map<String, dynamic> json) => Stats(
    batting:
        json["batting"] == null
            ? BattingStats(runs: 0, balls: 0, dots: 0, fours: 0, sixes: 0)
            : BattingStats.fromMap(json["batting"]),
    bowling:
        json["bowling"] == null
            ? BowlingStats(
              wickets: 0,
              runs: 0,
              balls: 0,
              dots: 0,
              wides: 0,
              noBalls: 0,
            )
            : BowlingStats.fromMap(json["bowling"]),
    match:
        json["match"] == null
            ? MatchStats(played: 0, won: 0, superOvers: 0, superOversWon: 0)
            : MatchStats.fromMap(json["match"]),
  );

  Map<String, dynamic> toMap() => {
    "batting": batting?.toMap(),
    "bowling": bowling?.toMap(),
    "match": match?.toMap(),
  };
}

class BattingStats {
  int? runs;
  int? balls;
  int? fours;
  int? sixes;
  int? dots;

  BattingStats({this.runs, this.balls, this.fours, this.sixes, this.dots});

  BattingStats copyWith({
    int? runs,
    int? balls,
    int? fours,
    int? sixes,
    int? dots,
  }) => BattingStats(
    runs: runs ?? this.runs,
    balls: balls ?? this.balls,
    fours: fours ?? this.fours,
    sixes: sixes ?? this.sixes,
    dots: dots ?? this.dots,
  );

  factory BattingStats.fromJson(String str) =>
      BattingStats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BattingStats.fromMap(Map<String, dynamic> json) => BattingStats(
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

class BowlingStats {
  int? wickets;
  int? runs;
  int? balls;
  int? dots;
  int? wides;
  int? noBalls;

  BowlingStats({
    this.wickets,
    this.runs,
    this.balls,
    this.dots,
    this.wides,
    this.noBalls,
  });

  BowlingStats copyWith({
    int? wickets,
    int? runs,
    int? balls,
    int? dots,
    int? wides,
    int? noBalls,
  }) => BowlingStats(
    wickets: wickets ?? this.wickets,
    runs: runs ?? this.runs,
    balls: balls ?? this.balls,
    dots: dots ?? this.dots,
    wides: wides ?? this.wides,
    noBalls: noBalls ?? this.noBalls,
  );

  factory BowlingStats.fromJson(String str) =>
      BowlingStats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BowlingStats.fromMap(Map<String, dynamic> json) => BowlingStats(
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

class MatchStats {
  int? played;
  int? won;
  int? motm;
  int? superOvers;
  int? superOversWon;

  MatchStats({
    this.played,
    this.won,
    this.motm,
    this.superOvers,
    this.superOversWon,
  });

  MatchStats copyWith({
    int? played,
    int? won,
    int? mom,
    int? superOvers,
    int? superOversWon,
  }) => MatchStats(
    played: played ?? this.played,
    won: won ?? this.won,
    motm: mom ?? this.motm,
    superOvers: superOvers ?? this.superOvers,
    superOversWon: superOversWon ?? this.superOversWon,
  );

  factory MatchStats.fromJson(String str) =>
      MatchStats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MatchStats.fromMap(Map<String, dynamic> json) => MatchStats(
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

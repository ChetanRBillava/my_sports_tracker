import 'dart:convert';

class StatisticsTileModel {
  String? title;
  List<Stat>? stats;

  StatisticsTileModel({this.title, this.stats});

  StatisticsTileModel copyWith({String? title, List<Stat>? stats}) =>
      StatisticsTileModel(
        title: title ?? this.title,
        stats: stats ?? this.stats,
      );

  factory StatisticsTileModel.fromJson(String str) =>
      StatisticsTileModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StatisticsTileModel.fromMap(Map<String, dynamic> json) =>
      StatisticsTileModel(
        title: json["title"],
        stats:
            json["stats"] == null
                ? []
                : List<Stat>.from(json["stats"]!.map((x) => Stat.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "title": title,
    "stats":
        stats == null ? [] : List<dynamic>.from(stats!.map((x) => x.toMap())),
  };
}

class Stat {
  String? title;
  String? type;
  List<String>? players;

  Stat({this.title, this.type, this.players});

  Stat copyWith({String? title, String? type, List<String>? players}) => Stat(
    title: title ?? this.title,
    type: type ?? this.type,
    players: players ?? this.players,
  );

  factory Stat.fromJson(String str) => Stat.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Stat.fromMap(Map<String, dynamic> json) => Stat(
    title: json["title"],
    type: json["type"],
    players:
        json["players"] == null
            ? []
            : List<String>.from(json["players"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "type": type,
    "players":
        players == null ? [] : List<dynamic>.from(players!.map((x) => x)),
  };
}

import 'dart:convert';

import 'package:my_sports_tracker/data/models/player_models/player/player_model.dart';

import '../../../../core/constants/app_enums.dart';

class StatisticsTileModel {
  String title;
  List<Stat>? stats;

  StatisticsTileModel({required this.title, this.stats});

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
  StatTileEnums type;
  List<PlayerModel>? players;

  Stat({this.title, required this.type, this.players});

  Stat copyWith({
    String? title,
    StatTileEnums? type,
    List<PlayerModel>? players,
  }) => Stat(
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
            : List<PlayerModel>.from(json["players"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "type": type,
    "players":
        players == null ? [] : List<PlayerModel>.from(players!.map((x) => x)),
  };
}

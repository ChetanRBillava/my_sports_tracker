import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import 'package:my_sports_tracker/data/models/player_models/player_mini/player_mini_model.dart';

import '../match/match_model.dart';

part 'series_model.g.dart';

@JsonSerializable()
class SeriesModel {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "date")
  final String date;
  @JsonKey(name: "players")
  final List<PlayerMiniModel> players;
  @JsonKey(name: "team1")
  List<PlayerMiniModel> team1;
  @JsonKey(name: "team2")
  List<PlayerMiniModel> team2;
  @JsonKey(name: "matches")
  final List<MatchModel> matches;

  SeriesModel({
    required this.id,
    required this.name,
    required this.date,
    required this.players,
    required this.team1,
    required this.team2,
    required this.matches,
  });

  SeriesModel copyWith({
    String? id,
    String? name,
    String? date,
    List<PlayerMiniModel>? players,
    List<PlayerMiniModel>? team1,
    List<PlayerMiniModel>? team2,
    List<MatchModel>? matches,
  }) => SeriesModel(
    id: id ?? this.id,
    name: name ?? this.name,
    date: date ?? this.date,
    players: players ?? this.players,
    team1: team1 ?? this.team1,
    team2: team2 ?? this.team2,
    matches: matches ?? this.matches,
  );

  factory SeriesModel.fromJson(Map<String, dynamic> json) =>
      _$SeriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory SeriesModel.fromMap(Map<String, dynamic> map) {
    return SeriesModel(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      players:
          (map['players'] as List<dynamic>)
              .map(
                (playerMap) => PlayerMiniModel.fromMap(
                  Map<String, dynamic>.from(playerMap),
                ),
              )
              .toList(),
      team1:
          (map['team1'] as List<dynamic>)
              .map(
                (playerMap) => PlayerMiniModel.fromMap(
                  Map<String, dynamic>.from(playerMap),
                ),
              )
              .toList(),
      team2:
          (map['team2'] as List<dynamic>)
              .map(
                (playerMap) => PlayerMiniModel.fromMap(
                  Map<String, dynamic>.from(playerMap),
                ),
              )
              .toList(),
      matches:
          (map['matches'] as List<dynamic>)
              .map(
                (playerMap) =>
                    MatchModel.fromMap(Map<String, dynamic>.from(playerMap)),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'players': players.map((p) => p.toMap()).toList(),
      'team1': team1.map((p) => p.toMap()).toList(),
      'team2': team2.map((p) => p.toMap()).toList(),
      'matches': matches.map((m) => m.toMap()).toList(),
    };
  }
}

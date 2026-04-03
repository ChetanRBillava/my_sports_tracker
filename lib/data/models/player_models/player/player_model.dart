import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../stats/player_stats/player_stats_model.dart';

part 'player_model.g.dart';

@JsonSerializable()
class PlayerModel {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "stats")
  PlayerStatsModel? stats;

  PlayerModel({required this.id, required this.name, this.stats});

  PlayerModel copyWith({String? id, String? name, PlayerStatsModel? stats}) =>
      PlayerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        stats: stats ?? this.stats,
      );

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory PlayerModel.fromMap(Map<String, dynamic> json) => PlayerModel(
    id: json["id"],
    name: json["name"],
    stats:
        json["stats"] == null ? null : PlayerStatsModel.fromMap(json["stats"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "stats": stats?.toMap(),
  };
}

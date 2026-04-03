import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../player_models/player_mini/player_mini_model.dart';
import '../batting/batting_model.dart';
import '../bowling/bowling_model.dart';

part 'man_of_the_match_model.g.dart';

@JsonSerializable()
class ManOfTheMatchModel {
  @JsonKey(name: "player")
  PlayerMiniModel? player;
  @JsonKey(name: "batting")
  BattingModel? batting;
  @JsonKey(name: "bowling")
  BowlingModel? bowling;

  ManOfTheMatchModel({this.player, this.batting, this.bowling});

  ManOfTheMatchModel copyWith({
    PlayerMiniModel? player,
    BattingModel? batting,
    BowlingModel? bowling,
  }) => ManOfTheMatchModel(
    player: player ?? this.player,
    batting: batting ?? this.batting,
    bowling: bowling ?? this.bowling,
  );

  factory ManOfTheMatchModel.fromJson(Map<String, dynamic> json) =>
      _$ManOfTheMatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManOfTheMatchModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory ManOfTheMatchModel.fromMap(Map<String, dynamic> json) => ManOfTheMatchModel(
    player:
    json["player"] == null ? null : PlayerMiniModel.fromMap(json["player"]),
    batting:
    json["batting"] == null ? null : BattingModel.fromMap(json["batting"]),
    bowling:
    json["bowling"] == null ? null : BowlingModel.fromMap(json["bowling"]),
  );

  Map<String, dynamic> toMap() => {
    "player": player?.toMap(),
    "batting": batting?.toMap(),
    "bowling": bowling?.toMap(),
  };
}
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

import '../../player_models/player_mini/player_mini_model.dart';

part 'over_model.g.dart';

@JsonSerializable()
class OverModel {
  @JsonKey(name: "bowlers")
  List<PlayerMiniModel> bowlers;
  @JsonKey(name: "over")
  List<String> over;

  OverModel({required this.bowlers, required this.over});

  OverModel copyWith({List<PlayerMiniModel>? bowlers, List<String>? over}) =>
      OverModel(bowlers: bowlers ?? this.bowlers, over: over ?? this.over);

  factory OverModel.fromJson(Map<String, dynamic> json) =>
      _$OverModelFromJson(json);

  Map<String, dynamic> toJson() => _$OverModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory OverModel.fromMap(Map<String, dynamic> json) => OverModel(
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

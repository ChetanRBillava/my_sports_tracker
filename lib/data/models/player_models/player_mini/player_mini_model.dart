import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'player_mini_model.g.dart';

@JsonSerializable()
class PlayerMiniModel {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "name")
  String name;

  PlayerMiniModel({required this.id, required this.name});

  PlayerMiniModel copyWith({String? id, String? name}) =>
      PlayerMiniModel(id: id ?? this.id, name: name ?? this.name);

  factory PlayerMiniModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerMiniModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerMiniModelToJson(this);

  String toRawJson() => json.encode(toMap());

  factory PlayerMiniModel.fromMap(Map<String, dynamic> json) =>
      PlayerMiniModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name};
}

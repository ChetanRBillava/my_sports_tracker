import 'dart:convert';

class PlayerMiniModel {
  String id;
  String name;

  PlayerMiniModel({required this.id, required this.name});

  PlayerMiniModel copyWith({String? id, String? name}) =>
      PlayerMiniModel(id: id ?? this.id, name: name ?? this.name);

  factory PlayerMiniModel.fromJson(String str) =>
      PlayerMiniModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayerMiniModel.fromMap(Map<String, dynamic> json) =>
      PlayerMiniModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name};
}

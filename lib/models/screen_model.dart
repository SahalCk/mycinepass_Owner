// To parse this JSON data, do
//
//     final screenModel = screenModelFromJson(jsonString);

import 'dart:convert';

ScreenModel screenModelFromJson(String str) =>
    ScreenModel.fromJson(json.decode(str));

String screenModelToJson(ScreenModel data) => json.encode(data.toJson());

class ScreenModel {
  String id;
  String ownerId;
  int screen;
  int rows;
  int columns;
  int totalSeats;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ScreenModel({
    required this.id,
    required this.ownerId,
    required this.screen,
    required this.rows,
    required this.columns,
    required this.totalSeats,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ScreenModel.fromJson(Map<String, dynamic> json) => ScreenModel(
        id: json["_id"],
        ownerId: json["ownerId"],
        screen: json["screen"],
        rows: json["rows"],
        columns: json["columns"],
        totalSeats: json["totalSeats"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "ownerId": ownerId,
        "screen": screen,
        "rows": rows,
        "columns": columns,
        "totalSeats": totalSeats,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

// To parse this JSON data, do
//
//     final movieModel = movieModelFromJson(jsonString);

import 'dart:convert';

MovieModel movieModelFromJson(String str) =>
    MovieModel.fromJson(json.decode(str));

String movieModelToJson(MovieModel data) => json.encode(data.toJson());

class MovieModel {
  String id;
  String screenId;
  String ownerId;
  String ownerName;
  String location;
  String movieName;
  String showTime;
  DateTime startDate;
  DateTime endDate;
  int price;
  int screen;

  MovieModel({
    required this.id,
    required this.screenId,
    required this.ownerId,
    required this.ownerName,
    required this.location,
    required this.movieName,
    required this.showTime,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.screen,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json["_id"],
        screenId: json["screenId"],
        ownerId: json["ownerId"],
        ownerName: json["ownerName"],
        location: json["location"],
        movieName: json["movieName"],
        showTime: json["showTime"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        price: json["price"],
        screen: json["screen"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "screenId": screenId,
        "ownerId": ownerId,
        "ownerName": ownerName,
        "location": location,
        "movieName": movieName,
        "showTime": showTime,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "price": price,
        "screen": screen,
      };
}

// To parse this JSON data, do
//
//     final ownerModel = ownerModelFromJson(jsonString);

import 'dart:convert';

OwnerModel ownerModelFromJson(String str) =>
    OwnerModel.fromJson(json.decode(str));

String ownerModelToJson(OwnerModel data) => json.encode(data.toJson());

class OwnerModel {
  String id;
  String name;
  int phone;
  String email;
  String licence;
  int adhaar;
  String location;
  int wallet;
  String images;
  String status;
  bool block;
  int v;

  OwnerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.licence,
    required this.adhaar,
    required this.location,
    required this.wallet,
    required this.images,
    required this.status,
    required this.block,
    required this.v,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        id: json["_id"],
        name: json["Name"],
        phone: json["Phone"],
        email: json["Email"],
        licence: json["Licence"],
        adhaar: json["Adhaar"],
        location: json["Location"],
        wallet: json["wallet"],
        images: json["images"],
        status: json["status"],
        block: json["block"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Name": name,
        "Phone": phone,
        "Email": email,
        "Licence": licence,
        "Adhaar": adhaar,
        "Location": location,
        "wallet": wallet,
        "images": images,
        "status": status,
        "block": block,
        "__v": v,
      };
}

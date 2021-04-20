// To parse this JSON data, do
//
//     final usaha = usahaFromJson(jsonString);

import 'dart:convert';

Usaha usahaFromJson(String str) => Usaha.fromJson(json.decode(str));

String usahaToJson(Usaha data) => json.encode(data.toJson());

class Usaha {
  Usaha(
    this.code,
    this.name,
  );

  String code;
  String name;

  factory Usaha.fromJson(Map<String, dynamic> json) => Usaha(
    json["code"],
    json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
  };
}

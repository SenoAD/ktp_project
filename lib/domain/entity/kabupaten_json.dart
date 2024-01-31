// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Kabupaten> welcomeFromJson(String str) => List<Kabupaten>.from(json.decode(str).map((x) => Kabupaten.fromJson(x)));

String welcomeToJson(List<Kabupaten> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Kabupaten {
  String id;
  String provinceId;
  String name;
  String altName;
  double latitude;
  double longitude;

  Kabupaten({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.altName,
    required this.latitude,
    required this.longitude,
  });

  factory Kabupaten.fromJson(Map<String, dynamic> json) => Kabupaten(
    id: json["id"],
    provinceId: json["province_id"],
    name: json["name"],
    altName: json["alt_name"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "province_id": provinceId,
    "name": name,
    "alt_name": altName,
    "latitude": latitude,
    "longitude": longitude,
  };
}

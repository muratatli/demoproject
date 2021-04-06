import 'dart:convert';

class SpaceX {
  SpaceX({
    this.patch,
    this.name,
    this.details,
  });

  String patch;
  String name;
  String details;

  factory SpaceX.fromRawJson(String str) => SpaceX.fromJson(json.decode(str));

  factory SpaceX.fromJson(Map<String, dynamic> json) =>
      SpaceX(
        patch: json["links"]["patch"]["large"],
        name: json["name"],
        details: json["details"]==null ? "Detay bilgisi alınamadı":json["details"],
      );
}
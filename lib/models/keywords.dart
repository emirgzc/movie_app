// To parse this JSON data, do
//
//     final keywords = keywordsFromJson(jsonString);

import 'dart:convert';

Keywords keywordsFromJson(String str) => Keywords.fromMap(json.decode(str));

String keywordsToJson(Keywords data) => json.encode(data.toJson());

class Keywords {
    Keywords({
        required this.id,
        required this.keyword,
    });

    int id;
    List<Keyword> keyword;

    factory Keywords.fromMap(Map<String, dynamic> json) => Keywords(
        id: json["id"],
        keyword: List<Keyword>.from(json["keywords"].map((x) => Keyword.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "keywords": List<dynamic>.from(keyword.map((x) => x.toJson())),
    };
}

class Keyword {
    Keyword({
        required this.id,
        required this.name,
    });

    int id;
    String name;

    factory Keyword.fromJson(Map<String, dynamic> json) => Keyword(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

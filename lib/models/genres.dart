// To parse this JSON data, do
//
//     final genres = genresFromMap(jsonString);

import 'dart:convert';

Genres genresFromMap(String str) => Genres.fromMap(json.decode(str));

String genresToMap(Genres data) => json.encode(data.toMap());

class Genres {
  Genres({
    required this.genres,
  });

  List<Genre> genres;

  factory Genres.fromMap(Map<String, dynamic> json) => Genres(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toMap())),
      };
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Genre.fromMap(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

// To parse this JSON data, do
//
//     final castPersonsMovies = castPersonsMoviesFromJson(jsonString);

import 'dart:convert';

CastPersonsMovies castPersonsMoviesFromJson(String str) =>
    CastPersonsMovies.fromJson(json.decode(str));

String castPersonsMoviesToJson(CastPersonsMovies data) =>
    json.encode(data.toJson());

class CastPersonsMovies {
  CastPersonsMovies({
    this.cast,
    this.crew,
    this.id,
  });

  List<Cast>? cast;
  List<Cast>? crew;
  int? id;

  factory CastPersonsMovies.fromJson(Map<String, dynamic> json) =>
      CastPersonsMovies(
        cast: json["cast"] == null
            ? []
            : List<Cast>.from(json["cast"]!.map((x) => Cast.fromJson(x))),
        crew: json["crew"] == null
            ? []
            : List<Cast>.from(json["crew"]!.map((x) => Cast.fromJson(x))),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cast": cast == null
            ? []
            : List<dynamic>.from(cast!.map((x) => x.toJson())),
        "crew": crew == null
            ? []
            : List<dynamic>.from(crew!.map((x) => x.toJson())),
        "id": id,
      };
}

class Cast {
  Cast({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.character,
    this.creditId,
    this.order,
    this.mediaType,
    this.originCountry,
    this.originalName,
    this.firstAirDate,
    this.name,
    this.episodeCount,
    this.department,
    this.job,
  });

  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? character;
  String? creditId;
  int? order;
  String? mediaType;
  List<String>? originCountry;
  String? originalName;
  String? firstAirDate;
  String? name;
  int? episodeCount;
  String? department;
  String? job;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: json["genre_ids"] == null
            ? []
            : List<int>.from(json["genre_ids"]!.map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        mediaType: json["media_type"],
        originCountry: json["origin_country"] == null
            ? []
            : List<String>.from(json["origin_country"]!.map((x) => x)),
        originalName: json["original_name"],
        firstAirDate: json["first_air_date"],
        name: json["name"],
        episodeCount: json["episode_count"],
        department: json["department"],
        job: json["job"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids":
            genreIds == null ? [] : List<dynamic>.from(genreIds!.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "media_type": mediaType,
        "origin_country": originCountry == null
            ? []
            : List<dynamic>.from(originCountry!.map((x) => x)),
        "original_name": originalName,
        "first_air_date": firstAirDate,
        "name": name,
        "episode_count": episodeCount,
        "department": department,
        "job": job,
      };
}

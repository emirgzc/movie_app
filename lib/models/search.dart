// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

import 'dart:convert';

Search searchFromJson(String str) => Search.fromJson(json.decode(str));

String searchToJson(Search data) => json.encode(data.toJson());

class Search {
    Search({
        this.page,
        this.results,
        this.totalPages,
        this.totalResults,
    });

    int? page;
    List<SearchResult>? results;
    int? totalPages;
    int? totalResults;

    factory Search.fromJson(Map<String, dynamic> json) => Search(
        page: json["page"],
        results: json["results"] == null ? [] : List<SearchResult>.from(json["results"]!.map((x) => SearchResult.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class SearchResult {
    SearchResult({
        this.adult,
        this.id,
        this.name,
        this.originalName,
        this.mediaType,
        this.popularity,
        this.gender,
        this.knownForDepartment,
        this.profilePath,
        this.knownFor,
        this.backdropPath,
        this.title,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.posterPath,
        this.genreIds,
        this.releaseDate,
        this.video,
        this.voteAverage,
        this.voteCount,
        this.firstAirDate,
        this.originCountry,
    });

    bool? adult;
    int? id;
    String? name;
    String? originalName;
    String? mediaType;
    double? popularity;
    int? gender;
    String? knownForDepartment;
    String? profilePath;
    List<SearchResult>? knownFor;
    String? backdropPath;
    String? title;
    String? originalLanguage;
    String? originalTitle;
    String? overview;
    String? posterPath;
    List<int>? genreIds;
    DateTime? releaseDate;
    bool? video;
    double? voteAverage;
    int? voteCount;
    DateTime? firstAirDate;
    List<String>? originCountry;

    factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        adult: json["adult"],
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        mediaType: json["media_type"],
        popularity: json["popularity"]?.toDouble(),
        gender: json["gender"],
        knownForDepartment: json["known_for_department"],
        profilePath: json["profile_path"],
        knownFor: json["known_for"] == null ? [] : List<SearchResult>.from(json["known_for"]!.map((x) => SearchResult.fromJson(x))),
        backdropPath: json["backdrop_path"],
        title: json["title"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
        releaseDate: json["release_date"] == null ? null : json["release_date"].toString().isEmpty ? DateTime.now() : DateTime.parse(json["release_date"]),
        
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        firstAirDate: json["first_air_date"] == null ? null : json["first_air_date"].toString().isEmpty ? DateTime.now() : DateTime.parse(json["first_air_date"]), 
        originCountry: json["origin_country"] == null ? [] : List<String>.from(json["origin_country"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "id": id,
        "name": name,
        "original_name": originalName,
        "media_type": mediaType,
        "popularity": popularity,
        "gender": gender,
        "known_for_department": knownForDepartment,
        "profile_path": profilePath,
        "known_for": knownFor == null ? [] : List<dynamic>.from(knownFor!.map((x) => x.toJson())),
        "backdrop_path": backdropPath,
        "title": title,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "genre_ids": genreIds == null ? [] : List<dynamic>.from(genreIds!.map((x) => x)),
        "release_date": "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "first_air_date": "${firstAirDate!.year.toString().padLeft(4, '0')}-${firstAirDate!.month.toString().padLeft(2, '0')}-${firstAirDate!.day.toString().padLeft(2, '0')}",
        "origin_country": originCountry == null ? [] : List<dynamic>.from(originCountry!.map((x) => x)),
    };
}

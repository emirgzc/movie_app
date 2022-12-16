// To parse this JSON data, do
//
//     final images = imagesFromMap(jsonString);

import 'dart:convert';

Images imagesFromMap(String str) => Images.fromMap(json.decode(str));

String imagesToMap(Images data) => json.encode(data.toMap());

class Images {
  Images({
    this.backdrops,
    this.id,
    this.logos,
    this.posters,
  });

  List<Backdrop>? backdrops;
  int? id;
  List<Backdrop>? logos;
  List<Backdrop>? posters;

  factory Images.fromMap(Map<String, dynamic> json) => Images(
        backdrops: List<Backdrop>.from(
            json["backdrops"].map((x) => Backdrop.fromMap(x))),
        id: json["id"],
        logos:
            List<Backdrop>.from(json["logos"].map((x) => Backdrop.fromMap(x))),
        posters: List<Backdrop>.from(
            json["posters"].map((x) => Backdrop.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "backdrops": List<dynamic>.from(backdrops!.map((x) => x.toMap())),
        "id": id,
        "logos": List<dynamic>.from(logos!.map((x) => x.toMap())),
        "posters": List<dynamic>.from(posters!.map((x) => x.toMap())),
      };
}

class Backdrop {
  Backdrop({
    this.aspectRatio,
    this.height,
    this.iso6391,
    this.filePath,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  double? aspectRatio;
  int? height;
  String? iso6391;
  String? filePath;
  double? voteAverage;
  int? voteCount;
  int? width;

  factory Backdrop.fromMap(Map<String, dynamic> json) => Backdrop(
        aspectRatio: json["aspect_ratio"].toDouble(),
        height: json["height"],
        iso6391: json["iso_639_1"] == null ? null : json["iso_639_1"],
        filePath: json["file_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        width: json["width"],
      );

  Map<String, dynamic> toMap() => {
        "aspect_ratio": aspectRatio,
        "height": height,
        "iso_639_1": iso6391 == null ? null : iso6391,
        "file_path": filePath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "width": width,
      };
}

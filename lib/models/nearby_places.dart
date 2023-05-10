// To parse this JSON data, do
//
//     final nearbyPlaces = nearbyPlacesFromMap(jsonString);

import 'dart:convert';

NearbyPlaces nearbyPlacesFromMap(String str) =>
    NearbyPlaces.fromMap(json.decode(str));

String nearbyPlacesToMap(NearbyPlaces data) => json.encode(data.toMap());

class NearbyPlaces {
  List<dynamic>? htmlAttributions;
  String? nextPageToken;
  List<ResultNearbyPlaces>? results;
  String? status;

  NearbyPlaces({
    this.htmlAttributions,
    this.nextPageToken,
    this.results,
    this.status,
  });

  factory NearbyPlaces.fromMap(Map<String, dynamic> json) => NearbyPlaces(
        htmlAttributions: json["html_attributions"] == null
            ? []
            : List<dynamic>.from(json["html_attributions"]!.map((x) => x)),
        nextPageToken: json["next_page_token"],
        results: json["results"] == null
            ? []
            : List<ResultNearbyPlaces>.from(
                json["results"]!.map((x) => ResultNearbyPlaces.fromMap(x))),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "html_attributions": htmlAttributions == null
            ? []
            : List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "next_page_token": nextPageToken,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toMap())),
        "status": status,
      };
}

class ResultNearbyPlaces {
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<Photo>? photos;
  String? placeId;
  String? reference;
  Scope? scope;
  List<String>? types;
  String? vicinity;
  BusinessStatus? businessStatus;
  OpeningHours? openingHours;
  PlusCode? plusCode;
  double? rating;
  int? userRatingsTotal;
  int? priceLevel;

  ResultNearbyPlaces({
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.photos,
    this.placeId,
    this.reference,
    this.scope,
    this.types,
    this.vicinity,
    this.businessStatus,
    this.openingHours,
    this.plusCode,
    this.rating,
    this.userRatingsTotal,
    this.priceLevel,
  });

  factory ResultNearbyPlaces.fromMap(Map<String, dynamic> json) =>
      ResultNearbyPlaces(
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromMap(json["geometry"]),
        icon: json["icon"],
        iconBackgroundColor: json["icon_background_color"],
        iconMaskBaseUri: json["icon_mask_base_uri"],
        name: json["name"],
        photos: json["photos"] == null
            ? []
            : List<Photo>.from(json["photos"]!.map((x) => Photo.fromMap(x))),
        placeId: json["place_id"],
        reference: json["reference"],
        scope: scopeValues.map[json["scope"]]!,
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
        vicinity: json["vicinity"],
        businessStatus: businessStatusValues.map[json["business_status"]]!,
        openingHours: json["opening_hours"] == null
            ? null
            : OpeningHours.fromMap(json["opening_hours"]),
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromMap(json["plus_code"]),
        rating: json["rating"]?.toDouble(),
        userRatingsTotal: json["user_ratings_total"],
        priceLevel: json["price_level"],
      );

  Map<String, dynamic> toMap() => {
        "geometry": geometry?.toMap(),
        "icon": icon,
        "icon_background_color": iconBackgroundColor,
        "icon_mask_base_uri": iconMaskBaseUri,
        "name": name,
        "photos": photos == null
            ? []
            : List<dynamic>.from(photos!.map((x) => x.toMap())),
        "place_id": placeId,
        "reference": reference,
        "scope": scopeValues.reverse[scope],
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
        "vicinity": vicinity,
        "business_status": businessStatusValues.reverse[businessStatus],
        "opening_hours": openingHours?.toMap(),
        "plus_code": plusCode?.toMap(),
        "rating": rating,
        "user_ratings_total": userRatingsTotal,
        "price_level": priceLevel,
      };
}

enum BusinessStatus { OPERATIONAL }

final businessStatusValues =
    EnumValues({"OPERATIONAL": BusinessStatus.OPERATIONAL});

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : Location.fromMap(json["location"]),
        viewport: json["viewport"] == null
            ? null
            : Viewport.fromMap(json["viewport"]),
      );

  Map<String, dynamic> toMap() => {
        "location": location?.toMap(),
        "viewport": viewport?.toMap(),
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromMap(Map<String, dynamic> json) => Viewport(
        northeast: json["northeast"] == null
            ? null
            : Location.fromMap(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : Location.fromMap(json["southwest"]),
      );

  Map<String, dynamic> toMap() => {
        "northeast": northeast?.toMap(),
        "southwest": southwest?.toMap(),
      };
}

class OpeningHours {
  bool? openNow;

  OpeningHours({
    this.openNow,
  });

  factory OpeningHours.fromMap(Map<String, dynamic> json) => OpeningHours(
        openNow: json["open_now"],
      );

  Map<String, dynamic> toMap() => {
        "open_now": openNow,
      };
}

class Photo {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
        height: json["height"],
        htmlAttributions: json["html_attributions"] == null
            ? []
            : List<String>.from(json["html_attributions"]!.map((x) => x)),
        photoReference: json["photo_reference"],
        width: json["width"],
      );

  Map<String, dynamic> toMap() => {
        "height": height,
        "html_attributions": htmlAttributions == null
            ? []
            : List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "photo_reference": photoReference,
        "width": width,
      };
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  factory PlusCode.fromMap(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toMap() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

enum Scope { GOOGLE }

final scopeValues = EnumValues({"GOOGLE": Scope.GOOGLE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

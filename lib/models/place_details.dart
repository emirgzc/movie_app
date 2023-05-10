// To parse this JSON data, do
//
//     final placeDetails = placeDetailsFromMap(jsonString);

import 'dart:convert';

PlaceDetails placeDetailsFromMap(String str) =>
    PlaceDetails.fromMap(json.decode(str));

String placeDetailsToMap(PlaceDetails data) => json.encode(data.toMap());

class PlaceDetails {
  List<dynamic>? htmlAttributions;
  ResultPlaceDetails? result;
  String? status;

  PlaceDetails({
    this.htmlAttributions,
    this.result,
    this.status,
  });

  factory PlaceDetails.fromMap(Map<String, dynamic> json) => PlaceDetails(
        htmlAttributions: json["html_attributions"] == null
            ? []
            : List<dynamic>.from(json["html_attributions"]!.map((x) => x)),
        result: json["result"] == null
            ? null
            : ResultPlaceDetails.fromMap(json["result"]),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "html_attributions": htmlAttributions == null
            ? []
            : List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "result": result?.toMap(),
        "status": status,
      };
}

class ResultPlaceDetails {
  List<AddressComponent>? addressComponents;
  String? adrAddress;
  String? businessStatus;
  CurrentOpeningHours? currentOpeningHours;
  String? formattedAddress;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  OpeningHours? openingHours;
  List<Photo>? photos;
  String? placeId;
  PlusCode? plusCode;
  double? rating;
  String? reference;
  List<Review>? reviews;
  List<String>? types;
  String? url;
  int? userRatingsTotal;
  int? utcOffset;
  String? vicinity;
  bool? wheelchairAccessibleEntrance;

  ResultPlaceDetails({
    this.addressComponents,
    this.adrAddress,
    this.businessStatus,
    this.currentOpeningHours,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.plusCode,
    this.rating,
    this.reference,
    this.reviews,
    this.types,
    this.url,
    this.userRatingsTotal,
    this.utcOffset,
    this.vicinity,
    this.wheelchairAccessibleEntrance,
  });

  factory ResultPlaceDetails.fromMap(Map<String, dynamic> json) =>
      ResultPlaceDetails(
        addressComponents: json["address_components"] == null
            ? []
            : List<AddressComponent>.from(json["address_components"]!
                .map((x) => AddressComponent.fromMap(x))),
        adrAddress: json["adr_address"],
        businessStatus: json["business_status"],
        currentOpeningHours: json["current_opening_hours"] == null
            ? null
            : CurrentOpeningHours.fromMap(json["current_opening_hours"]),
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromMap(json["geometry"]),
        icon: json["icon"],
        iconBackgroundColor: json["icon_background_color"],
        iconMaskBaseUri: json["icon_mask_base_uri"],
        name: json["name"],
        openingHours: json["opening_hours"] == null
            ? null
            : OpeningHours.fromMap(json["opening_hours"]),
        photos: json["photos"] == null
            ? []
            : List<Photo>.from(json["photos"]!.map((x) => Photo.fromMap(x))),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromMap(json["plus_code"]),
        rating: json["rating"]?.toDouble(),
        reference: json["reference"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(json["reviews"]!.map((x) => Review.fromMap(x))),
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
        url: json["url"],
        userRatingsTotal: json["user_ratings_total"],
        utcOffset: json["utc_offset"],
        vicinity: json["vicinity"],
        wheelchairAccessibleEntrance: json["wheelchair_accessible_entrance"],
      );

  Map<String, dynamic> toMap() => {
        "address_components": addressComponents == null
            ? []
            : List<dynamic>.from(addressComponents!.map((x) => x.toMap())),
        "adr_address": adrAddress,
        "business_status": businessStatus,
        "current_opening_hours": currentOpeningHours?.toMap(),
        "formatted_address": formattedAddress,
        "geometry": geometry?.toMap(),
        "icon": icon,
        "icon_background_color": iconBackgroundColor,
        "icon_mask_base_uri": iconMaskBaseUri,
        "name": name,
        "opening_hours": openingHours?.toMap(),
        "photos": photos == null
            ? []
            : List<dynamic>.from(photos!.map((x) => x.toMap())),
        "place_id": placeId,
        "plus_code": plusCode?.toMap(),
        "rating": rating,
        "reference": reference,
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toMap())),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
        "url": url,
        "user_ratings_total": userRatingsTotal,
        "utc_offset": utcOffset,
        "vicinity": vicinity,
        "wheelchair_accessible_entrance": wheelchairAccessibleEntrance,
      };
}

class AddressComponent {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromMap(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}

class CurrentOpeningHours {
  bool? openNow;
  List<CurrentOpeningHoursPeriod>? periods;
  List<String>? weekdayText;

  CurrentOpeningHours({
    this.openNow,
    this.periods,
    this.weekdayText,
  });

  factory CurrentOpeningHours.fromMap(Map<String, dynamic> json) =>
      CurrentOpeningHours(
        openNow: json["open_now"],
        periods: json["periods"] == null
            ? []
            : List<CurrentOpeningHoursPeriod>.from(json["periods"]!
                .map((x) => CurrentOpeningHoursPeriod.fromMap(x))),
        weekdayText: json["weekday_text"] == null
            ? []
            : List<String>.from(json["weekday_text"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "open_now": openNow,
        "periods": periods == null
            ? []
            : List<dynamic>.from(periods!.map((x) => x.toMap())),
        "weekday_text": weekdayText == null
            ? []
            : List<dynamic>.from(weekdayText!.map((x) => x)),
      };
}

class CurrentOpeningHoursPeriod {
  PurpleClose? close;
  PurpleClose? open;

  CurrentOpeningHoursPeriod({
    this.close,
    this.open,
  });

  factory CurrentOpeningHoursPeriod.fromMap(Map<String, dynamic> json) =>
      CurrentOpeningHoursPeriod(
        close:
            json["close"] == null ? null : PurpleClose.fromMap(json["close"]),
        open: json["open"] == null ? null : PurpleClose.fromMap(json["open"]),
      );

  Map<String, dynamic> toMap() => {
        "close": close?.toMap(),
        "open": open?.toMap(),
      };
}

class PurpleClose {
  DateTime? date;
  int? day;
  String? time;

  PurpleClose({
    this.date,
    this.day,
    this.time,
  });

  factory PurpleClose.fromMap(Map<String, dynamic> json) => PurpleClose(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        day: json["day"],
        time: json["time"],
      );

  Map<String, dynamic> toMap() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "day": day,
        "time": time,
      };
}

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
  List<OpeningHoursPeriod>? periods;
  List<String>? weekdayText;

  OpeningHours({
    this.openNow,
    this.periods,
    this.weekdayText,
  });

  factory OpeningHours.fromMap(Map<String, dynamic> json) => OpeningHours(
        openNow: json["open_now"],
        periods: json["periods"] == null
            ? []
            : List<OpeningHoursPeriod>.from(
                json["periods"]!.map((x) => OpeningHoursPeriod.fromMap(x))),
        weekdayText: json["weekday_text"] == null
            ? []
            : List<String>.from(json["weekday_text"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "open_now": openNow,
        "periods": periods == null
            ? []
            : List<dynamic>.from(periods!.map((x) => x.toMap())),
        "weekday_text": weekdayText == null
            ? []
            : List<dynamic>.from(weekdayText!.map((x) => x)),
      };
}

class OpeningHoursPeriod {
  FluffyClose? close;
  FluffyClose? open;

  OpeningHoursPeriod({
    this.close,
    this.open,
  });

  factory OpeningHoursPeriod.fromMap(Map<String, dynamic> json) =>
      OpeningHoursPeriod(
        close:
            json["close"] == null ? null : FluffyClose.fromMap(json["close"]),
        open: json["open"] == null ? null : FluffyClose.fromMap(json["open"]),
      );

  Map<String, dynamic> toMap() => {
        "close": close?.toMap(),
        "open": open?.toMap(),
      };
}

class FluffyClose {
  int? day;
  String? time;

  FluffyClose({
    this.day,
    this.time,
  });

  factory FluffyClose.fromMap(Map<String, dynamic> json) => FluffyClose(
        day: json["day"],
        time: json["time"],
      );

  Map<String, dynamic> toMap() => {
        "day": day,
        "time": time,
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

class Review {
  String? authorName;
  String? authorUrl;
  String? language;
  String? originalLanguage;
  String? profilePhotoUrl;
  int? rating;
  String? relativeTimeDescription;
  String? text;
  int? time;
  bool? translated;

  Review({
    this.authorName,
    this.authorUrl,
    this.language,
    this.originalLanguage,
    this.profilePhotoUrl,
    this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
    this.translated,
  });

  factory Review.fromMap(Map<String, dynamic> json) => Review(
        authorName: json["author_name"],
        authorUrl: json["author_url"],
        language: json["language"],
        originalLanguage: json["original_language"],
        profilePhotoUrl: json["profile_photo_url"],
        rating: json["rating"],
        relativeTimeDescription: json["relative_time_description"],
        text: json["text"],
        time: json["time"],
        translated: json["translated"],
      );

  Map<String, dynamic> toMap() => {
        "author_name": authorName,
        "author_url": authorUrl,
        "language": language,
        "original_language": originalLanguage,
        "profile_photo_url": profilePhotoUrl,
        "rating": rating,
        "relative_time_description": relativeTimeDescription,
        "text": text,
        "time": time,
        "translated": translated,
      };
}

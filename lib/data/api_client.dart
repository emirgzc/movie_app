import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/exceptions.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/models/collection.dart';
import 'package:movie_app/models/comment.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/nearby_places.dart';
import 'package:movie_app/models/place_details.dart';
import 'package:movie_app/models/search.dart';
import 'package:movie_app/models/to_watch.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';

abstract class IApiClient {
  Future<List<Result>?> trendData(String mediaType, Locale locale);
  Future<List<Result>?> getMovieData(Locale locale, {int page = 1, String dataWay = 'popular', String type = 'movie'});
  Future<List<Result>?> similarMoviesData(int movieId, Locale locale, {int page = 1, String type = 'movie'});
  Future<Images?> getImages(int movieId, {String type = 'movie'});
  Future<Trailer?> getTrailer(int movieId, Locale locale, {String type = 'movie'});
  Future<DetailMovie?> detailMovieData(int movieId, Locale locale);
  Future<Comment?> getComment(int movieId, Locale locale, {String type = 'movie'});
  Future<Genres?> genres(Locale locale);
  Future<Collection?> collectionData(int collectionId, Locale locale);
  Future<Credits?> getCredits(int movieId, Locale locale, {String type = 'movie'});
  Future<CastPersonsMovies?> castPersonsCombined(int personId, Locale locale, {String personType = 'combined_credits'});
  Future<Search?> search(Locale locale, {String query = "a", int page = 1});
  Future<TvDetail?> detailTvData(int movieId, Locale locale);
  Future<WhereToWatch?> getToWatch(int movieId, {String type = 'movie'});
  Future<PlaceDetails?> getPlaceDetails(String placeId);
  Future<NearbyPlaces?> getNearbyPlaces(double lat, double lng, double radius);
}

class ApiClient implements IApiClient {
  final String _apiKey = "2444ef19302975166c670f0e507218ec";
  final String _baseuRL = "https://api.themoviedb.org/3";
  String googleApiKey = "AIzaSyCQ7MEnOslIYbQOmlLUzLCA9HZN_uvGWdo";

  Future<List<Result>?> trendData(String mediaType, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";
    String baseUrl = '$_baseuRL/trending/$mediaType/week?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results?.removeWhere((element) => element.posterPath == null);
        mapApiModel.results?.sort((a, b) {
          return b.releaseDate?.compareTo(a.releaseDate ?? DateTime.now()) ?? 0;
        });

        return mapApiModel.results;
      } else {
        throw Exception('trendData apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<List<Result>?> getMovieData(Locale locale, {int page = 1, String dataWay = 'popular', String type = 'movie'}) async {
    String _languageKey = locale.languageCode == LanguageCodes.tr.name ? "tr-TR" : "en-US";
    String baseUrl = '$_baseuRL/$type/$dataWay?api_key=$_apiKey&language=$_languageKey&page=$page';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results?.removeWhere((element) => element.posterPath == null);
        mapApiModel.results?.sort((a, b) {
          return b.releaseDate?.compareTo(a.releaseDate ?? DateTime.now()) ?? 0;
        });

        return mapApiModel.results;
      } else {
        throw Exception('(get movie data) ($dataWay)($type) apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<List<Result>?> similarMoviesData(
    int movieId,
    Locale locale, {
    int page = 1,
    String type = 'movie',
  }) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/$type/$movieId/recommendations?api_key=$_apiKey&language=$_languageKey&page=$page';

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results?.sort((a, b) {
          return b.releaseDate?.compareTo(a.releaseDate ?? DateTime.now()) ?? 0;
        });

        // resmi olmayan filmeleri kaldır
        mapApiModel.results?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('similarMoviesData ($type) apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<DetailMovie?> detailMovieData(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/movie/$movieId?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint("---$responseJson");
        DetailMovie mapApiModel = DetailMovie.fromMap(responseJson);
        return mapApiModel;
      } else {
        throw Exception('detailMovieData apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<Images?> getImages(
    int movieId, {
    String type = 'movie',
  }) async {
    String baseUrl = '$_baseuRL/$type/$movieId/images?api_key=$_apiKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Images mapApiModel = Images.fromMap(responseJson);

        return mapApiModel;
      } else {
        throw Exception('getImages apide ($type) hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<Trailer?> getTrailer(
    int movieId,
    Locale locale, {
    String type = 'movie',
  }) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/$type/$movieId/videos?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trailer mapApiModel = Trailer.fromJson(responseJson);

        return mapApiModel;
      } else {
        throw Exception('getTrailer ($type) apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<Comment?> getComment(int movieId, Locale locale, {String type = 'movie'}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/$type/$movieId/reviews?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Comment mapApiModel = Comment.fromJson(responseJson);

        return mapApiModel;
      } else {
        throw Exception('getComment ($type) apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<Genres?> genres(Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/genre/movie/list?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;

        Genres mapApiModel = Genres.fromMap(responseJson);

        return mapApiModel;
      } else {
        throw Exception('genres apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<Collection?> collectionData(int collectionId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/collection/$collectionId?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;

        Collection mapApiModel = Collection.fromJson(responseJson);

        return mapApiModel;
      } else {
        throw Exception('collection apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<Credits?> getCredits(
    int movieId,
    Locale locale, {
    String type = 'movie',
  }) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/$type/$movieId/credits?api_key=$_apiKey&language=$_languageKey';

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;

        Credits mapApiModel = Credits.fromMap(responseJson);

        // resmi olmayanalrı kaldır
        mapApiModel.cast.removeWhere(
          (element) => (element.profilePath == null),
        );

        return mapApiModel;
      } else {
        throw Exception('credits ($type) apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  // oyuncunun oynadigi filmler
  Future<CastPersonsMovies?> castPersonsCombined(
    int personId,
    Locale locale, {
    String personType = 'combined_credits',
  }) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/person/$personId/$personType?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;

        CastPersonsMovies mapApiModel = CastPersonsMovies.fromJson(responseJson);
        if (mapApiModel.cast != null) {
          mapApiModel.cast?.removeWhere((element) => element.posterPath == null);
          mapApiModel.cast?.sort((a, b) {
            return b.releaseDate?.compareTo(a.releaseDate ?? '05.05.2022') ?? 0;
          });
        }

        return mapApiModel;
      } else {
        throw Exception('CastPersonsMovies ($personType) apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<Search?> search(Locale locale, {String query = "a", int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/search/multi?api_key=$_apiKey&language=$_languageKey&query=$query&page=$page&include_adult=false';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;

        Search mapApiModel = Search.fromJson(responseJson);

        return mapApiModel;
      } else {
        throw Exception('search apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<TvDetail?> detailTvData(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl = '$_baseuRL/tv/$movieId?api_key=$_apiKey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint("---$responseJson");
        TvDetail mapApiModel = TvDetail.fromJson(responseJson);
        return mapApiModel;
      } else {
        throw Exception('detailMovieData apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<WhereToWatch?> getToWatch(int movieId, {String type = 'movie'}) async {
    String baseUrl = '$_baseuRL/$type/$movieId/watch/providers?api_key=$_apiKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': _apiKey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        WhereToWatch mapApiModel = WhereToWatch.fromJson(responseJson);
        return mapApiModel;
      } else {
        throw Exception('getToWatch ($type) apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<NearbyPlaces?> getNearbyPlaces(double lat, double lng, double radius) async {
    var url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=cinema&location=$lat,$lng&radius=$radius&key=$googleApiKey",
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        NearbyPlaces mapApiModel = NearbyPlaces.fromMap(responseJson);
        return mapApiModel;
      } else {
        throw Exception('nearbyplaces apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    var url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey",
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        PlaceDetails mapApiModel = PlaceDetails.fromMap(responseJson);
        return mapApiModel;
      } else {
        throw Exception('place details apide hata var');
      }
    } catch (e) {
      throw ApiException.fromMessage(title: 'Hata', message: 'mesaj');
    }
  }
}

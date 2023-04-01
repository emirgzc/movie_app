import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/models/collection.dart';
import 'package:movie_app/models/comment.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/keywords.dart';
import 'package:movie_app/models/search.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';

class MovieApiClient {
  final String apikey = "2444ef19302975166c670f0e507218ec";
  final String _baseuRL = "https://api.themoviedb.org/3";
  // final String _languageKey = "language=tr-TR";

  Future<List<Result>?> trendData(String mediaType, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";
    String baseUrl =
        '$_baseuRL/trending/$mediaType/week?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('trendData apide hata var');
      }
    } catch (e) {
      debugPrint("hata trendData $e");
    }
    return null;
  }

  Future<List<Result>?> popularMovieData(Locale locale, {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/popular?api_key=$apikey&language=$_languageKey&page=$page';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('popularData apide hata var');
      }
    } catch (e) {
      debugPrint("hata popularMovieData $e");
    }
    return null;
  }

  Future<List<Result>?> nowPlayingMovieData(Locale locale,
      {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/now_playing?api_key=$apikey&language=$_languageKey&page=$page';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('popularData apide hata var');
      }
    } catch (e) {
      debugPrint("hata nowPlayingMovieData $e");
    }
    return null;
  }

  Future<List<Result>?> topRatedMovieData(Locale locale, {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/top_rated?api_key=$apikey&language=$_languageKey&page=$page';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('topRatedData apide hata var');
      }
    } catch (e) {
      debugPrint("hata topRatedMovieData $e");
    }
    return null;
  }

  Future<List<Result>?> upComingMovieData(Locale locale, {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/upcoming?api_key=$apikey&language=$_languageKey&page=$page';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('upComingData apide hata var');
      }
    } catch (e) {
      debugPrint("hata upComingMovieData $e");
    }
    return null;
  }

  Future<List<Result>?> similarMoviesData(int movieId, Locale locale,
      {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/$movieId/recommendations?api_key=$apikey&language=$_languageKey&page=$page';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        Trend mapApiModel = Trend.fromMap(responseJson);

        // resmi olmayan filmeleri kaldır
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('similarMoviesData apide hata var');
      }
    } catch (e) {
      debugPrint("hata similarMoviesData $e");
    }
    return null;
  }

  Future<DetailMovie?> detailMovieData(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/$movieId?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
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
      debugPrint("hata detailMovieData $e");
    }
    return null;
  }

  Future<Images?> getImages(int movieId) async {
    String baseUrl = '$_baseuRL/movie/$movieId/images?api_key=$apikey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Images mapApiModel = Images.fromMap(responseJson);

        return mapApiModel;
      } else {
        throw Exception('getImages apide hata var');
      }
    } catch (e) {
      debugPrint("hata getImages getImages $e");
    }
    return null;
  }

  Future<Trailer?> getTrailer(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/$movieId/videos?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Trailer mapApiModel = Trailer.fromJson(responseJson);

        return mapApiModel;
      } else {
        throw Exception('getTrailer apide hata var');
      }
    } catch (e) {
      debugPrint("hata getTrailer $e");
    }
    return null;
  }

  Future<Comment?> getComment(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/$movieId/reviews?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Comment mapApiModel = Comment.fromJson(responseJson);

        return mapApiModel;
      } else {
        throw Exception('getComment apide hata var');
      }
    } catch (e) {
      debugPrint("hata getComment $e");
    }
    return null;
  }

  Future<Genres?> genres(Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/genre/movie/list?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
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
      debugPrint("hata genres $e");
    }
    return null;
  }

  Future<Collection?> collectionData(int collectionId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/collection/$collectionId?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
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
      debugPrint("hata collectionData $e");
    }
    return null;
  }

  Future<Credits?> credits(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/$movieId/credits?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
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
        throw Exception('credits apide hata var');
      }
    } catch (e) {
      debugPrint("hata credits $e");
    }
    return null;
  }

  // oyuncunun oynadigi filmler
  Future<CastPersonsMovies?> castPersonsCombined(
      int personId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/person/$personId/combined_credits?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;

        CastPersonsMovies mapApiModel =
            CastPersonsMovies.fromJson(responseJson);
        if (mapApiModel.cast != null) {
          mapApiModel.cast
              ?.removeWhere((element) => element.posterPath == null);
        }

        return mapApiModel;
      } else {
        throw Exception('CastPersonsMovies apide hata var');
      }
    } catch (e) {
      debugPrint("hata castPersonsCombined $e");
    }
    return null;
  }

  Future<Search?> search(Locale locale,
      {String query = "a", int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/search/multi?api_key=$apikey&language=$_languageKey&query=$query&page=$page&include_adult=false';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
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
      debugPrint("search search $e");
    }
    return null;
  }

  Future<List<Keyword>?> keywords(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/movie/$movieId/keywords?api_key=$apikey&language=$_languageKey';
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'api_key': apikey,
        },
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body) as Map<String, dynamic>;
        //debugPrint(responseJson.toString());
        Keywords mapApiModel = Keywords.fromMap(responseJson);

        return mapApiModel.keyword;
      } else {
        throw Exception('keywords apide hata var');
      }
    } catch (e) {
      debugPrint("hata keywords $e");
    }
    return null;
  }
}

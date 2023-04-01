import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/models/comment.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:http/http.dart' as http;

class TvApiClient {
  final String apikey = "2444ef19302975166c670f0e507218ec";
  final String _baseuRL = "https://api.themoviedb.org/3";
  // final String _languageKey = "language=tr-TR";

  Future<List<Result>?> topRatedTvData(Locale locale, {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/top_rated?api_key=$apikey&langauge=$_languageKey&page=$page';
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
        throw Exception('topRatedTvData apide hata var');
      }
    } catch (e) {
      debugPrint("hata topRatedTvData $e");
    }
    return null;
  }

  Future<List<Result>?> popularTvData(Locale locale, {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/popular?api_key=$apikey&language=$_languageKey&page=$page';
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
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('popularTvData apide hata var');
      }
    } catch (e) {
      debugPrint("hata popularTvData $e");
    }
    return null;
  }

  Future<List<Result>?> onTheAirTvData(Locale locale, {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/on_the_air?api_key=$apikey&language=$_languageKey&page=$page';
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
        mapApiModel.results
            ?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('onTheAirTvData apide hata var');
      }
    } catch (e) {
      debugPrint("hata onTheAirTvData $e");
    }
    return null;
  }

  Future<TvDetail?> detailMovieData(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/$movieId?api_key=$apikey&language=$_languageKey';
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
        TvDetail mapApiModel = TvDetail.fromJson(responseJson);
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
    String baseUrl = '$_baseuRL/tv/$movieId/images?api_key=$apikey';
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
      debugPrint("hata getImages $e");
    }
    return null;
  }

  Future<Trailer?> getTrailer(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/$movieId/videos?api_key=$apikey&language=$_languageKey';
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

  Future<List<Result>?> similarMoviesData(int movieId, Locale locale,
      {int page = 1}) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/$movieId/recommendations?api_key=$apikey&language=$_languageKey&page=$page';
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

  Future<Credits?> credits(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/$movieId/credits?api_key=$apikey&language=$_languageKey';
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

  Future<CastPersonsMovies?> castPersonsMovies(
      int personId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/person/$personId/tv_credits?api_key=$apikey&language=$_languageKey';
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
      debugPrint("hata castPersonsMovies $e");
    }
    return null;
  }

  Future<Comment?> getComment(int movieId, Locale locale) async {
    String _languageKey = locale.languageCode == "tr" ? "tr-TR" : "en-US";

    String baseUrl =
        '$_baseuRL/tv/$movieId/reviews?api_key=$apikey&language=$_languageKey';
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
}

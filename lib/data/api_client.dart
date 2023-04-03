import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/models/collection.dart';
import 'package:movie_app/models/comment.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/search.dart';
import 'package:movie_app/models/to_watch.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';

class ApiClient {
  final String _apiKey = "2444ef19302975166c670f0e507218ec";
  final String _baseuRL = "https://api.themoviedb.org/3";

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

        return mapApiModel.results;
      } else {
        throw Exception('trendData apide hata var');
      }
    } catch (e) {
      debugPrint("hata trendData $e");
    }
    return null;
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

        return mapApiModel.results;
      } else {
        throw Exception('(get movie data) ($dataWay)($type) apide hata var');
      }
    } catch (e) {
      debugPrint("Exception for (get movie data) ($dataWay)($type) $e");
    }
    return null;
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

        // resmi olmayan filmeleri kaldır
        mapApiModel.results?.removeWhere((element) => element.posterPath == null);

        return mapApiModel.results;
      } else {
        throw Exception('similarMoviesData ($type) apide hata var');
      }
    } catch (e) {
      debugPrint("hata similarMoviesData ($type) $e");
    }
    return null;
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
      debugPrint("hata detailMovieData $e");
    }
    return null;
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
      debugPrint("hata getImages ($type) getImages $e");
    }
    return null;
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
      debugPrint("hata ($type) getTrailer $e");
    }
    return null;
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
      debugPrint("hata ($type) getComment $e");
    }
    return null;
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
      debugPrint("hata genres $e");
    }
    return null;
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
      debugPrint("hata collectionData $e");
    }
    return null;
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
      debugPrint("hata ($type) credits $e");
    }
    return null;
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
        }

        return mapApiModel;
      } else {
        throw Exception('CastPersonsMovies ($personType) apide hata var');
      }
    } catch (e) {
      debugPrint("hata ($personType) castPersonsCombined $e");
    }
    return null;
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
      debugPrint("search search $e");
    }
    return null;
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
      debugPrint("hata detailMovieData $e");
    }
    return null;
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
      debugPrint("hata getToWatch ($type) $e");
    }
    return null;
  }
}

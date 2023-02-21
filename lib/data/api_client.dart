import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';

class ApiClient {
  final String apikey = "2444ef19302975166c670f0e507218ec";

  Future<List<Result>?> trendData() async {
    String baseUrl =
        'https://api.themoviedb.org/3/trending/all/day?api_key=$apikey&language=tr-TR';
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

        return mapApiModel.results;
      } else {
        throw Exception('trendData apide hata var');
      }
    } catch (e) {
      debugPrint("hata $e");
    }
    return null;
  }

  Future<List<Result>?> popularData() async {
    String baseUrl =
        'https://api.themoviedb.org/3/movie/popular?api_key=$apikey&language=tr-TR';
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

        return mapApiModel.results;
      } else {
        throw Exception('popularData apide hata var');
      }
    } catch (e) {
      debugPrint("hata $e");
    }
    return null;
  }

  Future<List<Result>?> topRatedData() async {
    String baseUrl =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey&language=tr-TR';
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

        return mapApiModel.results;
      } else {
        throw Exception('topRatedData apide hata var');
      }
    } catch (e) {
      debugPrint("hata $e");
    }
    return null;
  }

  Future<List<Result>?> upComingData() async {
    String baseUrl =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey&language=tr-TR';
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

        return mapApiModel.results;
      } else {
        throw Exception('upComingData apide hata var');
      }
    } catch (e) {
      debugPrint("hata $e");
    }
    return null;
  }

  Future<DetailMovie?> detailMovieData(int movieId) async {
    String baseUrl =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$apikey&language=tr-TR';
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
      debugPrint("hata $e");
    }
    return null;
  }

  Future<Images?> getImages(int movieId) async {
    String baseUrl =
        'https://api.themoviedb.org/3/movie/$movieId/images?api_key=$apikey';
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
      debugPrint("hata $e");
    }
    return null;
  }

  Future<Trailer?> getTrailer(int movieId) async {
    String baseUrl =
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apikey&language=en-US';
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
      debugPrint("hata $e");
    }
    return null;
  }
}

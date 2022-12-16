import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/trendins_movie.dart';

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
        debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);

        return mapApiModel.results;
      } else {
        throw Exception('getMaps apide hata var');
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
        debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);

        return mapApiModel.results;
      } else {
        throw Exception('getMaps apide hata var');
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
        debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);

        return mapApiModel.results;
      } else {
        throw Exception('getMaps apide hata var');
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
        debugPrint(responseJson.toString());
        Trend mapApiModel = Trend.fromMap(responseJson);

        return mapApiModel.results;
      } else {
        throw Exception('getMaps apide hata var');
      }
    } catch (e) {
      debugPrint("hata $e");
    }
    return null;
  }
}

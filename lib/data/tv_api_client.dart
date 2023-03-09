import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/models/tv.dart';
import 'package:http/http.dart' as http;

class TvApiClient {
  final String apikey = "2444ef19302975166c670f0e507218ec";
  final String _baseuRL = "https://api.themoviedb.org/3";
  final String _languageKey = "language=tr-TR";

  Future<List<TVResult>?> topRatedTvData() async {
    String baseUrl = '$_baseuRL/tv/top_rated?api_key=$apikey&$_languageKey';
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
        Tv mapApiModel = Tv.fromMap(responseJson);

        return mapApiModel.results;
      } else {
        throw Exception('trendData apide hata var');
      }
    } catch (e) {
      debugPrint("hata $e");
    }
    return null;
  }
}

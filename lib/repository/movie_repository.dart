import 'dart:ui';

import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/data/api_client_abstract.dart';
import 'package:movie_app/locator.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/to_watch.dart';
import 'package:movie_app/models/search.dart';
import 'package:movie_app/models/place_details.dart';
import 'package:movie_app/models/nearby_places.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/comment.dart';
import 'package:movie_app/models/collection.dart';
import 'package:movie_app/models/cast_persons_movies.dart';

class MovieRepository extends IApiClient {
  IApiClient _apiClient = locator<ApiClient>();

  MovieRepository._();

  static MovieRepository? _instance;

  static MovieRepository get instance{
    _instance ??= MovieRepository._();
    return _instance!;
  }

  @override
  Future<CastPersonsMovies?> castPersonsCombined(int personId, Locale locale, {String personType = 'combined_credits'}) async {
    try {
      final data = await _apiClient.castPersonsCombined(personId, locale, personType: personType);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Collection?> collectionData(int collectionId, Locale locale) async {
    try {
      final data = await _apiClient.collectionData(collectionId, locale);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DetailMovie?> detailMovieData(int movieId, Locale locale) async {
    try {
      final data = await _apiClient.detailMovieData(movieId, locale);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TvDetail?> detailTvData(int movieId, Locale locale) async {
    try {
      final data = await _apiClient.detailTvData(movieId, locale);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Genres?> genres(Locale locale) async {
    try {
      final data = await _apiClient.genres(locale);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Comment?> getComment(int movieId, Locale locale, {String type = 'movie'}) async {
    try {
      final data = await _apiClient.getComment(movieId, locale, type: type);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Credits?> getCredits(int movieId, Locale locale, {String type = 'movie'}) async {
    try {
      final data = await _apiClient.getCredits(movieId, locale, type: type);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Images?> getImages(int movieId, {String type = 'movie'}) async {
    try {
      final data = await _apiClient.getImages(movieId, type: type);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Result>?> getMovieData(Locale locale, {int page = 1, String dataWay = 'popular', String type = 'movie'}) async {
    try {
      final data = await _apiClient.getMovieData(locale, page: page, dataWay: dataWay, type: type);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<NearbyPlaces?> getNearbyPlaces(double lat, double lng, double radius) async {
    try {
      final data = await _apiClient.getNearbyPlaces(lat, lng, radius);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final data = await _apiClient.getPlaceDetails(placeId);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WhereToWatch?> getToWatch(int movieId, {String type = 'movie'}) async {
    try {
      final data = await _apiClient.getToWatch(movieId, type:   type);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Trailer?> getTrailer(int movieId, Locale locale, {String type = 'movie'}) async {
    try {
      final data = await _apiClient.getTrailer(movieId, locale, type: type);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Search?> search(Locale locale, {String query = "a", int page = 1}) async {
    try {
      final data = await _apiClient.search(locale, query: query, page: page);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Result>?> similarMoviesData(int movieId, Locale locale, {int page = 1, String type = 'movie'}) async {
    try {
      final data = await _apiClient.similarMoviesData(movieId, locale, page: page, type: type);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Result>?> trendData(String mediaType, Locale locale) async {
    try {
      final data = await _apiClient.trendData(mediaType, locale);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}

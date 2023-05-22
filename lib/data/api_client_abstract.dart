import 'package:flutter/material.dart';
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
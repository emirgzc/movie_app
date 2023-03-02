import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/list_page_shimmer.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/pages/cast_persons_movies_page.dart';
import 'package:movie_app/pages/credits_page.dart';
import 'package:movie_app/pages/image_page.dart';
import 'package:movie_app/pages/list_page.dart';
import 'package:movie_app/pages/movie_detail_page.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/search_page.dart';
import 'package:movie_app/pages/trailer_page.dart';

class RouteGenerator {
  static Route<dynamic>? _generateRoute(
      Widget togoPage, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return MaterialPageRoute(
          builder: (context) => togoPage, settings: settings);
    } else {
      return CupertinoPageRoute(
          builder: (context) => togoPage, settings: settings);
    }
  }

  static Route<dynamic>? routeGenrator(RouteSettings settings) {
    switch (settings.name) {

      // home page
      case "/":
        return _generateRoute(MoviePage(), settings);

      // detail page
      case "/detailPage":
        return CupertinoPageRoute(
            builder: (context) =>
                MovieDetailPage(movieId: settings.arguments as int),
            settings: settings);

      // image page
      case "/imagePage":
        return _generateRoute(
          ImagePage(
            imageUrls: (settings.arguments as List)[0] as List<String>,
            clickedIndex: (settings.arguments as List)[1] as int,
          ),
          settings,
        );

      // tariler page
      case "/trailerPage":
        return _generateRoute(
          TrailerPage(
              id: (settings.arguments as List)[0] as int,
              videoURL:
                  (settings.arguments as List)[1] as List<List<Results>?>?),
          settings,
        );

      // movie list page
      case "/listPage":
        return _generateRoute(
          ListPage(
            clickedListName: settings.arguments as String,
          ),
          settings,
        );

      // casetPersonsMovies list page
      case "/castPersonsMoviesPage":
        return _generateRoute(
          CastPersonsMoviesPage(
            personId: (settings.arguments as List)[0] as int,
            personName: (settings.arguments as List)[1] as String,
          ),
          settings,
        );

      // search page
      case "/searchPage":
        return CupertinoPageRoute(
            builder: (context) => const SearchPage(), settings: settings);

      // unknown page
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("Unknown Route"),
            ),
            body: const Center(
              child: Text("404"),
            ),
          ),
        );
    }
  }
}

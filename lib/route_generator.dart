import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/pages.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/pages/cast_persons_movies_page.dart';
import 'package:movie_app/pages/category_page.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/list_page.dart';
import 'package:movie_app/pages/movie_detail_page.dart';
import 'package:movie_app/pages/search_page.dart';
import 'package:movie_app/pages/trailer_page.dart';
import 'package:movie_app/pages/tv_detail_page.dart';
import 'package:movie_app/pages/tv_page.dart';

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
      case Pages.homePage:
        return _generateRoute(const HomePage(), settings);

      case Pages.movieDetailPage:
        return CupertinoPageRoute(
            builder: (context) =>
                MovieDetailPage(movieId: settings.arguments as int),
            settings: settings);

      case Pages.tvDetailPage:
        return CupertinoPageRoute(
            builder: (context) =>
                TVDetailPage(movieId: settings.arguments as int),
            settings: settings);

      case Pages.trailerPage:
        return _generateRoute(
          TrailerPage(
              id: (settings.arguments as List)[0] as int,
              videoURL:
                  (settings.arguments as List)[1] as List<List<Results>?>?),
          settings,
        );

      case Pages.listPage:
        return _generateRoute(
          ListPage(
            clickedListType: settings.arguments as ListType,
          ),
          settings,
        );

      case Pages.castPersonsMoviesPage:
        return _generateRoute(
          CastPersonsMoviesPage(
            personId: (settings.arguments as List)[0] as int,
            personName: (settings.arguments as List)[1] as String,
          ),
          settings,
        );

      case Pages.categoryPage:
        return _generateRoute(
          CategoryPage(
            genreId: settings.arguments as int,
          ),
          settings,
        );

      case Pages.searchPage:
        return CupertinoPageRoute(
            builder: (context) => const SearchPage(), settings: settings);

      case Pages.tvPage:
        return CupertinoPageRoute(
            builder: (context) => const TVPage(), settings: settings);

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

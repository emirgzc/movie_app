import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/pages/image_page.dart';
import 'package:movie_app/pages/movie_detail_page.dart';
import 'package:movie_app/pages/movie_detail_page_yeni.dart';
import 'package:movie_app/pages/movie_page.dart';

class RouteGenerator {
  static Route<dynamic>? _generateRoute(
      Widget togoPage, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return CupertinoPageRoute(
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
        return _generateRoute(const MovieDetailPageYeni(), settings);

      // detail page
      case "/detailPage":
        return _generateRoute(
          MovieDetailPage(movieId: settings.arguments as int),
          settings,
        );

      // image page
      case "/imagePage":
        return _generateRoute(
          ImagePage(
            imageUrls: (settings.arguments as List)[0] as List<String>,
            clickedIndex: (settings.arguments as List)[1] as int,
          ),
          settings,
        );

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

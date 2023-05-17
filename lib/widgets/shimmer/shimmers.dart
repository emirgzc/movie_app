import 'package:flutter/material.dart';
import 'package:movie_app/widgets/shimmer/page_shimmers/list_page_shimmer.dart';
import 'package:movie_app/widgets/shimmer/page_shimmers/movie_detail_page_shimmer.dart';
import 'package:movie_app/widgets/shimmer/page_shimmers/movie_page_shimmers.dart';
import 'package:movie_app/widgets/shimmer/page_shimmers/tv_detail_page_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class Shimmers {
  MoviePageShimmers moviePageShimmers = MoviePageShimmers();
  MovieDetailPageShimmers movieDetailPageShimmer = MovieDetailPageShimmers();
  TvDetailPageShimmer tvDetailPageShimmer = TvDetailPageShimmer();
  ListPageShimmer listPageShimmer = ListPageShimmer();

  Widget customProgressIndicatorBuilder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.4),
      highlightColor: Colors.grey.withOpacity(0.1),
      child: Container(
        color: Colors.grey,
      ),
    );
  }
}

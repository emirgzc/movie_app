import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/data/tv_api_client.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key, required this.clickedListType});
  ListType clickedListType;

  @override
  State<ListPage> createState() => _ListPageState();
}

int genreFilterId = 28;

class _ListPageState extends State<ListPage> {
  int page = 1;
  late TextEditingController _textEditingController;
  late Future<List<Result>?> listDataFuture;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = page.toString();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.clickedListType) {
      case ListType.top_rated_movies:
        listDataFuture =
            MovieApiClient().topRatedMovieData(context.locale, page: page);
        break;
      case ListType.upcoming_movies:
        listDataFuture =
            MovieApiClient().upComingMovieData(context.locale, page: page);
        break;
      case ListType.popular_movies:
        listDataFuture =
            MovieApiClient().popularMovieData(context.locale, page: page);
        break;
      case ListType.movies_in_cinemas:
        listDataFuture =
            MovieApiClient().nowPlayingMovieData(context.locale, page: page);
        break;
      case ListType.trend_movies:
        listDataFuture = MovieApiClient().trendData("movie", context.locale);
        break;
      case ListType.top_rated_series:
        listDataFuture =
            TvApiClient().topRatedTvData(context.locale, page: page);
        break;
      case ListType.popular_series:
        listDataFuture =
            TvApiClient().popularTvData(context.locale, page: page);
        break;
      case ListType.series_on_air:
        listDataFuture =
            TvApiClient().onTheAirTvData(context.locale, page: page);
        break;
      case ListType.trending_series_of_the_week:
        listDataFuture = MovieApiClient().trendData("tv", context.locale);
        break;

      default:
        listDataFuture =
            MovieApiClient().topRatedMovieData(context.locale, page: page);
    }

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Style.blackColor,
        title: Image.asset(
          "assets/logo/light-lg1.jpg",
          width: 300.w,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        // 2 tane future bekliyor, future icinde future de yapilabilir
        future: Future.wait(
            [listDataFuture, MovieApiClient().genres(context.locale)]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            var data = snapshot.data![0] as List<Result>;
            var genresData = snapshot.data![1] as Genres;

            return Padding(
              padding: Style.pagePadding,
              child: Column(
                children: [
                  // Kategori filtre
                  /* Padding(
                    padding: EdgeInsets.only(bottom: Style.defaultPaddingSizeHorizontal),
                    child: SizedBox(
                      width: double.infinity,
                      height: 100.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              clipBehavior: Clip.none,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: genresData.genres.length,
                              itemBuilder: (context, index) {
                                return filterGenreItem(genresData.genres[index].id, genresData.genres[index].name);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), */

                  // liste elemanları
                  Expanded(
                    child: ListView(
                      children: [
                        // filmler
                        MasonryGridView.count(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          crossAxisCount: 2,
                          itemBuilder: (BuildContext context, int index) {
                            // film kartları
                            return ImageDetailCard(
                              title: data[index].title,
                              id: data[index].id ?? 0,
                              posterPath: data[index].posterPath ?? "",
                              voteAverageNumber: data[index].voteAverage ?? 0,
                              dateCard:
                                  data[index].releaseDate.toString() == "null"
                                      ? data[index].firstAirDate.toString()
                                      : data[index].releaseDate.toString(),
                              width: width,
                              name: data[index].name ?? "",
                            );
                          },
                        ),
                        // ileri geri sayfa butonları
                        pageIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget pageIndicator() {
    String arrowLeft = LocaleKeys.previous_page.tr();
    String arrowRight = LocaleKeys.next_page.tr();

    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical * 0.75,
        bottom: Style.defaultPaddingSizeHorizontal * 0.75,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // onceki sayfa
          Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: ElevatedButton(
              onPressed: () {
                if (page > 1) {
                  setState(() {
                    page--;
                    _textEditingController.text = page.toString();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 4),
                elevation: 0,
                shadowColor: Colors.red,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Style.blackColor,
                  ),
                  Text(
                    arrowLeft,
                    style: const TextStyle(
                      color: Style.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // page number
          Expanded(
            child: TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(
                  2,
                ),
              ],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                fillColor: Style.blackColor.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Style.defaultRadiusSize / 2),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {},
              onChanged: (value) {},
              onSubmitted: (value) {
                /*
                                  if (100 > int.parse(value) &&
                                      0 < int.parse(value)) {
                                    setState(() {
                                      page = int.parse(value);
                                    });
                                    */
              },
            ),
          ),
          // sonraki sayfa
          Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: ElevatedButton(
              onPressed: () {
                if (page < 101) {
                  setState(() {
                    page++;
                    _textEditingController.text = page.toString();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 4),
                elevation: 0,
                shadowColor: Colors.red,
              ),
              child: Row(
                children: [
                  Text(
                    arrowRight,
                    style: const TextStyle(color: Style.blackColor),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Style.blackColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterGenreItem(int genreId, String genreName) {
    bool isSelected = genreId == genreFilterId;
    return Padding(
      padding: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal / 4),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isSelected ? genreFilterId = 0 : genreFilterId = genreId;
          });
        },
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.grey.shade800 : Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.grey.shade800 : Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.white : Colors.grey.shade800),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
            ),
          ),
        ),
        child: Center(
          child: Text(
            genreName,
            style: TextStyle(
              fontSize: 32.sp,
              color: isSelected ? Colors.grey.shade800 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

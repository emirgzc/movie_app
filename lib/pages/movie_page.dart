import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/revolve_date.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/create_poster_list.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Result>? datas;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getTodayWacthShouldData().then(
        (value) => todayShouldWatch(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: Style.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top trend movies slider
              sliderList(),
              // categories
              genresList(context.getSize().height),

              CreatePosterList(
                listName: LocaleKeys.popular_movies.tr(),
                listType: ListType.popular_movies,
                width: context.getSize().width,
                futureGetDataFunc: ApiClient().getMovieData(
                    dataWay: MovieApiType.popular.name, context.locale),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Style.defaultPaddingSizeVertical),
                child: CreatePosterList(
                  listName: LocaleKeys.top_rated_movies.tr(),
                  listType: ListType.top_rated_movies,
                  width: context.getSize().width,
                  futureGetDataFunc: ApiClient().getMovieData(
                      dataWay: MovieApiType.top_rated.name, context.locale),
                ),
              ),

              CreatePosterList(
                listName: LocaleKeys.upcoming_movies.tr(),
                listType: ListType.upcoming_movies,
                width: context.getSize().width,
                futureGetDataFunc: ApiClient().getMovieData(
                    dataWay: MovieApiType.upcoming.name, context.locale),
              ),

              SizedBox(height: 600.h),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<Genres?> genresList(double height) {
    return FutureBuilder(
      future: ApiClient().genres(context.locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          var genresData = snapshot.data as Genres;
          return SizedBox(
            width: double.infinity,
            height: height / 13,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: genresData.genres.length,
              itemBuilder: (context, index) {
                // return Text(genresData.genres[index].name);
                return createCategoriesItem(
                  (height / 12) * 2.4,
                  genresData.genres[index].name,
                  genresData.genres[index].id,
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<List<Result>?> sliderList() {
    return FutureBuilder(
      future: ApiClient().trendData(MediaTypes.movie.name, context.locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          var data = snapshot.data as List<Result?>;
          return CarouselSlider.builder(
            itemCount: data.length,
            itemBuilder: (context, index, realIndex) {
              return createTopSliderItem(
                (data[index]?.title ?? data[index]?.title),
                (data[index]?.backdropPath),
                data,
                index,
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 1.9,
              enlargeCenterPage: true,
            ),
          );
        } else {
          return const Text("Yükleniyor...");
        }
      },
    );
  }

  createCategoriesItem(
      double categoryItemWidth, String categoryName, int? genreId) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        "/categoryPage",
        arguments: genreId,
      ),
      child: Padding(
        padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
        child: Material(
          elevation: Style.defaultElevation,
          color: Style.transparentColor,
          shadowColor: Style.primaryColor,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Style.defaultRadiusSize / 2,
              ),
            ),
            child: Container(
              color: const Color.fromARGB(255, 160, 13, 3).withOpacity(0.8),
              // image widht ve height ile ayni olmali
              width: categoryItemWidth,
              child: Center(
                child: Text(
                  categoryName,
                  style: context.textThemeContext().titleMedium!.copyWith(
                        color: Style.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  createTopSliderItem(
      String? movieName, String? pathImage, List<Result?> data, int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        (data[index]?.title != null)
            ? NavigatorType.movieDetailPage.nameGet
            : NavigatorType.tvDetailPage.nameGet,
        arguments: (data[index]?.id ?? 0),
      ),
      child: Container(
        margin: EdgeInsets.all(Style.defaultPaddingSize / 4),
        padding: EdgeInsets.fromLTRB(0, Style.defaultPaddingSizeVertical / 2, 0,
            Style.defaultPaddingSizeVertical),
        child: Material(
          elevation: Style.defaultElevation,
          color: Style.transparentColor,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Style.defaultRadiusSize / 2,
              ),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: "https://image.tmdb.org/t/p/w500$pathImage",
                  fit: BoxFit.cover,
                  width: 1000.0,
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: Style.defaultPaddingSizeVertical / 2,
                      horizontal: Style.defaultPaddingSizeHorizontal,
                    ),
                    child: Text(
                      movieName ?? "---",
                      textAlign: TextAlign.center,
                      style: context.textThemeContext().titleMedium!.copyWith(
                            color: Style.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  todayShouldWatch() {
    Random _random = Random();
    Result? _allData = datas?[_random.nextInt(20)];
    return showModalBottomSheet(
      backgroundColor: Style.whiteColor,
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: Padding(
              padding: Style.pagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.movie_of_the_day.tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Card(
                        shadowColor: Theme.of(context).iconTheme.color,
                        elevation: Style.defaultElevation,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  //Text(datas?.length.toString() ?? 'a'),
                  _allData?.posterPath == null
                      ? Text('resim yok')
                      : CachedNetworkImage(
                          imageUrl:
                              "https://image.tmdb.org/t/p/w500${_allData?.posterPath.toString()}",
                          fit: BoxFit.contain,
                          height: 700.h,
                        ),
                  SizedBox(height: Style.defaultPaddingSize * 0.75),
                  Text(
                    _allData?.title ?? '---',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.all(Style.defaultPaddingSize * 0.75),
                    child: Text(
                      '${LocaleKeys.relase_date.tr()} : ${toRevolveDate(_allData?.releaseDate.toString() ?? DateTime.now().toString())}',
                    ),
                  ),
                  Text(
                    _allData?.overview ?? '---',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Style.defaultPaddingSize),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          ignoreGestures: true,
                          itemSize: 36.r,
                          glowColor: Style.starColor,
                          unratedColor: context
                              .publicThemeContext()
                              .shadowColor
                              .withOpacity(0.4),
                          initialRating: (_allData?.voteAverage ?? 0.0) / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Style.starColor,
                          ),
                          onRatingUpdate: (double value) {},
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: Style.defaultPaddingSize / 4),
                          child: Text(
                            _allData?.voteAverage.toString() ?? '---',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Style.blackColor,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      side: BorderSide(
                        width: 1,
                        color: Style.primaryColor,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: Style.defaultPaddingSize / 2),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        NavigatorType.movieDetailPage.nameGet,
                        arguments: _allData?.id,
                      );
                    },
                    child: Center(
                      child: Text(
                        LocaleKeys.see_the_movie.tr(),
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> getTodayWacthShouldData() async {
    //Random rand = Random();
    //int randomInt = rand.nextInt(1);
    await ApiClient()
        .getMovieData(
            dataWay: MovieApiType.popular.name, context.locale, page: 1)
        .then((value) {
      return datas = value;
    });
    setState(() {});
  }
}

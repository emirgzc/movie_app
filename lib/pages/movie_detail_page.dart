import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/revolve_date.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/collection.dart';
import 'package:movie_app/models/comment.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/to_watch.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/brochure_item.dart';
import 'package:movie_app/widgets/detail_page/blurry_image.dart';
import 'package:movie_app/widgets/detail_page/movie/button_for_detail_movie.dart';
import 'package:movie_app/widgets/detail_page/movie/public_image.dart';
import 'package:movie_app/widgets/detail_page/watch_card.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movieId});
  final int? movieId;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: bodyList(context, width, height),
    );
  }

  FutureBuilder<DetailMovie?> bodyList(BuildContext context, double width, double height) {
    return FutureBuilder(
      future: ApiClient().detailMovieData(widget.movieId ?? 0, context.locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data as DetailMovie;
          return Stack(
            children: [
              // arkaplandaki bulanik resim
              BlurryImage(path: data.posterPath),

              // ondeki widgetlar
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Style.whiteColor.withOpacity(0.01),
                    padding: Style.pagePadding,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appBar(context),
                            // film resmi
                            Center(
                              child: PublicImage(
                                path: data.posterPath,
                                width: width,
                                height: height,
                              ),
                            ),

                            // acıklama ve detaylar
                            SizedBox(
                              width: double.infinity,
                              height: 540.h,
                              child: PageView(
                                controller: _pageController,
                                children: [
                                  // acıklama
                                  movieDescription(data),

                                  // detaylar
                                  movieDetails(data, width),

                                  // cast oyunculari
                                  castPlayers(data.id ?? 0),

                                  // yorumlar
                                  commentForUsers(data.id ?? 0),
                                ],
                              ),
                            ),

                            // butonlar
                            buttons(width, height),

                            // Ekran Görüntüleri text
                            Padding(
                              padding: EdgeInsets.only(
                                top: Style.defaultPaddingSizeVertical,
                                bottom: Style.defaultPaddingSizeVertical / 2,
                              ),
                              child: Row(
                                children: [
                                  titleHead(LocaleKeys.screenshots.tr()),
                                ],
                              ),
                            ),

                            // ekran goruntuleri
                            images(width),

                            // Hoşunuza Gidebilir
                            Padding(
                              padding: EdgeInsets.only(
                                top: Style.defaultPaddingSizeVertical,
                                bottom: Style.defaultPaddingSizeVertical / 2,
                              ),
                              child: Row(
                                children: [
                                  titleHead(LocaleKeys.you_may_like.tr()),
                                ],
                              ),
                            ),

                            // önerilen filmler
                            oneriler(data, width),

                            Padding(
                              padding: EdgeInsets.only(
                                top: Style.defaultPaddingSizeVertical,
                                bottom: Style.defaultPaddingSizeVertical / 2,
                              ),
                              child: Row(
                                children: [
                                  titleHead(LocaleKeys.other_movies_in_the_series.tr()),
                                ],
                              ),
                            ),
                            // serinin diger filmleri*
                            data.belongsToCollection != null
                                ? serininDigerFilmleri(
                                    width,
                                    data.belongsToCollection?.id ?? 0,
                                  )
                                : const SizedBox.shrink(),

                            Padding(
                              padding: EdgeInsets.only(
                                top: Style.defaultPaddingSizeVertical,
                                bottom: Style.defaultPaddingSizeVertical / 2,
                              ),
                              child: Row(
                                children: [
                                  titleHead(LocaleKeys.where_to_watch.tr()),
                                ],
                              ),
                            ),

                            // önerilen filmler
                            getWatch(width),
                            Padding(
                              padding: EdgeInsets.only(
                                top: Style.defaultPaddingSizeVertical,
                                bottom: Style.defaultPaddingSizeVertical / 2,
                              ),
                              child: Row(
                                children: [
                                  titleHead(LocaleKeys.where_to_watch_buy.tr()),
                                ],
                              ),
                            ),

                            // önerilen filmler
                            getWatchBuy(width),

                            SizedBox(height: 500.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(child: const LinearProgressIndicator());
        }
      },
    );
  }

  Widget serininDigerFilmleri(
    double width,
    int collectionId,
  ) {
    return FutureBuilder(
      future: ApiClient().collectionData(collectionId, context.locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          Collection collectionData = snapshot.data as Collection;

          return Padding(
            padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 2),
            child: (collectionData.parts?.isNotEmpty ?? false)
                ? SizedBox(
                    width: double.infinity,
                    height: (width / 3) * 1.5,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: collectionData.parts?.length,
                      // ilk eleman olarak varsa
                      itemBuilder: (context, index) {
                        if (collectionData.parts?[index].id == widget.movieId) {
                          return SizedBox.shrink();
                        } else {
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              "/movieDetailPage",
                              arguments: (collectionData.parts?[index].id),
                            ),
                            child: (collectionData.parts?[index].posterPath == null)
                                ? Container(
                                    width: 360.w,
                                    margin: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal),
                                    child: Placeholder(),
                                  )
                                : BrochureItem(
                                    brochureUrl: "https://image.tmdb.org/t/p/w500${collectionData.parts?[index].posterPath}",
                                    width: width,
                                  ),
                          );
                        }
                      },
                    ),
                  )
                : Text(
                    LocaleKeys.other_movies_in_the_series_were_not_found.tr(),
                    style: TextStyle(color: Style.whiteColor),
                    textAlign: TextAlign.left,
                  ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<List<Result>?> oneriler(DetailMovie data, double width) {
    return FutureBuilder(
      future: ApiClient().similarMoviesData(data.id ?? 0, context.locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var similarMoviesData = snapshot.data as List<Result?>;
          return Padding(
            padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 2),
            child: (similarMoviesData.isNotEmpty)
                ? SizedBox(
                    width: double.infinity,
                    height: (width / 3) * 1.5,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: similarMoviesData.length,
                      // ilk eleman olarak varsa
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            "/movieDetailPage",
                            arguments: (similarMoviesData[index]?.id ?? 0),
                          ),
                          child: BrochureItem(
                            brochureUrl: "https://image.tmdb.org/t/p/w500${similarMoviesData[index]?.posterPath ?? ""}",
                            width: width,
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    LocaleKeys.no_movie_you_might_like.tr(),
                    style: TextStyle(color: Style.whiteColor),
                    textAlign: TextAlign.left,
                  ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<WhereToWatch?> getWatch(double width) {
    return FutureBuilder(
      future: ApiClient().getToWatch(widget.movieId ?? 0, type: MediaTypes.movie.name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var watchResult = snapshot.data as WhereToWatch;
          late List<Flatrate> result;
          if (context.locale.languageCode == LanguageCodes.tr.name) {
            result = watchResult.results?.tr?.flatrate ?? [];
          } else {
            result = watchResult.results?.us?.flatrate ?? [];
          }
          return (result.isNotEmpty)
              ? WatchCard(result: result, width: width)
              : Text(
                  LocaleKeys.no_watch_to_description.tr(),
                  style: TextStyle(color: Style.whiteColor),
                );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<WhereToWatch?> getWatchBuy(double width) {
    return FutureBuilder(
      future: ApiClient().getToWatch(widget.movieId ?? 0, type: MediaTypes.movie.name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var watchResult = snapshot.data as WhereToWatch;
          late List<Flatrate> result;
          if (context.locale.languageCode == LanguageCodes.tr.name) {
            result = watchResult.results?.tr?.buy ?? [];
          } else {
            result = watchResult.results?.us?.buy ?? [];
          }
          return (result.isNotEmpty)
              ? WatchCard(result: result, width: width)
              : Text(
                  LocaleKeys.no_watch_to_description.tr(),
                  style: TextStyle(color: Style.whiteColor),
                );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<Images?> images(double width) {
    return FutureBuilder(
      future: ApiClient().getImages(widget.movieId ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data as Images;

          return Padding(
            padding: EdgeInsets.only(
              top: Style.defaultPaddingSizeVertical / 2,
            ),
            child: (data.backdrops?.isNotEmpty ?? false)
                ? SizedBox(
                    width: double.infinity,
                    // dogru oranin yakalanmasi icin
                    // 281 / 500 : resim cozunurlugu
                    height: (width / 2) * (281 / 500),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: data.backdrops?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            showScreenshots(data, index, width);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: Style.defaultPaddingSizeHorizontal * 0.75,
                            ),
                            child: screenshotItem(
                              "https://image.tmdb.org/t/p/w500${data.backdrops?[index].filePath}",
                              width / 2,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    LocaleKeys.there_are_no_images_for_this_movie.tr(),
                    style: TextStyle(color: Style.whiteColor),
                    textAlign: TextAlign.left,
                  ),
          );
        } else {
          // loading
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget titleHead(String title) {
    return Text(
      title,
      textScaleFactor: 1.2,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: Style.whiteColor,
          ),
    );
  }

  Widget buttons(double width, double height) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical * 0.75,
      ),
      child: SizedBox(
        width: double.infinity,
        height: (width) / 7.5,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            // oynat butonu
            FutureBuilder(
              future: ApiClient().getTrailer(widget.movieId ?? 0, context.locale),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                  var data = snapshot.data as Trailer;
                  return ButtonForDetailMovie(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/trailerPage", arguments: [
                        widget.movieId,
                        [data.results],
                      ]);
                    },
                    icondata: IconPath.play.iconPath(),
                    width: width,
                    height: height,
                  );
                } else {
                  return ButtonForDetailMovie(
                    onPressed: () {},
                    icondata: IconPath.play.iconPath(),
                    width: width,
                    height: height,
                  );
                }
              },
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              icondata: IconPath.file.iconPath(),
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              icondata: IconPath.info.iconPath(),
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              icondata: IconPath.users.iconPath(),
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              icondata: IconPath.comment.iconPath(),
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {},
              icondata: IconPath.plus_lg.iconPath(),
              width: width,
              height: height,
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical * 2.5,
        bottom: Style.defaultPaddingSizeVertical * 1.25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // geri
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
                color: Style.widgetBackgroundColor,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
              child: SvgPicture.asset(
                IconPath.arrow_left.iconPath(),
                height: Style.defaullIconHeight,
                color: Style.whiteColor,
              ),
            ),
          ),
          Image.asset(
            "assets/logo/light-lg1-removebg.png",
            width: 290.w,
            fit: BoxFit.contain,
          ),
          // film ismi

          // kalp butonu
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
                color: Style.widgetBackgroundColor,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
              child: SvgPicture.asset(
                IconPath.favorite_fill.iconPath(),
                height: Style.defaullIconHeight,
                color: Style.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commentForUsers(int movieId) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical / 1.25,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(
            Style.defaultRadiusSize / 2,
          ),
        ),
        child: Container(
          color: Style.widgetBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.comments.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Style.whiteColor,
                            letterSpacing: 1.25,
                          ),
                    ),
                    FutureBuilder(
                      future: ApiClient().getComment(movieId, context.locale),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                          var creditsData = snapshot.data as Comment;
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSizeVertical / 2),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: creditsData.results?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return commentCard(creditsData, index);
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget commentCard(Comment creditsData, int index) {
    return Container(
      padding: EdgeInsets.all(Style.defaultPaddingSize / 4),
      margin: EdgeInsets.only(
        right: Style.defaultPaddingSizeHorizontal / 4,
        bottom: Style.defaultPaddingSizeVertical / 4,
      ),
      decoration: BoxDecoration(
        color: Style.widgetBackgroundColor,
        borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Style.defaultPaddingSizeHorizontal / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        creditsData.results?[index].author ?? "-",
                        style: const TextStyle(
                          color: Style.whiteColor,
                        ),
                      ),
                      Text(
                        toRevolveDate(
                          creditsData.results?[index].createdAt.toString() ?? DateTime.now().toString(),
                        ),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Style.whiteColor,
                              letterSpacing: 0.75,
                            ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    (creditsData.results?[index].authorDetails?.avatarPath == null)
                        ? SvgPicture.asset(
                            IconPath.comment_card.iconPath(),
                            height: Style.defaullIconHeight * 0.7,
                            color: Style.whiteColor,
                          )
                        : CachedNetworkImage(
                            imageUrl: "https://www.gravatar.com/avatar/${creditsData.results?[index].authorDetails?.avatarPath ?? ""}",
                            fit: BoxFit.cover,
                            width: 120.w,
                            height: 120.h,
                          ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 4, left: Style.defaultPaddingSizeHorizontal / 2.5),
                        child: Text(
                          "${creditsData.results?[index].content ?? "-"} (${creditsData.results?[index].authorDetails?.rating ?? 0})",
                          style: TextStyle(
                            color: Style.whiteColor,
                            fontSize: 34.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget castPlayers(int movieId) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical / 1.25,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(
            Style.defaultRadiusSize / 2,
          ),
        ),
        child: Container(
          color: Style.widgetBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.cast_players.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Style.whiteColor,
                            letterSpacing: 1.25,
                          ),
                    ),
                    FutureBuilder(
                      future: ApiClient().getCredits(movieId, context.locale),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                          var creditsData = snapshot.data as Credits;
                          return MasonryGridView.count(
                            padding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSizeVertical / 2),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: creditsData.cast.length,
                            crossAxisCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed("/castPersonsMoviesPage", arguments: [
                                    creditsData.cast[index].id,
                                    creditsData.cast[index].name,
                                  ]);
                                },
                                child: playersCard(creditsData, index),
                              );
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget playersCard(Credits creditsData, int index) {
    return Container(
      padding: EdgeInsets.all(
        Style.defaultPaddingSize / 4,
      ),
      margin: EdgeInsets.only(
        right: Style.defaultPaddingSizeHorizontal / 4,
        bottom: Style.defaultPaddingSizeVertical / 4,
      ),
      decoration: BoxDecoration(
        color: Style.widgetBackgroundColor,
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            height: 220.h,
            imageUrl: "https://image.tmdb.org/t/p/w500${creditsData.cast[index].profilePath}",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(left: Style.defaultPaddingSizeHorizontal / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 4),
                  child: Text(
                    creditsData.cast[index].originalName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Style.whiteColor, fontSize: 30.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Style.defaultPaddingSizeVertical / 4,
                  ),
                  child: Text(
                    "(${creditsData.cast[index].character})",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Style.whiteColor, fontSize: 30.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget movieDescription(DetailMovie data) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical / 1.25,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Style.defaultRadiusSize / 2)),
        child: Container(
          color: Style.widgetBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: Style.defaultPaddingSizeVertical / 2,
                  ),
                  child: Text(
                    data.title.toString(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Style.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  data.overview.toString().isEmpty ? LocaleKeys.no_description_text_entered_with_the_movie.tr() : data.overview.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 30,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        height: 1.4,
                        color: Style.whiteColor.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget movieDetails(DetailMovie? data, double width) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical / 1.25,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Style.defaultRadiusSize / 2)),
        child: Container(
          color: Style.widgetBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // categories
                  Container(
                    margin: EdgeInsets.only(bottom: Style.defaultPaddingSizeVertical / 2),
                    height: width / 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: data?.genres?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal / 4),
                                child: Text(
                                  "${data?.genres?[index].name.toString() ?? "---"},",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: Style.whiteColor,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // year, country, lenght
                  Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // yil
                          movieDetailItem(
                            data,
                            "${LocaleKeys.relase_date.tr()} : ",
                            toRevolveDate(
                              (data?.releaseDate.toString().split(" ")[0] ?? DateTime.now().toString()),
                            ),
                          ),
                          movieDetailItem(
                            data,
                            "${LocaleKeys.country.tr()} : ",
                            (data?.productionCountries?.isEmpty ?? false)
                                ? "Belirtilmemiş"
                                : (data?.productionCountries?[0].name ?? "-").toString(),
                          ),

                          movieDetailItem(
                            data,
                            "${LocaleKeys.rating.tr()} : ",
                            (data?.voteAverage.toString().isEmpty ?? false)
                                ? "Belirtilmemiş"
                                : ((data?.voteAverage)).toString().substring(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget movieDetailItem(DetailMovie? data, String title, String item) {
    return Padding(
      padding: EdgeInsets.only(bottom: Style.defaultPaddingSizeVertical / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Style.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            item,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Style.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget screenshotItem(String url, double width) {
    return Material(
      //elevation: 14,
      color: Style.transparentColor,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(Style.defaultRadiusSize / 2),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: width,
          // 281 / 500 : resim cozunurlugu
          height: (width) * (281 / 500),
        ),
      ),
    );
  }

  showScreenshots(Images data, int clickedIndex, double width) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20.0,
              sigmaY: 20.0,
            ),
            child: CarouselSlider(
              items: data.backdrops
                  ?.map((backdrop) => screenshotItem("https://image.tmdb.org/t/p/w500${backdrop.filePath.toString()}", width))
                  .toList(),
              options: CarouselOptions(
                initialPage: clickedIndex,
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            ),
          ),
        );
      },
    );
  }
}

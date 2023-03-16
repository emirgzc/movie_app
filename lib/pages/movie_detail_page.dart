import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/models/collection.dart';
import 'package:movie_app/models/comment.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/widgets/card/brochure_item.dart';
import 'package:movie_app/widgets/detail_page/blurry_image.dart';
import 'package:movie_app/widgets/detail_page/movie/button_for_detail_movie.dart';
import 'package:movie_app/widgets/detail_page/movie/public_image.dart';

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
      body: FutureBuilder(
        future: MovieApiClient().detailMovieData(widget.movieId ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
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
                          child: Column(
                            children: [
                              appBar(context),
                              // film resmi
                              PublicImage(
                                path: data.posterPath,
                                width: width,
                                height: height,
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
                                    titleHead("Ekran Görüntüleri"),
                                  ],
                                ),
                              ),

                              // ekran goruntuleri
                              images(width),

                              // serinin diger filmleri*
                              data.belongsToCollection != null
                                  ? serininDigerFilmleri(width,
                                      data.belongsToCollection["id"] ?? 0)
                                  : const SizedBox(),

                              // Hoşunuza Gidebilir
                              Padding(
                                padding: EdgeInsets.only(
                                  top: Style.defaultPaddingSizeVertical,
                                  bottom: Style.defaultPaddingSizeVertical / 2,
                                ),
                                child: Row(
                                  children: [
                                    titleHead("Hoşunuza Gidebilir"),
                                  ],
                                ),
                              ),

                              // önerilen filmler
                              oneriler(data, width),

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
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget serininDigerFilmleri(
    double width,
    int collectionId,
  ) {
    return Column(
      children: [
        // Serinin diğer filmleri text
        Padding(
          padding: EdgeInsets.only(
            top: Style.defaultPaddingSizeVertical,
            bottom: Style.defaultPaddingSizeVertical / 2,
          ),
          child: Row(
            children: [
              titleHead("Serinin Diğer Filmleri"),
            ],
          ),
        ),
        FutureBuilder(
          future: MovieApiClient().collectionData(collectionId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              Collection collectionData = snapshot.data as Collection;
              return Padding(
                padding:
                    EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 2),
                child: SizedBox(
                  width: double.infinity,
                  height: (width / 3) * 1.5,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: collectionData.parts.length,
                    // ilk eleman olarak varsa
                    itemBuilder: (context, index) {
                      return BrochureItem(
                          brochureUrl:
                              "https://image.tmdb.org/t/p/w500${collectionData.parts[index].posterPath}",
                          width: width);
                    },
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }

  FutureBuilder<List<Result>?> oneriler(DetailMovie data, double width) {
    return FutureBuilder(
      future: MovieApiClient().similarMoviesData(data.id ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          var similarMoviesData = snapshot.data as List<Result?>;

          return Padding(
            padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 2),
            child: SizedBox(
              width: double.infinity,
              height: (width / 3) * 1.5,
              child: ListView.builder(
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
                      brochureUrl:
                          "https://image.tmdb.org/t/p/w500${similarMoviesData[index]?.posterPath ?? ""}",
                      width: width,
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  FutureBuilder<Images?> images(double width) {
    return FutureBuilder(
      future: MovieApiClient().getImages(widget.movieId ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          var data = snapshot.data as Images;

          return Padding(
            padding: EdgeInsets.only(
              top: Style.defaultPaddingSizeVertical / 2,
            ),
            child: SizedBox(
              width: double.infinity,
              // dogru oranin yakalanmasi icin
              // 281 / 500 : resim cozunurlugu
              height: (width / 2) * (281 / 500),
              child: ListView.builder(
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
            ),
          );
        } else {
          // loading
          return Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              top: 12,
            ),
            child: SizedBox(
              width: double.infinity,
              height: (width / 2) * (281 / 500),
              child: ListView.builder(
                clipBehavior: Clip.none,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: width / 2,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget titleHead(String title) {
    return Text(
      title,
      textScaleFactor: 1.2,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
        height: (width - 90) / 6,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            // oynat butonu
            FutureBuilder(
              future: MovieApiClient().getTrailer(widget.movieId ?? 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  var data = snapshot.data as Trailer;
                  return ButtonForDetailMovie(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed("/trailerPage", arguments: [
                        widget.movieId ?? 0,
                        [data.results],
                      ]);
                    },
                    icondata: Icons.play_arrow,
                    width: width,
                    height: height,
                  );
                } else {
                  return ButtonForDetailMovie(
                    onPressed: () {},
                    icondata: Icons.play_disabled,
                    width: width,
                    height: height,
                  );
                }
              },
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icondata: Icons.description,
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icondata: Icons.info_outline,
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icondata: Icons.family_restroom,
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {
                _pageController.animateToPage(3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icondata: Icons.comment,
              width: width,
              height: height,
            ),
            ButtonForDetailMovie(
              onPressed: () {},
              icondata: Icons.add,
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
        top: Style.defaultPaddingSizeVertical * 3.25,
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
                borderRadius:
                    BorderRadius.circular(Style.defaultRadiusSize / 2),
                color: Style.widgetBackgroundColor,
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
              child: const Icon(
                Icons.arrow_back,
                color: Style.whiteColor,
              ),
            ),
          ),
          Image.asset(
            "assets/header_logo.png",
            width: 290.w,
            fit: BoxFit.contain,
          ),
          // film ismi

          // kalp butonu
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Style.defaultRadiusSize / 2),
                color: Style.widgetBackgroundColor,
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.error,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Yorumlar",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Style.whiteColor,
                            letterSpacing: 1.25,
                          ),
                    ),
                    FutureBuilder(
                      future: MovieApiClient().getComment(movieId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null) {
                          var creditsData = snapshot.data as Comment;
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: Style.defaultPaddingSizeVertical / 2),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: creditsData.results?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      "/castPersonsMoviesPage",
                                      arguments: [
                                        creditsData.results?[index].id,
                                        creditsData.results?[index].author,
                                      ]);
                                },
                                child: commentCard(creditsData, index),
                              );
                            },
                          );
                        } else {
                          return const SizedBox();
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
            padding:
                EdgeInsets.only(left: Style.defaultPaddingSizeHorizontal / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: Style.defaultPaddingSizeVertical / 4),
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
                          creditsData.results?[index].createdAt.toString() ??
                              DateTime.now().toString(),
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
                    (creditsData.results?[index].authorDetails?.avatarPath ==
                            null)
                        ? const Icon(
                            Icons.nature_people_outlined,
                            color: Style.whiteColor,
                          )
                        : Image.network(
                            "https://image.tmdb.org/t/p/w500${creditsData.results?[index].authorDetails?.avatarPath ?? ""}",
                            fit: BoxFit.cover,
                            width: 120.w,
                            height: 120.h,
                          ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: Style.defaultPaddingSizeVertical / 4,
                            left: Style.defaultPaddingSizeHorizontal / 2.5),
                        child: Text(
                          "${creditsData.results?[index].content ?? "-"} (${creditsData.results?[index].authorDetails?.rating ?? 0})",
                          style: const TextStyle(
                            color: Style.whiteColor,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Oyuncular: ",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Style.whiteColor,
                            letterSpacing: 1.25,
                          ),
                    ),
                    FutureBuilder(
                      future: MovieApiClient().credits(movieId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null) {
                          var creditsData = snapshot.data as Credits;
                          return MasonryGridView.count(
                            padding: EdgeInsets.symmetric(
                                vertical: Style.defaultPaddingSizeVertical / 2),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: creditsData.cast.length,
                            crossAxisCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      "/castPersonsMoviesPage",
                                      arguments: [
                                        creditsData.cast[index].id,
                                        creditsData.cast[index].name,
                                      ]);
                                },
                                child: playersCard(creditsData, index),
                              );
                            },
                          );
                        } else {
                          return const SizedBox();
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
            imageUrl:
                "https://image.tmdb.org/t/p/w500${creditsData.cast[index].profilePath}",
            fit: BoxFit.cover,
          ),
          Padding(
            padding:
                EdgeInsets.only(left: Style.defaultPaddingSizeHorizontal / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: Style.defaultPaddingSizeVertical / 4),
                  child: Text(
                    creditsData.cast[index].originalName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Style.whiteColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Style.defaultPaddingSizeVertical / 4,
                  ),
                  child: Text(
                    "(${creditsData.cast[index].character})",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Style.whiteColor,
                    ),
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
        borderRadius:
            BorderRadius.all(Radius.circular(Style.defaultRadiusSize / 2)),
        child: Container(
          color: Style.widgetBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Style.defaultPaddingSizeVertical / 2,
                      ),
                      child: Text(
                        data.title.toString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Style.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text(
                      data.overview.toString().isEmpty
                          ? "Film ile ilgili girilmiş bir açıklama metni yok"
                          : data.overview.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            height: 1.4,
                            color: Style.whiteColor.withOpacity(0.8),
                          ),
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

  Widget movieDetails(DetailMovie? data, double width) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical / 1.25,
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.all(Radius.circular(Style.defaultRadiusSize / 2)),
        child: Container(
          color: Style.widgetBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // categories
                  Container(
                    margin: EdgeInsets.only(
                        bottom: Style.defaultPaddingSizeVertical / 2),
                    height: width / 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data?.genres?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    right:
                                        Style.defaultPaddingSizeHorizontal / 4),
                                child: Text(
                                  "${data?.genres?[index].name.toString() ?? "---"},",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
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
                            "Yayın Tarihi : ",
                            toRevolveDate(
                              (data?.releaseDate.toString().split(" ")[0] ??
                                  DateTime.now().toString()),
                            ),
                          ),
                          movieDetailItem(
                            data,
                            "Ülke : ",
                            (data?.productionCountries?.isEmpty ?? false)
                                ? "Belirtilmemiş"
                                : (data?.productionCountries?[0].name ?? "-")
                                    .toString(),
                          ),

                          movieDetailItem(
                            data,
                            "Değerlendirme : ",
                            (data?.voteAverage.toString().isEmpty ?? false)
                                ? "Belirtilmemiş"
                                : ((data?.voteAverage))
                                    .toString()
                                    .substring(0, 3),
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
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Style.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            item,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Style.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      ),
    );
  }

  Widget screenshotItem(String url, double width) {
    return Material(
      //elevation: 14,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(Style.defaultRadiusSize / 2),
        ),
        child: Image.network(
          url,
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
                  ?.map((backdrop) => screenshotItem(
                      "https://image.tmdb.org/t/p/w500${backdrop.filePath.toString()}",
                      width))
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

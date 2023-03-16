import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/tv_api_client.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/widgets/detail_page/tv/opened_text_for_overview.dart';

class TVDetailPage extends StatefulWidget {
  const TVDetailPage({super.key, required this.movieId});
  final int? movieId;

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  late PageController _pageController;
  final bool _isOpenedText = false;

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
    return newBody(height, width);
  }

  Scaffold newBody(double height, double width) {
    return Scaffold(
      body: FutureBuilder(
        future: TvApiClient().detailMovieData(widget.movieId ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            var data = snapshot.data as TvDetail;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      topImage(data, height, width),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
                          child: textItemForContainer(
                            data,
                            Text(
                              (data.episodeRunTime?.isEmpty ?? false)
                                  ? "Süre Belirtilmemiş"
                                  : "${data.episodeRunTime?[0].toString()} dakika",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: circleItem(
                          context,
                          () => Navigator.pop(context),
                          Icons.arrow_back,
                        ),
                      ),
                      FutureBuilder(
                        future: TvApiClient().getTrailer(widget.movieId ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data != null) {
                            var data = snapshot.data as Trailer;
                            return Positioned(
                              left: 180.w,
                              bottom: 0,
                              child: circleItem(
                                context,
                                () {
                                  Navigator.of(context)
                                      .pushNamed("/trailerPage", arguments: [
                                    widget.movieId ?? 0,
                                    [data.results],
                                  ]);
                                },
                                Icons.play_arrow_rounded,
                              ),
                            );
                          } else {
                            return Positioned(
                              left: 180.w,
                              bottom: 0,
                              child: circleItem(
                                context,
                                () {},
                                Icons.play_disabled_rounded,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: Style.pagePadding,
                    color: Style.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            textItemForContainer(
                              data,
                              Text(
                                "${data.numberOfSeasons} sezon",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            textItemForContainer(
                              data,
                              Text(
                                "${data.numberOfEpisodes} bölüm",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            textItemForContainer(
                              data,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Style.starColor,
                                    size: Style.defaultIconsSize,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: Style.defaultPaddingSizeHorizontal /
                                          3,
                                    ),
                                    child: Text(
                                      (data.voteAverage.toString().isEmpty)
                                          ? "Belirtilmemiş"
                                          : ((data.voteAverage))
                                              .toString()
                                              .substring(0, 3),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.favorite_border,
                              size: Style.iconSizeTv,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    (Style.defaultPaddingSizeHorizontal / 4) *
                                        3,
                              ),
                              child: Icon(
                                Icons.add_box_outlined,
                                size: Style.iconSizeTv,
                              ),
                            ),
                            Icon(
                              Icons.share_outlined,
                              size: Style.iconSizeTv,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 4,
                            bottom: Style.defaultPaddingSizeVertical / 2,
                          ),
                          child: Text(
                            data.name ?? "--",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        (data.tagline?.isEmpty ?? false)
                            ? Container()
                            : Text(
                                data.tagline ?? "-",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                        OpenedTextForOverview(
                          isOpenedText: _isOpenedText,
                          data: data.overview ?? "-",
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: Style.defaultPaddingSizeVertical,
                            bottom: Style.defaultPaddingSizeVertical / 2,
                          ),
                          child: Text(
                            (data.productionCountries?.isEmpty ?? false)
                                ? "Ülke : Belirtilmemiş"
                                : "Ülke : ${data.productionCountries?[0].name ?? "-"}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Text(
                          "Çıkış Tarihi : ${toRevolveDate((data.firstAirDate.toString().split(" ")[0]))}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 3,
                            bottom: Style.defaultPaddingSizeVertical,
                          ),
                          child: Text(
                            "Oyuncular",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        FutureBuilder(
                          future: TvApiClient().credits(widget.movieId ?? 0),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData &&
                                snapshot.data != null) {
                              var creditsData = snapshot.data as Credits;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      creditsData.cast.length,
                                      (index) => peopleCard(
                                          context, creditsData, index),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 2,
                            bottom: Style.defaultPaddingSizeVertical / 2,
                          ),
                          child: Text(
                            "Görüntüler",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        FutureBuilder(
                          future: TvApiClient().getImages(widget.movieId ?? 0),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return screenshootCard(
                                          data, index, width);
                                    },
                                  ),
                                ),
                              );
                            } else {
                              // loading
                              return const SizedBox();
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 2,
                            bottom: Style.defaultPaddingSizeVertical / 3,
                          ),
                          child: Text(
                            "Yapımcı Şirketler",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          // dogru oranin yakalanmasi icin
                          // 281 / 500 : resim cozunurlugu
                          height: 250.h,
                          child: ListView.builder(
                            clipBehavior: Clip.none,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: data.productionCompanies?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              if (data.productionCompanies?[index].logoPath ==
                                  null) {
                                return Container();
                              } else {
                                return productCompaniesImage(
                                    context, data, index, width);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 3,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            // dogru oranin yakalanmasi icin
                            // 281 / 500 : resim cozunurlugu
                            height: 80.h,
                            child: ListView.builder(
                              clipBehavior: Clip.none,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.genres?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return genresCard(data, index);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 400.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget genresCard(TvDetail data, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Style.defaultPaddingSizeVertical / 4,
        horizontal: Style.defaultPaddingSizeHorizontal / 2,
      ),
      margin: EdgeInsets.only(
        right: (Style.defaultPaddingSizeHorizontal / 4) * 3,
      ),
      decoration: BoxDecoration(
        color: Style.whiteColor,
        boxShadow: [Style.defaultShadow],
      ),
      child: Center(
        child: Text(
          data.genres?[index].name.toString() ?? "---",
        ),
      ),
    );
  }

  Widget productCompaniesImage(
      BuildContext context, TvDetail data, int index, double width) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30.0,
                sigmaY: 30.0,
              ),
              child: Material(
                //elevation: 14,
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Style.defaultPaddingSizeHorizontal * 3,
                  ),
                  child: Image.network(
                    "https://image.tmdb.org/t/p/w500${data.productionCompanies?[index].logoPath.toString()}",
                    fit: BoxFit.contain,
                    width: width,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: (Style.defaultPaddingSizeVertical / 2) * 3,
          right: Style.defaultPaddingSizeHorizontal,
        ),
        child: SizedBox(
          width: 400.w,
          child: Container(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            margin: EdgeInsets.only(
                bottom: Style.defaultPaddingSizeVertical / 2,
                right: Style.defaultPaddingSizeHorizontal / 2),
            height: 140.h,
            width: 400.w,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Style.blackColor.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(
                Style.defaultRadiusSize / 4,
              ),
              boxShadow: [Style.defaultShadow],
              color: Style.whiteColor,
            ),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500${data.productionCompanies?[index].logoPath.toString()}",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget screenshootCard(Images data, int index, double width) {
    return GestureDetector(
      onTap: () {
        showScreenshots(data, index, width);
      },
      child: Padding(
        padding: EdgeInsets.only(
          right: Style.defaultPaddingSizeHorizontal / 2,
        ),
        child: SizedBox(
          width: 470.w,
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 8,
              right: 8,
            ),
            height: 220.h,
            width: 470.w,
            child: screenshotItem(
              "https://image.tmdb.org/t/p/w500${data.backdrops?[index].filePath}",
            ),
          ),
        ),
      ),
    );
  }

  Widget peopleCard(BuildContext context, Credits creditsData, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/castPersonsMoviesPage", arguments: [
          creditsData.cast[index].id,
          creditsData.cast[index].name,
        ]);
      },
      child: SizedBox(
        width: 230.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: Style.defaultPaddingSizeVertical / 2,
                right: Style.defaultPaddingSizeHorizontal / 2,
              ),
              height: 250.h,
              width: 230.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Style.defaultRadiusSize / 4,
                ),
                child: Material(
                  elevation: Style.defaultElevation,
                  child: Image.network(
                    "https://image.tmdb.org/t/p/w500${creditsData.cast[index].profilePath}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Style.defaultPaddingSizeHorizontal / 2,
              ),
              child: Text(
                creditsData.cast[index].originalName,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Style.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleItem(
      BuildContext context, void Function()? onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 3),
        decoration: BoxDecoration(
          boxShadow: [Style.defaultShadow],
          shape: BoxShape.circle,
          color: Style.whiteColor,
          border: Border.all(
            width: 1,
            color: Style.widgetBackgroundColor,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: Style.defaultPaddingSizeHorizontal / 1.5,
          vertical: Style.defaultPaddingSizeVertical / 1.5,
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget textItemForContainer(TvDetail data, Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Style.defaultPaddingSizeVertical / 4,
        horizontal: Style.defaultPaddingSizeHorizontal / 3,
      ),
      decoration: BoxDecoration(
        boxShadow: [Style.defaultShadow],
        color: Style.whiteColor,
        borderRadius: BorderRadius.circular(
          Style.defaultRadiusSize / 4,
        ),
      ),
      margin: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal / 2),
      child: child,
    );
  }

  Widget topImage(TvDetail data, double height, double width) {
    return Image.network(
      "https://image.tmdb.org/t/p/w500${data.posterPath.toString()}",
      height: height * 0.58,
      width: width,
      fit: BoxFit.cover,
    );
  }

  Widget screenshotItem(String url) {
    return Material(
      elevation: Style.defaultElevation,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(Style.defaultRadiusSize / 4),
        ),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          // 281 / 500 : resim cozunurlugu
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
                      ))
                  .toList(),
              options: CarouselOptions(
                  initialPage: clickedIndex,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false),
            ),
          ),
        );
      },
    );
  }
}

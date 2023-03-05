import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movieId});
  final int? movieId;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Color widgetBackgroundColor = Colors.black.withOpacity(0.4);
  Color normalTextColor = Colors.white.withOpacity(0.8);
  Color headerTextColor = Colors.white;
  late PageController pageController;
  double borderRadius = 12.0;

  @override
  void initState() {
    pageController = PageController();
    print(widget.movieId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder(
        future: ApiClient().detailMovieData(widget.movieId ?? 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            var data = snapshot.data as DetailMovie;

            return Stack(
              children: [
                // arkaplandaki bulanik resim
                ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: data.backdropPath != null
                      ? Image.network(
                          "https://image.tmdb.org/t/p/w500${data.backdropPath.toString()}",
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(),
                ),

                // ondeki widgetlar
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // isim , geri ve begen butonu

                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // geri
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                          color: widgetBackgroundColor,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(
                                          Icons.arrow_left,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/header_logo.png",
                                      height: 100,
                                      width: 140,
                                    ),
                                    // film ismi
                                    /* Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                          color: widgetBackgroundColor,
                                        ),
                                        child: Center(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 4, 8, 4),
                                              child: Text(
                                                data.title.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: headerTextColor,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ), */

                                    // kalp butonu
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              borderRadius),
                                          color: widgetBackgroundColor,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // film resmi
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 20.0,
                                            sigmaY: 20.0,
                                          ),
                                          child: Material(
                                            //elevation: 14,
                                            color: Colors.transparent,
                                            child: Image.network(
                                              "https://image.tmdb.org/t/p/w500${data.posterPath.toString()}",
                                              fit: BoxFit.contain,
                                              width: width,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Hero(
                                  tag:
                                      "https://image.tmdb.org/t/p/w500${data.posterPath.toString()}",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(borderRadius / 3),
                                    ),
                                    child: SizedBox(
                                      width: width - 200,
                                      height: height * 0.4,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://image.tmdb.org/t/p/w500${data.posterPath.toString()}",
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // acıklama ve detaylar
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: PageView(
                                  controller: pageController,
                                  children: [
                                    // acıklama
                                    movieDescription(data),

                                    // detaylar
                                    movieDetails(data, width),

                                    // cast oyunculari
                                    castPlayers(data.id ?? 0),
                                  ],
                                ),
                              ),

                              // butonlar
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: (width - 90) / 5,
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      // oynat butonu
                                      FutureBuilder(
                                        future: ApiClient()
                                            .getTrailer(widget.movieId ?? 0),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData &&
                                              snapshot.data != null) {
                                            var data = snapshot.data as Trailer;
                                            return ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(borderRadius),
                                              ),
                                              child: Container(
                                                width: (width - 90) / 5,
                                                height: (width - 90) / 5,
                                                color: widgetBackgroundColor,
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            "/trailerPage",
                                                            arguments: [
                                                          widget.movieId ?? 0,
                                                          [data.results],
                                                        ]);
                                                  },
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: headerTextColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(borderRadius),
                                              ),
                                              child: Container(
                                                width: (width - 90) / 5,
                                                height: (width - 90) / 5,
                                                color: widgetBackgroundColor,
                                                child: MaterialButton(
                                                  onPressed: () {},
                                                  child: Icon(
                                                    Icons.play_disabled,
                                                    color: headerTextColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),

                                      // aciklama butonu
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(borderRadius)),
                                        child: Container(
                                          width: (width - 90) / 5,
                                          height: (width - 90) / 5,
                                          color: widgetBackgroundColor,
                                          child: MaterialButton(
                                            onPressed: () {
                                              pageController.animateToPage(0,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            },
                                            child: Icon(
                                              Icons.description,
                                              color: headerTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),

                                      // info butonu
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(borderRadius)),
                                        child: Container(
                                          width: (width - 90) / 5,
                                          height: (width - 90) / 5,
                                          color: widgetBackgroundColor,
                                          child: MaterialButton(
                                            onPressed: () {
                                              pageController.animateToPage(1,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            },
                                            child: Icon(
                                              Icons.info_outline,
                                              color: headerTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),

                                      // oyuncular
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(borderRadius)),
                                        child: Container(
                                          width: (width - 90) / 5,
                                          height: (width - 90) / 5,
                                          color: widgetBackgroundColor,
                                          child: MaterialButton(
                                            onPressed: () {
                                              pageController.animateToPage(2,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                            },
                                            child: Icon(
                                              Icons.family_restroom,
                                              color: headerTextColor,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),
                                      // ekle butonu
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(borderRadius)),
                                        child: Container(
                                          width: (width - 90) / 5,
                                          height: (width - 90) / 5,
                                          color: widgetBackgroundColor,
                                          child: MaterialButton(
                                            onPressed: () {},
                                            child: Icon(
                                              Icons.add,
                                              color: headerTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Ekran Görüntüleri text
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Ekran Görüntüleri",
                                      textScaleFactor: 1.2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: headerTextColor),
                                    ),
                                  ],
                                ),
                              ),

                              // ekran goruntuleri
                              FutureBuilder(
                                future:
                                    ApiClient().getImages(widget.movieId ?? 0),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData &&
                                      snapshot.data != null) {
                                    var data = snapshot.data as Images;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12,
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
                                          itemCount:
                                              data.backdrops?.length ?? 0,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                showScreenshots(
                                                    data, index, width);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10,
                                                ),
                                                child: screenshotItem(
                                                    "https://image.tmdb.org/t/p/w500${data.backdrops?[index].filePath}",
                                                    width / 2),
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: SizedBox(
                                                width: width / 2,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),

                              // Hoşunuza Gidebilir
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 24,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Hoşunuza Gidebilir",
                                      textScaleFactor: 1.2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: headerTextColor),
                                    ),
                                  ],
                                ),
                              ),

                              // önerilen filmler
                              FutureBuilder(
                                future:
                                    ApiClient().similarMoviesData(data.id ?? 0),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData &&
                                      snapshot.data != null) {
                                    var similarMoviesData =
                                        snapshot.data as List<Result?>;

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: (width / 3) * 1.5,
                                        child: ListView.builder(
                                          clipBehavior: Clip.none,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: similarMoviesData.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed(
                                                "/detailPage",
                                                arguments:
                                                    (similarMoviesData[index]
                                                            ?.id ??
                                                        0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 0, 8, 0),
                                                child: Material(
                                                  elevation: 14,
                                                  color: Colors.transparent,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "https://image.tmdb.org/t/p/w500${similarMoviesData[index]?.posterPath ?? ""}",
                                                      fit: BoxFit.cover,
                                                      width: width / 3,
                                                      height: (width / 3) * 1.5,
                                                    ),
                                                  ),
                                                ),
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
                              ),

                              const SizedBox(height: 120),
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

  Widget castPlayers(int movieId) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Container(
          color: widgetBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: ApiClient().credits(movieId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data != null) {
                      var creditsData = snapshot.data as Credits;

                      // profil resmi olmayanları kaldırmasın
                      /*
                      creditsData.cast.removeWhere(
                        (element) => (element.profilePath == null ||
                            element.adult == true),
                      );
                      */
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Oyuncular: ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                height: 1.4,
                                color: normalTextColor,
                              ),
                            ),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              for (var castMember in creditsData.cast)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        "/castPersonsMoviesPage",
                                        arguments: [
                                          castMember.id,
                                          castMember.name
                                        ]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    width: 120,
                                    margin: const EdgeInsets.only(
                                      right: 4,
                                      bottom: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widgetBackgroundColor,
                                    ),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          height: 90,
                                          imageUrl:
                                              "https://image.tmdb.org/t/p/w500${castMember.profilePath}",
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Text(
                                                  castMember.originalName,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: normalTextColor),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                                child: Text(
                                                  "(${castMember.character})",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: normalTextColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              /* Theme(
                                  data: ThemeData(
                                      canvasColor: Colors.transparent),
                                  child: RawChip(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          "/castPersonsMoviesPage",
                                          arguments: [
                                            castMember.id,
                                            castMember.name
                                          ]);
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.all(1.0),
                                    elevation: 0,
                                    label: Text(
                                      "${castMember.originalName} (${castMember.character})",
                                      style: TextStyle(color: normalTextColor),
                                    ),
                                    avatar: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: CachedNetworkImageProvider(
                                          "https://image.tmdb.org/t/p/w500${castMember.profilePath}"),
                                    ),
                                  ),
                                ) */
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget movieDescription(DetailMovie data) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Container(
          color: widgetBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        color: normalTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.overview.toString().isEmpty
                          ? "Film ile ilgili girilmiş bir açıklama metni yok"
                          : data.overview.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: normalTextColor,
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
      padding: const EdgeInsets.only(
        top: 12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: Container(
          color: widgetBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // categories
                  SizedBox(
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
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  "${data?.genres?[index].name.toString() ?? "---"},",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: normalTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 28,
                        glowColor: Colors.red,
                        unratedColor: Colors.black,
                        initialRating: data!.voteAverage! / 2,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.red,
                        ),
                        onRatingUpdate: (rating) {
                          // print(data.voteAverage);
                        },
                      ),
                      Text(
                        "(${(data.voteAverage ?? 0) / 2}) ",
                        style: TextStyle(
                          color: normalTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // year, country, lenght
                  Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // yil
                          Row(
                            children: [
                              Text(
                                "Çıkış Yılı : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: headerTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                toRevolveDate(
                                  data.releaseDate.toString().split(" ")[0],
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: normalTextColor,
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // ulke
                          Row(
                            children: [
                              Text(
                                "Ülke : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: headerTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data.productionCountries!.isEmpty
                                    ? "Belirtilmemiş"
                                    : data.productionCountries![0].name
                                        .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                  color: normalTextColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // sure
                          Row(
                            children: [
                              Text(
                                "Süre : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: headerTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${data.runtime.toString()} dk",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: normalTextColor,
                                ),
                              )
                            ],
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

  Widget screenshotItem(String url, double width) {
    return Material(
      //elevation: 14,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
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
                  enableInfiniteScroll: false),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/images.dart';

class MovieDetailPageYeni extends StatefulWidget {
  const MovieDetailPageYeni({super.key, required this.movieId});
  final int? movieId;

  @override
  State<MovieDetailPageYeni> createState() => _MovieDetailPageYeniState();
}

class _MovieDetailPageYeniState extends State<MovieDetailPageYeni> {
  Color widgetBackgroundColor = Colors.black.withOpacity(0.4);
  Color normalTextColor = Colors.white.withOpacity(0.8);
  Color headerTextColor = Colors.white;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
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
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${data.backdropPath.toString()}",
                  fit: BoxFit.cover,
                ),
              ),

              // ondeki widgetlar
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // film resmi ve ismi
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                                child: SizedBox(
                                  // width: widht - 50,
                                  // height: widht - 50,
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      Image.network(
                                        "https://image.tmdb.org/t/p/w500${data.backdropPath.toString()}",
                                        fit: BoxFit.fitHeight,
                                        width: widht - 50,
                                        height: widht - 50,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: SizedBox(
                                            width: widht - 100,
                                            child: Text(
                                              data.title.toString(),
                                              style: TextStyle(
                                                color: headerTextColor,
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
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
                                  movieDetails(data, widht),
                                ],
                              ),
                            ),
                            // butonlar
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 25,
                                top: 12,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: (widht - 90) / 5,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    // oynat butonu
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(18)),
                                      child: Container(
                                        width: (widht - 90) / 5,
                                        height: (widht - 90) / 5,
                                        color: widgetBackgroundColor,
                                        child: MaterialButton(
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: headerTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(18)),
                                      child: Container(
                                        width: (widht - 90) / 5,
                                        height: (widht - 90) / 5,
                                        color: widgetBackgroundColor,
                                        child: MaterialButton(
                                          onPressed: () {},
                                          child: Icon(
                                            Icons.mode_comment_outlined,
                                            color: headerTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(18)),
                                      child: Container(
                                        width: (widht - 90) / 5,
                                        height: (widht - 90) / 5,
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
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(18)),
                                      child: Container(
                                        width: (widht - 90) / 5,
                                        height: (widht - 90) / 5,
                                        color: widgetBackgroundColor,
                                        child: MaterialButton(
                                          onPressed: () {
                                            pageController.nextPage(
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
                                  ],
                                ),
                              ),
                            ),

                            // Screenshots text
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 25,
                                top: 12,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Screenshots",
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
                                      left: 25,
                                      right: 25,
                                      top: 12,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      // dogru oranin yakalanmasi icin
                                      // 281 / 500 : resim cozunurlugu
                                      height: (widht / 2) * (281 / 500),
                                      child: ListView.builder(
                                        clipBehavior: Clip.none,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data.backdrops?.length ?? 0,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              showScreenshots(
                                                  data, index, widht);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10,
                                              ),
                                              child: screenshotItem(
                                                  "https://image.tmdb.org/t/p/w500${data.backdrops?[index].filePath.toString()}",
                                                  widht / 2),
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
                                      height: (widht / 2) * (281 / 500),
                                      child: ListView.builder(
                                        clipBehavior: Clip.none,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 3,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: SizedBox(
                                              width: widht / 2,
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
                                  ;
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
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }

  Widget screenshotItem(String url, double widht) {
    return Material(
      //elevation: 14,
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: widht,
          // 281 / 500 : resim cozunurlugu
          height: (widht) * (281 / 500),
        ),
      ),
    );
  }

  Widget movieDescription(DetailMovie? data) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 12,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Container(
          color: widgetBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Scrollbar(
                child: SingleChildScrollView(
              child: Text(
                data?.overview.toString() ?? "--",
                overflow: TextOverflow.ellipsis,
                maxLines: 100,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: normalTextColor,
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget movieDetails(DetailMovie? data, double widht) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 12,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
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
                    height: widht / 20,
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
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.red,
                    ),
                    onRatingUpdate: (rating) {
                      // print(data.voteAverage);
                    },
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
                                "Yıl : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: headerTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data.releaseDate.toString().split("-")[0],
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
                                data.productionCountries?[0].name?.toString() ??
                                    "--",
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

  showScreenshots(Images data, int clickedIndex, double widht) {
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
            child: CarouselSlider(
              items: data.backdrops
                  ?.map((backdrop) => screenshotItem(
                      "https://image.tmdb.org/t/p/w500${backdrop.filePath.toString()}",
                      widht))
                  .toList(),
              options: CarouselOptions(
                initialPage: clickedIndex,
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
            ),
          ),
        );
      },
    );
  }
}

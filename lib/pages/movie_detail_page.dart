import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/images.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.movieId});
  final int? movieId;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final double myRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Widget> backdropItemList = [
      createBackdropItem("assets/backdrop_1.jpg", widht),
      createBackdropItem("assets/backdrop_1.jpg", widht),
      createBackdropItem("assets/backdrop_1.jpg", widht),
      createBackdropItem("assets/backdrop_1.jpg", widht),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 360,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 335,
                ),

                // background image
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 16,
                          blurRadius: 40,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(widht, 60),
                        bottomRight: Radius.elliptical(widht, 60),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(widht, 60),
                        bottomRight: Radius.elliptical(widht, 60),
                      ),
                      child: FutureBuilder(
                        future:
                            ApiClient().detailMovieData(widget.movieId ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data != null) {
                            var data = snapshot.data as DetailMovie;
                            /* debugPrint(
                                "----${data.backdrops![0].filePath.toString()}"); */
                            return Image.network(
                              "https://image.tmdb.org/t/p/w500${data.backdropPath.toString()}",
                              width: 1000,
                              height: 300,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return buildLastProcessCardEffect(
                              const Text("Yükleniyor..."),
                              context,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                // appbar
                Positioned(
                  // yoksa ortalarda kalıyor
                  top: -70,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // menu icon
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_left_outlined,
                          color: Colors.white,
                        ),
                      ),
                      // header
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Image.asset(
                            "assets/header_logo.png",
                          ),
                        ),
                      ),

                      // like
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // play button
                Positioned(
                  left: widht / 2 - 35,
                  bottom: 0,
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 50.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                // add and share buttons
                Positioned(
                  // yoksa ortalarda kalıyor
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // add
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),

                      // share
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // movie image and buttons
                // Ekranı kaydırınca appbar da kaysın diyosan, appbarı sil
                // alttaki stacki yorumdan çıkar
                /*
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 335,
                    ),

                    // background image
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 16,
                              blurRadius: 40,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(widht, 60),
                            bottomRight: Radius.elliptical(widht, 60),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(widht, 60),
                            bottomRight: Radius.elliptical(widht, 60),
                          ),
                          child: Image.asset(
                            "assets/black_adam_backdrop.jpg",
                            fit: BoxFit.cover,
                            width: 1000.0,
                            height: 300,
                          ),
                        ),
                      ),
                    ),

                    // appbar
                    Positioned(
                      // yoksa ortalarda kalıyor
                      top: -70,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // menu icon
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                          // header
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(80.0),
                              child: Image.asset(
                                "assets/header_logo.png",
                              ),
                            ),
                          ),

                          // like
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // play button
                    Positioned(
                      left: widht / 2 - 35,
                      bottom: 0,
                      child: Container(
                        width: 70,
                        height: 70,
                        child: RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(10.0),
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 50.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),

                    // add and share buttons
                    Positioned(
                      // yoksa ortalarda kalıyor
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // add
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),

                          // share
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                */

                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: ApiClient().detailMovieData(widget.movieId ?? 0),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData &&
                        snapshot.data != null) {
                      var data = snapshot.data as DetailMovie;
                      /* debugPrint(
                                "----${data.backdrops![0].filePath.toString()}"); */
                      return detailMovieData(widht, backdropItemList, data);
                    } else {
                      return buildLastProcessCardEffect(
                        const Text("Yükleniyor..."),
                        context,
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
                // movie name
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column detailMovieData(
      double widht, List<Widget> backdropItemList, DetailMovie? data) {
    return Column(
      children: [
        SizedBox(
          width: widht / 1.8,
          child: Text(
            data?.tagline.toString() ?? "--",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),

        SizedBox(
          width: widht / 1.8,
          child: Text(
            data?.title.toString() ?? "--",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        // categories
        SizedBox(
          height: widht / 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data?.genres?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      "${data?.genres?[index].name.toString() ?? "---"},",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // rating
        RatingBar.builder(
          itemSize: 28,
          glowColor: Colors.red,
          unratedColor: Colors.black,
          initialRating: 7.291 / 2,
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
            print(rating);
          },
        ),

        const SizedBox(
          height: 10,
        ),

        // year, country, lenght
        SizedBox(
          width: widht / 1.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    "Yıl",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    data?.releaseDate.toString().split("-")[0] ?? "--",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Ülke",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    data?.productionCountries?[0].name.toString() ?? "--",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Süre",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "${data?.runtime.toString() ?? "--"} dk",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

        // movie description
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            data?.overview.toString() ?? "--",
            overflow: TextOverflow.ellipsis,
            maxLines: 6,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),

        // screenshot list
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            children: [
              // Screenshots text and button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Screenshots",
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
              FutureBuilder(
                future: ApiClient().getImages(widget.movieId ?? 0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    var data = snapshot.data as Images;
                    /* debugPrint(
                                "----${data.backdrops![0].filePath.toString()}"); */
                    return SizedBox(
                      width: double.infinity,
                      height: (widht / 2.2) * (281 / 500),
                      child: ListView.builder(
                          clipBehavior: Clip.none,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.backdrops?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500${data.backdrops?[index].filePath.toString()}",
                                width: 150,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                    );
                  } else {
                    return buildLastProcessCardEffect(
                      const Text("Yükleniyor..."),
                      context,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  createBackdropItem(String backdropUrl, double widht) {
    return GestureDetector(
      onTap: () {
        print(backdropUrl);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Material(
          elevation: 14,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(myRadius)),
            child: // image.network
                Image.asset(
              backdropUrl,
              fit: BoxFit.cover,
              width: widht / 2.2,
              // 281 / 500 : resim cozunurlugu
              height: (widht / 2.2) * (281 / 500),
            ),
          ),
        ),
      ),
    );
  }
}

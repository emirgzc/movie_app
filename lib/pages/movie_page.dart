import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/trend_movie.dart';
<<<<<<< HEAD
import 'package:movie_app/pages/list_page.dart';
import 'package:movie_app/pages/movie_detail_page.dart';
import 'package:movie_app/pages/movie_detail_page.dart';
=======
>>>>>>> d19449e6be65d132d2a0e003a2976d6a70f2a71c

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final double myRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // menu icon
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
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
            // search icon
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/searchPage");
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top trend movies slider
              FutureBuilder(
                future: ApiClient().trendData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    var data = snapshot.data as List<Result?>;
                    return CarouselSlider.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index, realIndex) {
                        return createTopSliderItem(
                          (data[index]?.originalTitle ??
                              data[index]?.title ??
                              "--"),
                          (data[index]?.backdropPath ?? "--"),
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
              ),

              // categories
              FutureBuilder(
                future: ApiClient().genres(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    var genresData = snapshot.data as Genres;
                    return SizedBox(
                      width: double.infinity,
                      height: height / 12,
                      child: ListView.builder(
                        clipBehavior: Clip.none,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: genresData.genres.length,
                        itemBuilder: (context, index) {
                          // return Text(genresData.genres[index].name);
                          return createCategoriesItem((height / 12) * 2.4,
                              genresData.genres[index].name);
                        },
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),

              createPosterList(
                  "Popüler Filmler", width, ApiClient().popularData()),

              createPosterList(
                  "En Çok Oy Alan Filmler", width, ApiClient().topRatedData()),

              createPosterList(
                  "Gelmekte Olan Filmler", width, ApiClient().upComingData()),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  createCategoriesItem(double categoryItemWidth, String categoryName) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 12,
          color: Colors.transparent,
          shadowColor: Colors.red,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(myRadius)),
            child: Stack(
              children: [
                // image.network
                /*
                Image.asset(
                  backgroudImageUrl,
                  fit: BoxFit.none,
                  width: categoryItemWidth,
                  height: categoryItemWidth / 2.8,
                ),
                */
                Container(
                  color: const Color.fromARGB(255, 160, 13, 3).withOpacity(0.8),
                  // image widht ve height ile ayni olmali
                  width: categoryItemWidth,
                  height: categoryItemWidth / 2.8,
                  child: Center(
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
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

  createPosterList(
      String listName, double width, Future<List<Result>?> futureGetDataFunc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // liste adı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listName,
                textScaleFactor: 1.2,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/listPage", arguments: listName);
                },
                icon: const Icon(Icons.arrow_forward),
              )
            ],
          ),
          // film afis resmi
          FutureBuilder(
            future: futureGetDataFunc,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                var data = snapshot.data as List<Result?>;
                return SizedBox(
                  width: double.infinity,
                  height: (width / 3) * 1.5,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          "/detailPage",
                          arguments: (data[index]?.id ?? 0),
                        ),
                        child: createBrochureItem(
                            "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
                            width),
                      );
                    },
                  ),
                );
              } else {
                return buildLastProcessCardEffect(
                  const SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                  context,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  createBrochureItem(String brochureUrl, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Material(
        elevation: 14,
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(myRadius)),
          child: CachedNetworkImage(
            imageUrl: brochureUrl,
            fit: BoxFit.cover,
            width: width / 3,
            height: (width / 3) * 1.5,
          ),
        ),
      ),
    );
  }

  createTopSliderItem(
      String? movieName, String? pathImage, List<Result?> data, int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        "/detailPage",
        arguments: (data[index]?.id ?? 0),
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: Material(
          elevation: 12,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(myRadius / 2)),
            child: Stack(
              children: [
                Image.network("https://image.tmdb.org/t/p/w500$pathImage",
                    fit: BoxFit.cover, width: 1000.0),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: Text(
                      movieName ?? "---",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/pages/movie_detail_page.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final double myRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
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
              onPressed: () {},
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
                future: ApiClient().upComingData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    var data = snapshot.data as List<Result?>;
                    debugPrint(data[0]?.posterPath.toString());
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

              // categories part, red boxes
              /* SizedBox(
                width: double.infinity,
                height: categoryItemWidht / 2.2,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesItemList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      categoriesItemList[index],
                ),
              ), 
              */

              // en cok o alan filmler
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "En Çok Oy Alan Filmler",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: ApiClient().topRatedData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null) {
                          var data = snapshot.data as List<Result?>;
                          debugPrint(data[0]?.id.toString());
                          return SizedBox(
                            width: double.infinity,
                            height: (widht / 3) * 1.5,
                            child: ListView.builder(
                              clipBehavior: Clip.none,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailPage(
                                        movieId: (data[index]?.id ?? 0),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
                                    ),
                                  ),
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
              ),

              // trend filmler
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Trend Filmler",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: ApiClient().trendData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null) {
                          var data = snapshot.data as List<Result?>;
                          debugPrint(data[0]?.posterPath.toString());
                          return SizedBox(
                            width: double.infinity,
                            height: (widht / 3) * 1.5,
                            child: ListView.builder(
                              clipBehavior: Clip.none,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailPage(
                                        movieId: (data[index]?.id ?? 0),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
                                    ),
                                  ),
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
              ),

              // populer filmler
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Popüler Filmler",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: ApiClient().popularData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            snapshot.data != null) {
                          var data = snapshot.data as List<Result?>;
                          debugPrint(data[0]?.posterPath.toString());
                          return SizedBox(
                            width: double.infinity,
                            height: (widht / 3) * 1.5,
                            child: ListView.builder(
                              clipBehavior: Clip.none,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailPage(
                                        movieId: (data[index]?.id ?? 0),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
                                    ),
                                  ),
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
              ),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  createBrochureItem(String brochureUrl, double widht) {
    return GestureDetector(
      onTap: () {
        print(brochureUrl);
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
              brochureUrl,
              fit: BoxFit.cover,
              width: widht / 3,
              height: (widht / 3) * 1.5,
            ),
          ),
        ),
      ),
    );
  }

  createCategoriesItem(
      String backgroudImageUrl, String text, double categoryItemWidht) {
    return GestureDetector(
      onTap: () {
        print("$backgroudImageUrl , $text");
      },
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
                Image.asset(
                  backgroudImageUrl,
                  fit: BoxFit.none,
                  width: categoryItemWidht,
                  height: categoryItemWidht / 2.8,
                ),
                Container(
                  color: const Color.fromARGB(255, 160, 13, 3).withOpacity(0.8),
                  // image widht ve height ile ayni olmali
                  width: categoryItemWidht,
                  height: categoryItemWidht / 2.8,
                  child: Center(
                    child: Text(
                      text,
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

  createTopSliderItem(
      String? movieName, String? pathImage, List<Result?> data, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailPage(
            movieId: (data[index]?.id ?? 0),
          ),
        ),
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
                // image.network
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

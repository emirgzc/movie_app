import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/widgets/create_poster_list.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Style.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top trend movies slider
              sliderList(),

              // categories
              genresList(height),

              CreatePosterList(
                listName: "Popüler Filmler",
                width: width,
                futureGetDataFunc: MovieApiClient().popularMovieData(),
              ),

              Padding(
                padding:  EdgeInsets.symmetric(
                    vertical: Style.defaultPaddingSizeVertical),
                child: CreatePosterList(
                  listName: "En Çok Oy Alan Filmler",
                  width: width,
                  futureGetDataFunc: MovieApiClient().topRatedMovieData(),
                ),
              ),

              CreatePosterList(
                listName: "Gelmekte Olan Filmler",
                width: width,
                futureGetDataFunc: MovieApiClient().upComingMovieData(),
              ),
              /* createPosterList("En Çok Oy Alan Diziler", width,
                  TvApiClient().topRatedTvData()), */

              SizedBox(height: 600.h),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<Genres?> genresList(double height) {
    return FutureBuilder(
      future: MovieApiClient().genres(),
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
                return createCategoriesItem(
                    (height / 12) * 2.4, genresData.genres[index].name);
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  FutureBuilder<List<Result>?> sliderList() {
    return FutureBuilder(
      future: MovieApiClient().trendData("movie"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          var data = snapshot.data as List<Result?>;
          return CarouselSlider.builder(
            itemCount: data.length,
            itemBuilder: (context, index, realIndex) {
              return createTopSliderItem(
                (data[index]?.title ?? data[index]?.title ?? "--"),
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
    );
  }

  createCategoriesItem(double categoryItemWidth, String categoryName) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding:  EdgeInsets.all(Style.defaultPaddingSize / 2),
        child: Material(
          elevation: Style.defaultElevation,
          color: Style.transparentColor,
          shadowColor: Colors.red,
          child: ClipRRect(
            borderRadius:  BorderRadius.all(
              Radius.circular(
                Style.defaultRadiusSize / 2,
              ),
            ),
            child: Container(
              color: const Color.fromARGB(255, 160, 13, 3).withOpacity(0.8),
              // image widht ve height ile ayni olmali
              width: categoryItemWidth,
              height: categoryItemWidth / 2.8,
              child: Center(
                child: Text(
                  categoryName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
        (data[index]?.title != null) ? "/movieDetailPage" : "/tvDetailPage",
        arguments: (data[index]?.id ?? 0),
      ),
      child: Container(
        margin:  EdgeInsets.all(Style.defaultPaddingSize / 4),
        padding:  EdgeInsets.fromLTRB(
            0, Style.defaultPaddingSizeVertical / 2, 0, Style.defaultPaddingSizeVertical),
        child: Material(
          elevation: Style.defaultElevation,
          color: Style.transparentColor,
          child: ClipRRect(
            borderRadius:  BorderRadius.all(
              Radius.circular(
                Style.defaultRadiusSize / 2,
              ),
            ),
            child: Stack(
              children: [
                Image.network(
                  "https://image.tmdb.org/t/p/w500$pathImage",
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
                    padding:  EdgeInsets.symmetric(
                      vertical: Style.defaultPaddingSizeVertical / 2,
                      horizontal: Style.defaultPaddingSizeHorizontal,
                    ),
                    child: Text(
                      movieName ?? "---",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Style.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Style.defaultPaddingSize * 1.2,
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

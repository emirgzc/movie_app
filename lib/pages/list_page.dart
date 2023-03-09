import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/list_page_shimmer.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/data/tv_api_client.dart';
import 'package:movie_app/models/genres.dart';
import 'package:movie_app/models/trend_movie.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key, required this.clickedListName});
  String clickedListName;

  @override
  State<ListPage> createState() => _ListPageState();
}

int genreFilterId = 0;

class _ListPageState extends State<ListPage> {
  int page = 1;
  late TextEditingController _textEditingController;
  late Future<List<dynamic>?> listDataFuture;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = page.toString();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clickedListName == "En Çok Oy Alan Filmler") {
      listDataFuture = MovieApiClient().topRatedMovieData(page: page);
    } else if (widget.clickedListName == "Gelmekte Olan Filmler") {
      listDataFuture = MovieApiClient().upComingMovieData(page: page);
    } else if (widget.clickedListName == "Popüler Filmler") {
      listDataFuture = MovieApiClient().popularMovieData(page: page);
    } else if (widget.clickedListName == "En Çok Oy Alan Diziler") {
      listDataFuture = TvApiClient().topRatedTvData();
    } else {
      listDataFuture = MovieApiClient().topRatedMovieData(page: page);
    }

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // header
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Image.asset(
                  "assets/header_logo.png",
                ),
              ),
            ),
            const SizedBox(
              width: 40,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          // 2 tane future bekliyor, future icinde future de yapilabilir
          future: Future.wait([listDataFuture, MovieApiClient().genres()]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              var data = snapshot.data![0] as List<Result?>;
              var genresData = snapshot.data![1] as Genres;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Kategori filtre
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              clipBehavior: Clip.none,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: genresData.genres.length,
                              itemBuilder: (context, index) {
                                return filterGenreItem(
                                    genresData.genres[index].id,
                                    genresData.genres[index].name);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // liste elemanları
                    Expanded(
                      child: ListView(
                        children: [
                          // filmler

                          MasonryGridView.count(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            crossAxisCount: 2,
                            itemBuilder: (BuildContext context, int index) {
                              // film kartları
                              return GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                  "/detailPage",
                                  arguments: (data[index]?.id ?? 0),
                                ),
                                child: ((data[index]
                                                ?.genreIds
                                                ?.contains(genreFilterId) ??
                                            false) ||
                                        genreFilterId == 0)
                                    ? customMovieCard(
                                        data,
                                        genresData,
                                        index,
                                        genreFilterId,
                                        width,
                                      )
                                    : Container(),
                              );
                            },
                          ),
                          // ileri geri sayfa butonları
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // onceki sayfa
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (page > 1) {
                                        setState(() {
                                          page--;
                                          _textEditingController.text =
                                              page.toString();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      padding: const EdgeInsets.all(12),
                                      elevation: 0,
                                      shadowColor: Colors.red,
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Önceki Sayfa",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // page number
                                Expanded(
                                  child: TextField(
                                    controller: _textEditingController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      LengthLimitingTextInputFormatter(
                                        2,
                                      ),
                                    ],
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      fillColor: Colors.black.withOpacity(0.1),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onTap: () {},
                                    onChanged: (value) {},
                                    onSubmitted: (value) {
                                      /*
                                      if (100 > int.parse(value) &&
                                          0 < int.parse(value)) {
                                        setState(() {
                                          page = int.parse(value);
                                        });
                                        */
                                    },
                                  ),
                                ),
                                // sonraki sayfa
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (page < 101) {
                                        setState(() {
                                          page++;
                                          _textEditingController.text =
                                              page.toString();
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      padding: const EdgeInsets.all(12),
                                      elevation: 0,
                                      shadowColor: Colors.red,
                                    ),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Sonraki Sayfa",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: ListPageShimmer(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget customMovieCard(List<Result?> data, Genres genresData, int index,
      int genreFilterId, double width) {
    // if (genreFilterId == 0 || data[index]!.genreIds!.contains(genreFilterId))

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // resim
          Hero(
            tag:
                "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
                height: width / 1.8,
                width: width / 2.2,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // isim ve tarih
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    data[index]?.title ?? "-",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                (data[index]?.releaseDate ?? DateTime.now())
                        .toString()
                        .isNotEmpty
                    ? toRevolveDate((data[index]?.releaseDate ?? DateTime.now())
                        .toString()
                        .substring(0, 10))
                    : "-",
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // rating
          /* Center(
            child: RatingBar.builder(
              ignoreGestures: true,
              itemSize: width / 16,
              glowColor: Colors.yellow,
              unratedColor: Colors.black,
              initialRating: (data[index]?.voteAverage ?? 5) / 2,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (double value) {},
            ),
          ), */

          // divider
          const Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_outlined,
                size: 16,
                color: Colors.amber,
              ),
              Text(
                "Puan : ${data[index]?.voteAverage.toString()}",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // kategoriler

          /* Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (var genreId in data[index]?.genreIds ?? [])
                    for (var element in genresData.genres)
                      if (genreId.toString() == element.id.toString())
                        genreItem(
                            genreId, genreFilterId, element.name.toString()),
                ],
              ),
            ),
          ), */
        ],
      ),
    );
  }

  Widget filterGenreItem(int genreId, String genreName) {
    bool isSelected = genreId == genreFilterId;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isSelected ? genreFilterId = 0 : genreFilterId = genreId;
          });
        },
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.grey.shade800 : Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.grey.shade800 : Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.white : Colors.grey.shade800),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        child: Center(
          child: Text(
            genreName,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.grey.shade800 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget genreItem(
    int genreId,
    int genreFilterId,
    String genreName,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: genreId == genreFilterId
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        genreName,
        style: TextStyle(
          fontSize: 12,
          color: genreId == genreFilterId ? Colors.white : Colors.grey.shade800,
        ),
      ),
    );
  }
}

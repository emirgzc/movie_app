import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/constants/list_page_shimmer.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/detail_movie.dart';
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
  late Future<List<Result>?> listDataFuture;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = page.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clickedListName == "En Çok Oy Alan Filmler") {
      listDataFuture = ApiClient().topRatedData(page: page);
    } else if (widget.clickedListName == "Gelmekte Olan Filmler") {
      listDataFuture = ApiClient().upComingData(page: page);
    } else if (widget.clickedListName == "Popüler Filmler") {
      listDataFuture = ApiClient().popularData(page: page);
    } else {
      listDataFuture = ApiClient().topRatedData(page: page);
    }

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.white,
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
          future: Future.wait([listDataFuture, ApiClient().genres()]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              var data = snapshot.data![0] as List<Result?>;
              var genresData = snapshot.data![1] as Genres;

              return Column(
                children: [
                  // Kategori filtre
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SizedBox(
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
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // liste elemanları
                  Expanded(
                    child: ListView(
                      children: [
                        // filmler
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          clipBehavior: Clip.antiAlias,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (.4 / 1.02),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            // film kartları
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                "/detailPage",
                                arguments: (data[index]?.id ?? 0),
                              ),
                              child: customMovieCard(
                                data,
                                genresData,
                                index,
                                genreFilterId,
                                width,
                              ),
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
                                  onSubmitted: (value) {
                                    if (100 > int.parse(value) &&
                                        0 < int.parse(value)) {
                                      setState(() {
                                        page = int.parse(value);
                                      });
                                    }
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
              );
            } else {
              return const ListPageShimmer();
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // resim
          Hero(
            tag:
                "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl:
                    "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
                height: width / 2.2 * 1.5,
                width: width / 2.2,
                fit: BoxFit.fill,
              ),
            ),
          ),

          // isim ve tarih
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: width / 6,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                    child: RichText(
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(text: "${20 * (page - 1) + index + 1} - "),
                            TextSpan(
                              text: data[index]?.title ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 12),
                child: Text(
                  (data[index]?.releaseDate ?? DateTime.now())
                          .toString()
                          .isNotEmpty
                      ? (data[index]?.releaseDate ?? DateTime.now())
                          .toString()
                          .substring(0, 10)
                      : "-",
                  style: TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          // rating
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
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
            ),
          ),

          // divider
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Divider(
              thickness: 1,
            ),
          ),

          // kategoriler

          Flexible(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget filterGenreItem(int genreId, String genreName) {
    bool isSelected = genreId == genreFilterId;
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isSelected ? genreFilterId = 0 : genreFilterId = genreId;
          });
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.grey.shade800 : Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.white : Colors.grey.shade800),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: genreId == genreFilterId
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
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

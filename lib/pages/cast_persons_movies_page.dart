import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/models/genres.dart';

class CastPersonsMoviesPage extends StatelessWidget {
  CastPersonsMoviesPage(
      {super.key, required this.personId, required this.personName});
  int personId;
  String personName;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Oyuncu : $personName"),
      ),
      body: FutureBuilder(
        future: Future.wait(
            [ApiClient().castPersonsMovies(personId), ApiClient().genres()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            var data = snapshot.data![0] as CastPersonsMovies;
            var genresData = snapshot.data![1] as Genres;

            return GridView.builder(
              // sphysics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data.cast?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (.4 / 1.02),
              ),
              itemBuilder: (BuildContext context, int index) {
                // film kartları
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    "/detailPage",
                    arguments: (data.cast?[index].id ?? 0),
                  ),
                  child: Card(
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
                              "https://image.tmdb.org/t/p/w500${data.cast?[index].posterPath.toString()}",
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://image.tmdb.org/t/p/w500${data.cast?[index].posterPath.toString()}",
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 2),
                                  child: Text(
                                    data.cast?[index].title ?? "-",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 12),
                              child: Text(
                                (data.cast?[index].releaseDate ??
                                            DateTime.now())
                                        .toString()
                                        .isNotEmpty
                                    ? (data.cast?[index].releaseDate ??
                                            DateTime.now())
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
                              initialRating:
                                  (data.cast?[index].voteAverage ?? 5) / 2,
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
                                  for (var genreId
                                      in data.cast?[index].genreIds ?? [])
                                    for (var element in genresData.genres)
                                      if (genreId.toString() ==
                                          element.id.toString())
                                        genreItem(
                                            genreId, element.name.toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget genreItem(
    int genreId,
    String genreName,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        genreName,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/extension.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Oyuncu : $personName"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: Future.wait(
              [ApiClient().castPersonsMovies(personId), ApiClient().genres()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              var data = snapshot.data![0] as CastPersonsMovies;
              var genresData = snapshot.data![1] as Genres;

              return MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.cast?.length ?? 0,
                crossAxisCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  // film kartları
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      "/detailPage",
                      arguments: (data.cast?[index].id ?? 0),
                    ),
                    child: Card(
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
                                "https://image.tmdb.org/t/p/w500${data.cast?[index].posterPath.toString()}",
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://image.tmdb.org/t/p/w500${data.cast?[index].posterPath.toString()}",
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: Text(
                                    data.cast?[index].title ?? "-",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                (data.cast?[index].releaseDate ??
                                            DateTime.now())
                                        .toString()
                                        .isNotEmpty
                                    ? toRevolveDate(
                                        (data.cast?[index].releaseDate ??
                                                DateTime.now())
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
                                "Puan : ${data.cast?[index].voteAverage.toString()}",
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
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
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

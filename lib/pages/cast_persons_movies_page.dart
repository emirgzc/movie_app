import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';

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
        foregroundColor: Style.blackColor,
        title: Text("${LocaleKeys.actor.tr()}: $personName"),
        centerTitle: true,
      ),
      body: Padding(
        padding: Style.pagePadding,
        child: body(width, context),
      ),
    );
  }

  FutureBuilder<CastPersonsMovies?> body(double width, BuildContext context) {
    return FutureBuilder(
      future: MovieApiClient().castPersonsCombined(personId, context.locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          var data = snapshot.data as CastPersonsMovies;

          return listForMovie(data, width);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget listForMovie(CastPersonsMovies data, double width) {
    return MasonryGridView.count(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.cast?.length ?? 0,
      crossAxisCount: 2,
      itemBuilder: (BuildContext context, int index) {
        // film kartları
        return ImageDetailCard(
          title: data.cast?[index].title,
          posterPath: data.cast?[index].posterPath ?? "",
          id: data.cast?[index].id ?? 0,
          voteAverageNumber: data.cast?[index].voteAverage ?? 0,
          width: width,
          dateCard:
              data.cast?[index].releaseDate ?? data.cast?[index].firstAirDate,
          mediaType: data.cast?[index].mediaType.toString(),
          name: data.cast?[index].name ?? "",
        );
      },
    );
  }
}

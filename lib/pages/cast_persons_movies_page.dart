import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';

// ignore: must_be_immutable
class CastPersonsMoviesPage extends StatelessWidget {
  CastPersonsMoviesPage({
    super.key,
    required this.personId,
    required this.personName,
  });
  final int personId;
  final String personName;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _getAppBar(context),
      body: Padding(
        padding: Style.pagePadding,
        child: body(width, context),
      ),
    );
  }

  PreferredSizeWidget _getAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(
        "${LocaleKeys.actor.tr()}: $personName",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
    );
  }

  FutureBuilder<CastPersonsMovies?> body(double width, BuildContext context) {
    return FutureBuilder(
      future: getCastPerson(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data as CastPersonsMovies;

          return listForMovie(data, width);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<CastPersonsMovies?> getCastPerson(BuildContext context) async {
    return await ApiClient().castPersonsCombined(personId, context.locale);
  }

  Widget listForMovie(CastPersonsMovies data, double width) {
    int _crossCount = 2;
    return MasonryGridView.count(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.cast?.length ?? 0,
      crossAxisCount: _crossCount,
      itemBuilder: (BuildContext context, int index) {
        // film kartları
        return ImageDetailCard(
          title: data.cast?[index].title,
          posterPath: data.cast?[index].posterPath,
          id: data.cast?[index].id,
          voteAverageNumber: data.cast?[index].voteAverage,
          width: width,
          dateCard: data.cast?[index].releaseDate ?? data.cast?[index].firstAirDate,
          mediaType: data.cast?[index].mediaType.toString(),
          name: data.cast?[index].name,
        );
      },
    );
  }
}

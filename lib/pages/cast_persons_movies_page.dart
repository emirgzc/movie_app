import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/cast_persons_movies.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';
import 'package:movie_app/widgets/custom_appbar.dart';
import 'package:movie_app/widgets/packages/masonry_grid.dart';
import 'package:movie_app/widgets/text/big_text.dart';

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
    return Scaffold(
      appBar: _getAppBar(context),
      body: Padding(
        padding: Style.pagePadding,
        child: body(context.getSize().width, context),
      ),
    );
  }

  //appbar
  PreferredSizeWidget _getAppBar(BuildContext context) {
    return CustomAppBar(
      title: BigText(title: "${LocaleKeys.actor.tr()}: $personName"),
      leading: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset(
          IconPath.arrow_left.iconPath(),
          height: Style.defaullIconHeight,
          color: context.iconThemeContext().color,
        ),
      ),
      trailing: null,
    );
  }

  //future builder body kısmı
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

  //apiden istek atılması
  Future<CastPersonsMovies?> getCastPerson(BuildContext context) async {
    return await ApiClient().castPersonsCombined(personId, context.locale);
  }

  //filmleri listeleme
  Widget listForMovie(CastPersonsMovies data, double width) {
    return MasonryGrid(
      length: data.cast?.length,
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

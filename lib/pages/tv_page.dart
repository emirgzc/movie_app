import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/data/tv_api_client.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/create_poster_list.dart';

class TVPage extends StatefulWidget {
  const TVPage({super.key});

  @override
  State<TVPage> createState() => _TVPageState();
}

class _TVPageState extends State<TVPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: Style.pagePadding,
            child: Column(
              children: [
                CreatePosterList(
                  listName: LocaleKeys.trending_series_of_the_week.tr(),
                  listType: ListType.trending_series_of_the_week,
                  width: width,
                  futureGetDataFunc:
                      MovieApiClient().trendData("tv", context.locale),
                ),
                CreatePosterList(
                  listName: LocaleKeys.top_rated_series.tr(),
                  listType: ListType.top_rated_series,
                  width: width,
                  futureGetDataFunc:
                      TvApiClient().topRatedTvData(context.locale),
                ),
                CreatePosterList(
                  listName: LocaleKeys.popular_series.tr(),
                  listType: ListType.popular_series,
                  width: width,
                  futureGetDataFunc:
                      TvApiClient().popularTvData(context.locale),
                ),
                CreatePosterList(
                  listName: LocaleKeys.serials_on_air.tr(),
                  listType: ListType.series_on_air,
                  width: width,
                  futureGetDataFunc:
                      TvApiClient().onTheAirTvData(context.locale),
                ),
                const SizedBox(height: 200),
              ],
            ),
          )),
    );
  }
}

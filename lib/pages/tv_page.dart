import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
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
                width: context.getSize().width,
                futureGetDataFunc: ApiClient().trendData("tv", context.locale),
              ),
              CreatePosterList(
                listName: LocaleKeys.top_rated_series.tr(),
                listType: ListType.top_rated_series,
                width: context.getSize().width,
                futureGetDataFunc: ApiClient().getMovieData(
                  context.locale,
                  dataWay: MovieApiType.top_rated.name,
                  type: MediaTypes.tv.name,
                ),
              ),
              CreatePosterList(
                listName: LocaleKeys.popular_series.tr(),
                listType: ListType.popular_series,
                width: context.getSize().width,
                futureGetDataFunc: ApiClient().getMovieData(
                  context.locale,
                  dataWay: MovieApiType.popular.name,
                  type: MediaTypes.tv.name,
                ),
              ),
              CreatePosterList(
                listName: LocaleKeys.serials_on_air.tr(),
                listType: ListType.series_on_air,
                width: context.getSize().width,
                futureGetDataFunc: ApiClient().getMovieData(
                  context.locale,
                  dataWay: MovieApiType.on_the_air.name,
                  type: MediaTypes.tv.name,
                ),
              ),
              SizedBox(height: 600.h),
            ],
          ),
        ),
      ),
    );
  }
}

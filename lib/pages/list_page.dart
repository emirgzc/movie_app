import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/constants/util.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/viewmodels/movie_viewmodel.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';
import 'package:movie_app/widgets/packages/masonry_grid.dart';
import 'package:movie_app/widgets/shimmer/shimmers.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListPage extends StatefulWidget {
  ListPage({super.key, required this.clickedListType});
  ListType clickedListType;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _page = 1;
  late TextEditingController _textEditingController;
  late Future<List<Result>?> _listDataFuture;
  MovieViewModel? _movieViewModel;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = _page.toString();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _movieViewModel ??= Provider.of<MovieViewModel>(context, listen: false);
    _selectApiClientDatas(context);

    return Scaffold(
      appBar: appBar(context),
      body: bodyList(context.getSize().width),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
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
      title: Image.asset(
        Util.isDarkMode(context) ? LogoPath.png_logo_1_dark.iconPath() : LogoPath.png_logo_1_day.iconPath(),
        width: 300.w,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
    );
  }

  FutureBuilder<List<List<Result>?>> bodyList(double width) {
    return FutureBuilder(
      // 2 tane future bekliyor, future icinde future de yapilabilir
      future: Future.wait([_listDataFuture]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data![0] as List<Result>;

          return Padding(
            padding: Style.pagePadding,
            child: Column(
              children: [
                // liste elemanları
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      // filmler
                      MasonryGrid(
                        length: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          // film kartları
                          return ImageDetailCard(
                            title: data[index].title,
                            id: data[index].id,
                            posterPath: data[index].posterPath,
                            voteAverageNumber: data[index].voteAverage,
                            dateCard: data[index].releaseDate.toString() == "null"
                                ? data[index].firstAirDate.toString()
                                : data[index].releaseDate.toString(),
                            width: width,
                            name: data[index].name,
                          );
                        },
                      ),
                      // ileri geri sayfa butonları
                      pageIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Shimmers().listPageShimmer.listPageShimmer(width, context);
        }
      },
    );
  }

  Widget pageIndicator() {
    String arrowLeft = LocaleKeys.previous_page.tr();
    String arrowRight = LocaleKeys.next_page.tr();

    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical * 0.75,
        bottom: Style.defaultPaddingSizeHorizontal * 0.75,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // onceki sayfa
          indicatorArrow(
            arrowLeft,
            () {
              if (_page > 1) {
                setState(() {
                  _page--;
                  _textEditingController.text = _page.toString();
                });
              }
            },
            Icons.arrow_back_ios,
            isVisible: _page > 1,
          ),

          // page number
          Expanded(
            child: indicatorField(),
          ),
          // sonraki sayfa
          indicatorArrow(
            arrowRight,
            () {
              if (_page < 101) {
                setState(() {
                  _page++;
                  _textEditingController.text = _page.toString();
                });
              }
            },
            Icons.arrow_forward_ios,
            isVisible: true,
          ),
        ],
      ),
    );
  }

  Widget indicatorField() {
    return TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(
          2,
        ),
      ],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        fillColor: Style.blackColor.withOpacity(0.1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
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
    );
  }

  Widget indicatorArrow(String title, void Function()? onPressed, IconData icon, {bool isVisible = true}) {
    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 4),
            elevation: 0,
            shadowColor: Style.primaryColor,
          ),
          child: title == LocaleKeys.previous_page.tr()
              ? Row(
                  children: [
                    Icon(
                      icon,
                      color: context.iconThemeContext().color,
                    ),
                    Text(
                      title,
                      style: context.textThemeContext().bodySmall,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      title,
                      style: context.textThemeContext().bodySmall,
                    ),
                    Icon(
                      icon,
                      color: context.iconThemeContext().color,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _selectApiClientDatas(BuildContext context) {
    switch (widget.clickedListType) {
      case ListType.top_rated_movies:
        _listDataFuture = _movieViewModel!.getMovieData(dataWay: MovieApiType.top_rated.name, context.locale, page: _page);

        break;
      case ListType.upcoming_movies:
        _listDataFuture = _movieViewModel!.getMovieData(dataWay: MovieApiType.upcoming.name, context.locale, page: _page);
        break;
      case ListType.popular_movies:
        _listDataFuture = _movieViewModel!.getMovieData(dataWay: MovieApiType.popular.name, context.locale, page: _page);
        break;
      case ListType.movies_in_cinemas:
        _listDataFuture = _movieViewModel!.getMovieData(dataWay: MovieApiType.now_playing.name, context.locale, page: _page);
        break;
      case ListType.trend_movies:
        _listDataFuture = _movieViewModel!.trendData("movie", context.locale);
        break;
      case ListType.top_rated_series:
        _listDataFuture =
            _movieViewModel!.getMovieData(context.locale, page: _page, dataWay: MovieApiType.top_rated.name, type: MediaTypes.tv.name);
        break;
      case ListType.popular_series:
        _listDataFuture =
            _movieViewModel!.getMovieData(context.locale, page: _page, dataWay: MovieApiType.popular.name, type: MediaTypes.tv.name);

        break;
      case ListType.series_on_air:
        _listDataFuture =
            _movieViewModel!.getMovieData(context.locale, page: _page, dataWay: MovieApiType.on_the_air.name, type: MediaTypes.tv.name);
        break;
      case ListType.trending_series_of_the_week:
        _listDataFuture = _movieViewModel!.trendData('tv', context.locale);
        break;

      default:
        _listDataFuture = _movieViewModel!.getMovieData(dataWay: MovieApiType.top_rated.name, context.locale, page: _page);
    }
  }
}

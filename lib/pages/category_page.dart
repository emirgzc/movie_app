import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/constants/util.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/helper/ui_helper.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';
import 'package:movie_app/widgets/custom_appbar.dart';
import 'package:movie_app/widgets/packages/masonry_grid.dart';
import 'package:movie_app/widgets/shimmer/shimmers.dart';
import 'package:movie_app/widgets/text/big_text.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.genreId});
  final int? genreId;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _page = 1;
  List<Result> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: bodyList(context, context.getSize().width),
      ),
    );
  }

  Widget bodyList(BuildContext context, double width) {
    return _page == 1
        ? FutureBuilder(
            future: getCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                data.addAll(snapshot.data as List<Result>);

                return bodyListItem(width, context);
              } else {
                return Shimmers()
                    .listPageShimmer
                    .listPageShimmer(width, context);
              }
            },
          )
        : bodyListItem(width, context);
  }

  Padding bodyListItem(double width, BuildContext context) {
    return Padding(
      padding: Style.pagePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MasonryGrid(
            length: data.length,
            itemBuilder: (BuildContext context, int index) {
              if (data[index].genreIds?.contains(widget.genreId) ?? false) {
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
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          moreButton(context),
        ],
      ),
    );
  }

  MaterialButton moreButton(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        _page = _page + 1;
        await ApiClient()
            .getMovieData(
          dataWay: MovieApiType.now_playing.name,
          context.locale,
          page: _page,
          type: MediaTypes.movie.name,
        )
            .then((value) {
          data.addAll(value as List<Result>);
          setState(() {});
          if (!value
              .any((element) => element.genreIds!.contains(widget.genreId))) {
            Uihelper.showSnackBarDialogBasic(
              context: context,
              text: LocaleKeys.no_suitable_movies_found_on_page_x
                  .tr(args: [_page.toString()]),
              duration: 1,
            );
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.more.tr(),
            style: context.textThemeContext().bodySmall,
          ),
          Icon(
            Icons.refresh,
            color: context.iconThemeContext().color,
          ),
        ],
      ),
    );
  }

  Future<List<Result>?> getCategory() async {
    return await ApiClient().getMovieData(
      dataWay: MovieApiType.now_playing.name,
      context.locale,
      page: _page,
      type: MediaTypes.movie.name,
    );
  }
/*
  PreferredSizeWidget getAppBar() {
    return CustomAppBar(
      title: widget,
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
      trailing: [
        Image.asset(
          Util.isDarkMode(context)
              ? LogoPath.png_logo_1_dark.iconPath()
              : LogoPath.png_logo_1_day.iconPath(),
          width: 300.w,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
*/
}

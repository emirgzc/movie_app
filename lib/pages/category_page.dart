import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/enums.dart';

import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/theme/theme_data_provider.dart';
import 'package:movie_app/theme/theme_light.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.genreId});
  final int? genreId;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _page = 1;
  late TextEditingController _textEditingController;

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
    double width = MediaQuery.of(context).size.width;
    int _crossAxisCount = 2;
    return Scaffold(
      appBar: getAppBar(),
      body: Padding(
        padding: Style.pagePadding,
        child: bodyList(context, _crossAxisCount, width),
      ),
    );
  }

  FutureBuilder<List<Result>?> bodyList(BuildContext context, int _crossAxisCount, double width) {
    return FutureBuilder(
      future: ApiClient().getMovieData(
        dataWay: MovieApiType.now_playing.name,
        context.locale,
        page: _page,
        type: MediaTypes.movie.name,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data as List<Result>;
          return ListView(
            physics: BouncingScrollPhysics(),
            children: [
              MasonryGridView.count(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                crossAxisCount: _crossAxisCount,
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
              pageIndicator(),
            ],
          );
        } else {
          return buildLastProcessCardEffect(
            const SizedBox(
              child: CircularProgressIndicator(),
            ),
            context,
          );
        }
      },
    );
  }

  PreferredSizeWidget getAppBar() {
    ThemeData themeData = Provider.of<ThemeDataProvider>(context).getThemeData;

    return AppBar(
      automaticallyImplyLeading: true,
      title: Image.asset(
        themeData != LightTheme().lightTheme ? "assets/logo/png-logo-1-dark.png" : "assets/logo/png-logo-1-day.png",
        width: 300.w,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
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
            child: TextField(
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
              onSubmitted: (value) {},
            ),
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

  Visibility indicatorArrow(String title, void Function()? onPressed, IconData icon, {bool isVisible = true}) {
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
                      color: Theme.of(context).iconTheme.color,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Icon(
                      icon,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

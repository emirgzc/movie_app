import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/cache/hive/hive_abstract.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/revolve_date.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/helper/ui_helper.dart';
import 'package:movie_app/locator.dart';
import 'package:movie_app/models/credits.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/models/images.dart';
import 'package:movie_app/models/to_watch.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/card/brochure_item.dart';
import 'package:movie_app/widgets/detail_page/tv/opened_text_for_overview.dart';
import 'package:movie_app/widgets/detail_page/watch_card.dart';
import 'package:movie_app/widgets/text/big_text.dart';

class TVDetailPage extends StatefulWidget {
  const TVDetailPage({super.key, required this.movieId});
  final int? movieId;

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  late PageController _pageController;
  late HiveAbstract _hiveAbstract;
  final bool _isOpenedText = false;
  final IApiClient _apiClient = ApiClient();
  Future<TvDetail?>? _tvDetailFuture;
  Future<Credits?>? _peopleFuture;
  Future<Images?>? _imageFuture;
  Future<List<Result>?>? _similarFuture;
  Future<WhereToWatch?>? _whereToWatchFuture;
  Future<WhereToWatch?>? _whereToBuyForWatchFuture;

  late bool _isFavori;

  @override
  void initState() {
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getFutures();
    });
    _hiveAbstract = locator<HiveAbstract<TvDetail>>();
    _isFavori = _hiveAbstract.get(id: widget.movieId ?? 0) != null;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_isFavori.toString());
    return newBody(context.getSize().height, context.getSize().width);
  }

  Scaffold newBody(double height, double width) {
    return Scaffold(
      body: FutureBuilder(
        future: _tvDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
            var data = snapshot.data as TvDetail;
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  imageAndCircleItem(data, height, width, context),
                  Container(
                    padding: Style.pagePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailTop(data),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 3,
                            bottom: Style.defaultPaddingSizeVertical / 2,
                          ),
                          child: BigText(
                            title: data.name ?? "--",
                          ),
                        ),
                        (data.tagline?.isEmpty ?? false)
                            ? SizedBox.shrink()
                            : Text(
                                data.tagline ?? "-",
                                style: context.textThemeContext().titleSmall,
                              ),
                        OpenedTextForOverview(
                          isOpenedText: _isOpenedText,
                          data: data.overview ?? "-",
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: Style.defaultPaddingSizeVertical,
                            bottom: Style.defaultPaddingSizeVertical / 2,
                          ),
                          child: Text(
                            (data.productionCountries?.isEmpty ?? false)
                                ? "${LocaleKeys.country.tr()} : ${LocaleKeys.unspecified.tr()}"
                                : "${LocaleKeys.country.tr()} : ${data.productionCountries?[0].name ?? "-"}",
                            style: context.textThemeContext().bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "${LocaleKeys.relase_date.tr()} : ${toRevolveDate((data.firstAirDate.toString().split(" ")[0]))}",
                          style: context.textThemeContext().bodySmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 3,
                            bottom: Style.defaultPaddingSizeVertical,
                          ),
                          child: BigText(
                            title: LocaleKeys.cast_players.tr(),
                          ),
                        ),
                        peopleList(context),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 2,
                            bottom: Style.defaultPaddingSizeVertical / 2,
                          ),
                          child: BigText(
                            title: LocaleKeys.screenshots.tr(),
                          ),
                        ),
                        imageList(width),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 2,
                            bottom: Style.defaultPaddingSizeVertical / 3,
                          ),
                          child: BigText(
                            title: LocaleKeys.you_may_like.tr(),
                          ),
                        ),
                        similarList(data, context, width),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 2,
                            bottom: Style.defaultPaddingSizeVertical / 3,
                          ),
                          child: BigText(
                            title: LocaleKeys.production_companies.tr(),
                          ),
                        ),
                        (data.productionCompanies?.isEmpty ?? false)
                            ? Text(
                                LocaleKeys.no_producer_company_information_about_this_series_has_been_entered.tr(),
                              )
                            : companyList(data, width),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 2,
                            bottom: Style.defaultPaddingSizeVertical / 3,
                          ),
                          child: BigText(
                            title: LocaleKeys.where_to_watch.tr(),
                          ),
                        ),
                        whereToWatchList(data, context, width),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 2,
                            bottom: Style.defaultPaddingSizeVertical / 3,
                          ),
                          child: BigText(
                            title: LocaleKeys.where_to_watch_buy.tr(),
                          ),
                        ),
                        whereToBuyForWacthList(data, context, width),
                        Padding(
                          padding: EdgeInsets.only(
                            top: (Style.defaultPaddingSizeVertical / 2) * 3,
                          ),
                          child: genresList(data),
                        ),
                        SizedBox(height: 400.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget genresList(TvDetail data) {
    return SizedBox(
      width: double.infinity,
      // dogru oranin yakalanmasi icin
      // 281 / 500 : resim cozunurlugu
      height: 80.h,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: data.genres?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return genresCard(data, index);
        },
      ),
    );
  }

  Widget companyList(TvDetail data, double width) {
    return SizedBox(
      width: double.infinity,
      // dogru oranin yakalanmasi icin
      // 281 / 500 : resim cozunurlugu
      height: 250.h,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: data.productionCompanies?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          if (data.productionCompanies?[index].logoPath != null) {
            return productCompaniesImage(context, data, index, width);
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  FutureBuilder<List<Result>?> similarList(TvDetail data, BuildContext context, double width) {
    return FutureBuilder(
      future: _similarFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var similarMoviesData = snapshot.data as List<Result?>;

          return Padding(
            padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 2),
            child: SizedBox(
              width: double.infinity,
              height: (width / 3) * 1.5,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: similarMoviesData.length,
                // ilk eleman olarak varsa
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      "/tvDetailPage",
                      arguments: (similarMoviesData[index]?.id),
                    ),
                    child: BrochureItem(
                      brochureUrl: "https://image.tmdb.org/t/p/w500${similarMoviesData[index]?.posterPath ?? ""}",
                      width: width,
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<WhereToWatch?> whereToWatchList(TvDetail data, BuildContext context, double width) {
    return FutureBuilder(
      future: _whereToWatchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var watchResult = snapshot.data as WhereToWatch;
          late List<Flatrate> result;
          if (context.locale.languageCode == LanguageCodes.tr.name) {
            result = watchResult.results?.tr?.flatrate ?? [];
          } else {
            result = watchResult.results?.us?.flatrate ?? [];
          }
          return (result.isNotEmpty)
              ? WatchCard(result: result, width: width)
              : Text(
                  LocaleKeys.no_watch_to_description.tr(),
                );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<WhereToWatch?> whereToBuyForWacthList(TvDetail data, BuildContext context, double width) {
    return FutureBuilder(
      future: _whereToBuyForWatchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var watchResult = snapshot.data as WhereToWatch;
          late List<Flatrate> result;
          if (context.locale.languageCode == LanguageCodes.tr.name) {
            result = watchResult.results?.tr?.buy ?? [];
          } else {
            result = watchResult.results?.us?.buy ?? [];
          }
          return (result.isNotEmpty)
              ? WatchCard(result: result, width: width)
              : Text(
                  LocaleKeys.no_watch_to_description.tr(),
                );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<Images?> imageList(double width) {
    return FutureBuilder(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data as Images;

          return Padding(
            padding: EdgeInsets.only(
              top: Style.defaultPaddingSizeVertical / 2,
            ),
            child: SizedBox(
              width: double.infinity,
              // dogru oranin yakalanmasi icin
              // 281 / 500 : resim cozunurlugu
              height: (width / 2) * (281 / 500),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.backdrops?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return screenshotCard(data, index, width);
                },
              ),
            ),
          );
        } else {
          // loading
          return const SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<Credits?> peopleList(BuildContext context) {
    return FutureBuilder(
      future: _peopleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          var creditsData = snapshot.data as Credits;

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  creditsData.cast.length,
                  (index) => peopleCard(context, creditsData, index),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget detailTop(TvDetail data) {
    return Row(
      children: [
        textItemForContainer(
          data,
          Text(
            "${data.numberOfSeasons} ${LocaleKeys.seasons.tr()}",
            style: context.textThemeContext().bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        textItemForContainer(
          data,
          Text(
            "${data.numberOfEpisodes} ${LocaleKeys.episodes.tr()}",
            style: context.textThemeContext().bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        textItemForContainer(
          data,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                IconPath.star_fill.iconPath(),
                height: Style.defaullIconHeight * 0.55,
                // ignore: deprecated_member_use
                color: Style.starColor,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: Style.defaultPaddingSizeHorizontal / 3,
                ),
                child: Text(
                  (data.voteAverage.toString().isEmpty) ? LocaleKeys.unspecified.tr() : ((data.voteAverage)).toString().substring(0, 3),
                  style: context.textThemeContext().bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (Style.defaultPaddingSizeHorizontal / 4) * 3,
          ),
          child: SvgPicture.asset(
            IconPath.plus_square.iconPath(),
            height: Style.defaullIconHeight * 0.8,
            color: context.iconThemeContext().color,
          ),
        ),
        SvgPicture.asset(
          IconPath.share.iconPath(),
          height: Style.defaullIconHeight * 0.8,
          color: context.iconThemeContext().color,
        ),
      ],
    );
  }

  Stack imageAndCircleItem(TvDetail data, double height, double width, BuildContext context) {
    return Stack(
      children: [
        topImage(data, height, width),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: textItemForContainer(
              data,
              Text(
                (data.episodeRunTime?.isEmpty ?? false)
                    ? LocaleKeys.time_not_specified.tr()
                    : "${data.episodeRunTime?[0].toString()} ${LocaleKeys.minutes.tr()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: circleItem(
            context,
            () => Navigator.pop(context),
            IconPath.arrow_left.iconPath(),
          ),
        ),
        FutureBuilder(
          future: ApiClient().getTrailer(widget.movieId ?? 0, context.locale, type: MediaTypes.tv.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
              var data = snapshot.data as Trailer;
              return Positioned(
                left: 180.w,
                bottom: 0,
                child: circleItem(
                  context,
                  () {
                    Navigator.of(context).pushNamed("/trailerPage", arguments: [
                      widget.movieId ?? 0,
                      [data.results],
                    ]);
                  },
                  IconPath.play.iconPath(),
                ),
              );
            } else {
              return Positioned(
                left: 180.w,
                bottom: 0,
                child: circleItem(
                  context,
                  () {},
                  IconPath.play.iconPath(),
                ),
              );
            }
          },
        ),
        _isFavori
            ? SizedBox.shrink()
            : Positioned(
                left: 360.w,
                bottom: 0,
                child: circleItem(
                  context,
                  () async {
                    await _hiveAbstract
                        .add(
                          detail: TvDetail(
                            id: data.id,
                            name: data.name,
                            firstAirDate: data.firstAirDate,
                            posterPath: data.posterPath,
                            backdropPath: data.backdropPath,
                            voteAverage: data.voteAverage,
                          ),
                        )
                        .then(
                          (value) => Uihelper.showSnackBarDialogForInfo(
                            context: context,
                            type: UiType.positive,
                            title: '${data.name}',
                            message: 'Dizi başarılı bir şekilde favorilere eklendi',
                          ),
                        );
                    setState(() {
                      _isFavori = !_isFavori;
                    });
                  },
                  IconPath.favorite.iconPath(),
                ),
              ),
      ],
    );
  }

  Widget genresCard(TvDetail data, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Style.defaultPaddingSizeVertical / 4,
        horizontal: Style.defaultPaddingSizeHorizontal / 2,
      ),
      margin: EdgeInsets.only(
        right: (Style.defaultPaddingSizeHorizontal / 4) * 3,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: context.iconThemeContext().color!.withOpacity(0.15),
        ),
        color: context.publicThemeContext().scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 4,
            color: context.publicThemeContext().shadowColor,
          ),
        ],
      ),
      child: Center(
        child: Text(
          data.genres?[index].name.toString() ?? "---",
          style: context.textThemeContext().bodySmall,
        ),
      ),
    );
  }

  Widget productCompaniesImage(BuildContext context, TvDetail data, int index, double width) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30.0,
                sigmaY: 30.0,
              ),
              child: Material(
                //elevation: 14,
                color: Style.transparentColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Style.defaultPaddingSizeHorizontal * 3,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: "https://image.tmdb.org/t/p/w500${data.productionCompanies?[index].logoPath.toString()}",
                    fit: BoxFit.contain,
                    width: width,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: (Style.defaultPaddingSizeVertical / 2) * 3,
          right: Style.defaultPaddingSizeHorizontal,
        ),
        child: Container(
          padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
          margin: EdgeInsets.only(bottom: Style.defaultPaddingSizeVertical / 2, right: Style.defaultPaddingSizeHorizontal / 2),
          height: 140.h,
          width: 400.w,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Style.blackColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(
              Style.defaultRadiusSize / 4,
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(5, 5),
                blurRadius: 10,
                spreadRadius: 6,
                color: context.publicThemeContext().shadowColor,
              ),
            ],
            color: Style.whiteColor,
          ),
          child: CachedNetworkImage(
            imageUrl: "https://image.tmdb.org/t/p/w500${data.productionCompanies?[index].logoPath.toString()}",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget screenshotCard(Images data, int index, double width) {
    return GestureDetector(
      onTap: () {
        showScreenshots(data, index, width);
      },
      child: Padding(
        padding: EdgeInsets.only(
          right: Style.defaultPaddingSizeHorizontal / 2,
        ),
        child: Container(
          margin: EdgeInsets.only(
            bottom: Style.defaultPaddingSize / 2,
            right: Style.defaultPaddingSize / 2,
          ),
          height: 220.h,
          width: 470.w,
          child: screenshotItem(
            "https://image.tmdb.org/t/p/w500${data.backdrops?[index].filePath}",
          ),
        ),
      ),
    );
  }

  Widget peopleCard(BuildContext context, Credits creditsData, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/castPersonsMoviesPage", arguments: [
          creditsData.cast[index].id,
          creditsData.cast[index].name,
        ]);
      },
      child: SizedBox(
        width: 230.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: Style.defaultPaddingSizeVertical / 2,
                right: Style.defaultPaddingSizeHorizontal / 2,
              ),
              height: 250.h,
              width: 230.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Style.defaultRadiusSize / 4,
                ),
                child: Material(
                  elevation: Style.defaultElevation,
                  child: CachedNetworkImage(
                    imageUrl: "https://image.tmdb.org/t/p/w500${creditsData.cast[index].profilePath}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Style.defaultPaddingSizeHorizontal / 3,
              ),
              child: Text(
                creditsData.cast[index].originalName,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: context.textThemeContext().bodySmall!.copyWith(fontSize: 30.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleItem(BuildContext context, void Function()? onTap, String icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 3),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(5, 5),
              blurRadius: 10,
              color: context.publicThemeContext().shadowColor,
            ),
          ],
          shape: BoxShape.circle,
          color: context.publicThemeContext().scaffoldBackgroundColor,
          border: Border.all(
            width: 1,
            color: context.iconThemeContext().color!.withOpacity(0.15),
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: Style.defaultPaddingSizeHorizontal / 1.5,
          vertical: Style.defaultPaddingSizeVertical / 1.5,
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            height: Style.defaullIconHeight * 0.8,
            color: context.iconThemeContext().color,
          ),
        ),
      ),
    );
  }

  Widget textItemForContainer(TvDetail data, Widget child) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Style.defaultPaddingSizeVertical / 4,
        horizontal: Style.defaultPaddingSizeHorizontal / 3,
      ),
      decoration: BoxDecoration(
        //boxShadow: [Style.defaultShadowDark],
        border: Border.all(
          width: 1,
          color: context.iconThemeContext().color!.withOpacity(0.15),
        ),
        color: context.publicThemeContext().scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(
          Style.defaultRadiusSize / 4,
        ),
      ),
      margin: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal / 2),
      child: child,
    );
  }

  Widget topImage(TvDetail data, double height, double width) {
    return CachedNetworkImage(
      imageUrl: "https://image.tmdb.org/t/p/w500${data.posterPath.toString()}",
      height: height * 0.58,
      width: width,
      fit: BoxFit.cover,
    );
  }

  Widget screenshotItem(String url) {
    return Material(
      elevation: Style.defaultElevation,
      color: Style.transparentColor,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(Style.defaultRadiusSize / 4),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          // 281 / 500 : resim cozunurlugu
        ),
      ),
    );
  }

  showScreenshots(Images data, int clickedIndex, double width) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20.0,
              sigmaY: 20.0,
            ),
            child: CarouselSlider(
              items: data.backdrops
                  ?.map((backdrop) => screenshotItem(
                        "https://image.tmdb.org/t/p/w500${backdrop.filePath.toString()}",
                      ))
                  .toList(),
              options: CarouselOptions(
                initialPage: clickedIndex,
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            ),
          ),
        );
      },
    );
  }

  _getFutures() {
    _tvDetailFuture = _apiClient.detailTvData(widget.movieId ?? 0, context.locale);
    _peopleFuture = _apiClient.getCredits(widget.movieId ?? 0, context.locale, type: MediaTypes.tv.name);
    _imageFuture = _apiClient.getImages(widget.movieId ?? 0, type: MediaTypes.tv.name);
    _similarFuture = _apiClient.similarMoviesData(widget.movieId ?? 0, context.locale, type: MediaTypes.tv.name);
    _whereToWatchFuture = _apiClient.getToWatch(widget.movieId ?? 0, type: MediaTypes.tv.name);
    _whereToBuyForWatchFuture = _apiClient.getToWatch(widget.movieId ?? 0, type: MediaTypes.tv.name);
    setState(() {});
  }
}

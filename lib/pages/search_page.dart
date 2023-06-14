import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/pages.dart';
import 'package:movie_app/constants/revolve_date.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/search.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/packages/masonry_grid.dart';
import 'package:movie_app/widgets/person/person_detail_dialog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _textEditingController;
  late TextEditingController _textEditingControllerForPage;

  int _page = 1;
  late final ScrollController _scrollController;
  String _searchValue = '';
  int _totalPage = 1;
  int _crossAxisCount = 2;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingControllerForPage = TextEditingController();
    _textEditingControllerForPage.text = _page.toString();

    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Padding(
        padding: Style.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FutureBuilder(
              future: ApiClient().search(context.locale,
                  query: _searchValue.isNotEmpty ? _searchValue : "",
                  page: _page),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  var data = snapshot.data as Search;
                  _totalPage = data.totalPages ?? 1;
                  return Expanded(
                    child: MasonryGrid(
                      crossAxisCount: 2,
                      length: data.results?.length,
                      itemBuilder: (context, index) {
                        return searcItemCard(context, data, index,
                            data.results?[index].mediaType);
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: LinearProgressIndicator(
                      color: Colors.grey,
                      backgroundColor: Style.primaryColor,
                    ),
                  );
                }
              },
            ),
            _textEditingController.text.isEmpty
                ? const SizedBox.shrink()
                : pageIndicator(),
          ],
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      leading: appBarBackButton(),
      foregroundColor: Colors.grey.shade800,
      title: textFieldForSearch(),
    );
  }

  Widget textFieldForSearch() {
    return SizedBox(
      width: double.infinity,
      height: 160.h,
      child: Center(
        child: TextFormField(
          style: context.textThemeContext().bodyLarge,
          autofocus: true,
          controller: _textEditingController,
          onChanged: (value) => setState(() => _searchValue = value),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                IconPath.trash.iconPath(),
                height: Style.defaullIconHeight,
                // ignore: deprecated_member_use
                color: Style.primaryColor,
              ),
              onPressed: () => _fieldState(),
            ),
            hintText: LocaleKeys.search.tr(),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  _fieldState() {
    return setState(
      () {
        _textEditingController.clear();
        _textEditingControllerForPage.text = '1';
        _page = 1;
        _searchValue = 'a';
      },
    );
  }

  Widget appBarBackButton() {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: SvgPicture.asset(
        IconPath.arrow_left.iconPath(),
        height: Style.defaullIconHeight,
        color: context.iconThemeContext().color,
      ),
    );
  }

  Widget pageIndicator() {
    String arrowLeft = LocaleKeys.previous_page.tr();
    String arrowRight = LocaleKeys.next_page.tr();

    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical * 0.5,
        bottom: Style.defaultPaddingSizeHorizontal * 0.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // onceki sayfa
          Visibility(
            visible: _page > 1,
            child: Padding(
              padding: EdgeInsets.all(Style.defaultPaddingSize / 4),
              child: ElevatedButton(
                onPressed: () {
                  if (_page > 1) {
                    setState(() {
                      _page--;
                      _textEditingControllerForPage.text = _page.toString();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Style.transparentColor,
                  padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 4),
                  elevation: 0,
                  shadowColor: Style.whiteColor,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      IconPath.arrow_left.iconPath(),
                      height: Style.defaullIconHeight * 0.9,
                      color: context.iconThemeContext().color,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: Style.defaultPaddingSizeHorizontal / 2),
                      child: Text(
                        arrowLeft,
                        style: context
                            .textThemeContext()
                            .bodySmall!
                            .copyWith(fontSize: 34.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // page number
          SizedBox(
            width: 100.w,
            child: TextField(
              controller: _textEditingControllerForPage,
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
                  borderRadius:
                      BorderRadius.circular(Style.defaultRadiusSize / 2),
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
            ),
          ),
          // sonraki sayfa
          Visibility(
            visible: _totalPage > _page,
            child: Padding(
              padding: EdgeInsets.all(Style.defaultPaddingSize / 4),
              child: ElevatedButton(
                onPressed: () {
                  if (_page < 101) {
                    setState(() {
                      _page++;
                      _textEditingControllerForPage.text = _page.toString();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Style.transparentColor,
                  padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 4),
                  elevation: 0,
                  shadowColor: Style.whiteColor,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: Style.defaultPaddingSizeHorizontal / 2),
                      child: Text(
                        arrowRight,
                        style: context
                            .textThemeContext()
                            .bodySmall!
                            .copyWith(fontSize: 34.sp),
                      ),
                    ),
                    SvgPicture.asset(
                      IconPath.arrow_right.iconPath(),
                      height: Style.defaullIconHeight * 0.9,
                      color: context.iconThemeContext().color,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searcItemCard(
      BuildContext context, Search data, int index, String? mediaType) {
    int _starCount = 5;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        if (mediaType == MediaTypes.person.name &&
            data.results?[index].profilePath != null) {
          showPersonDetail(data.results?[index]);
        } else if (data.results?[index].posterPath == null) {
        } else {
          Navigator.of(context).pushNamed(
            mediaType == MediaTypes.movie.name
                ? Pages.movieDetailPage
                : Pages.tvDetailPage,
            arguments: data.results?[index].id,
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: Style.defaultElevation,
        shadowColor: context.publicThemeContext().shadowColor.withOpacity(0.8),
        child: Padding(
          padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // resim
              (data.results?[index].posterPath != null ||
                      data.results?[index].profilePath != null)
                  ? image(data, index, mediaType)
                  : Padding(
                      padding:
                          EdgeInsets.only(bottom: Style.defaultPaddingSize / 2),
                      child: Placeholder(
                        fallbackHeight: 600.h,
                      ),
                    ),

              // isim, tarih, derecelendirme, kategoriler
              Text(
                mediaType == MediaTypes.movie.name
                    ? (data.results?[index].title ?? '-')
                    : (data.results?[index].name ?? '-'),
                style: context.textThemeContext().bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              (mediaType == MediaTypes.person.name)
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Style.defaultPaddingSizeVertical / 4),
                      child: Text(
                        toRevolveDate(
                            checkDateType(mediaType, data.results?[index]) ??
                                DateTime.now().toString()),
                        style: context.textThemeContext().bodySmall!.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 30.sp,
                            ),
                      ),
                    ),
              (mediaType == MediaTypes.person.name)
                  ? const SizedBox.shrink()
                  : RatingBar.builder(
                      ignoreGestures: true,
                      itemSize: 36.r,
                      glowColor: Style.starColor,
                      unratedColor: context
                          .publicThemeContext()
                          .shadowColor
                          .withOpacity(0.4),
                      initialRating:
                          (data.results?[index].voteAverage ?? 0.0) / 2,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: _starCount,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Style.starColor,
                      ),
                      onRatingUpdate: (double value) {},
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future showPersonDetail(SearchResult? data) {
    return showDialog(
      barrierColor: Style.blackColor.withOpacity(0.9),
      useSafeArea: true,
      context: context,
      builder: (context) {
        return PersonDetailDialog(data: data);
      },
    );
  }

  Widget image(Search data, int index, String? mediaType) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Style.defaultPaddingSizeHorizontal / 2,
      ),
      child: Hero(
        tag:
            'https://image.tmdb.org/t/p/w500${(mediaType == MediaTypes.movie.name || mediaType == MediaTypes.tv.name) ? (data.results?[index].posterPath) : data.results?[index].profilePath}',
        child: CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${(mediaType == MediaTypes.movie.name || mediaType == MediaTypes.tv.name) ? (data.results?[index].posterPath) : data.results?[index].profilePath}',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String? checkMediaType(String? mediaType) {
    if (mediaType == MediaTypes.movie.name) {
      return ConvertToMediaTypes.Film.name.toString();
    } else if (mediaType == MediaTypes.tv.name) {
      return ConvertToMediaTypes.Dizi.name.toString();
    } else if (mediaType == MediaTypes.person.name) {
      return ConvertToMediaTypes.Oyuncu.name.toString();
    } else {
      return null;
    }
  }

  String? checkDateType(String? mediaType, SearchResult? result) {
    if (result != null) {
      if (mediaType == MediaTypes.movie.name) {
        return result.releaseDate.toString();
      } else if (mediaType == MediaTypes.tv.name) {
        return result.firstAirDate.toString();
      } else {
        return DateTime.now().toString();
      }
    } else {
      return DateTime.now().toString();
    }
  }
}

// ignore: constant_identifier_names
enum ConvertToMediaTypes { Film, Dizi, Oyuncu }

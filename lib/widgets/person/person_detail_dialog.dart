import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/models/search.dart';
import 'package:movie_app/translations/locale_keys.g.dart';

class PersonDetailDialog extends StatefulWidget {
  const PersonDetailDialog({super.key, required this.data});
  final SearchResult? data;

  @override
  State<PersonDetailDialog> createState() => _PersonDetailDialogState();
}

class _PersonDetailDialogState extends State<PersonDetailDialog> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSize * 2, horizontal: Style.defaultPaddingSize),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: EdgeInsets.all(Style.defaultPaddingSize),
        decoration: BoxDecoration(
          color: context.publicThemeContext().scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${widget.data?.profilePath}',
              height: 600.h,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSize / 2),
              child: Text(
                widget.data?.name ?? "--",
                style: context.textThemeContext().titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Style.defaultPaddingSize / 2),
              child: Text(
                LocaleKeys.featured_movies.tr(),
                textAlign: TextAlign.center,
                style: context.textThemeContext().bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            topRatedList(),
            Padding(
              padding: EdgeInsets.only(top: Style.defaultPaddingSize / 2),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Style.primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    "/castPersonsMoviesPage",
                    arguments: [
                      widget.data?.id,
                      widget.data?.name,
                    ],
                  );
                },
                child: Text(LocaleKeys.see_all_movies.tr()),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget topRatedList() {
    return SizedBox(
      height: 450.h,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.data?.knownFor?.length ?? 0,
        itemBuilder: (context, index) {
          if (widget.data?.knownFor?[index].posterPath == null) {
            return const SizedBox.shrink();
          }
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                (widget.data?.knownFor?[index].mediaType == MediaTypes.movie.name) ? "/movieDetailPage" : "/tvDetailPage",
                arguments: widget.data?.knownFor?[index].id,
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: Style.defaultPaddingSize / 2),
              child: Column(
                children: [
                  Expanded(
                    child: Material(
                      elevation: Style.defaultElevation,
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500${widget.data?.knownFor?[index].posterPath}',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Style.defaultPaddingSize / 4),
                    child: Row(
                      children: [
                        RatingBar.builder(
                          ignoreGestures: true,
                          itemSize: 32.r,
                          glowColor: Style.starColor,
                          unratedColor: context.publicThemeContext().shadowColor.withOpacity(0.4),
                          initialRating: (widget.data?.knownFor?[index].voteAverage ?? 0.0) / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Style.starColor,
                          ),
                          onRatingUpdate: (double value) {},
                        ),
                        Text(
                          '(${(widget.data?.knownFor?[index].voteAverage).toString().substring(0, 3).toString()})',
                          style: context.textThemeContext().bodySmall!.copyWith(
                                fontSize: 30.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

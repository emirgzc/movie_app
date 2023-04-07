import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/revolve_date.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/translations/locale_keys.g.dart';

class ImageDetailCard extends StatelessWidget {
  const ImageDetailCard({
    super.key,
    required this.title,
    required this.id,
    required this.width,
    required this.posterPath,
    required this.voteAverageNumber,
    required this.dateCard,
    this.mediaType,
    required this.name,
  });
  final String? title;
  final String? posterPath;
  final String? dateCard;
  final double? voteAverageNumber;
  final int? id;
  final double width;
  final String? mediaType;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        (title != null) ? "/movieDetailPage" : "/tvDetailPage",
        arguments: (id ?? 0),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: Style.defaultPaddingSize.h,
          horizontal: Style.defaultPaddingSize.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: Style.defaultRadius,
        ),
        elevation: Style.defaultElevation,
        shadowColor: context.publicThemeContext().shadowColor.withOpacity(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // resim
            imageHero(posterPath, width),
            // isim ve tarih
            titleAndDate(title, name, dateCard, context),
            // divider
            const Divider(
              thickness: 1,
            ),
            voteAverage(voteAverageNumber, context),
          ],
        ),
      ),
    );
  }

  Widget imageHero(String? image, double width) {
    return Hero(
      tag: "https://image.tmdb.org/t/p/w500$image",
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            Style.defaultRadiusSize / 2,
          ),
          topRight: Radius.circular(
            Style.defaultRadiusSize / 2,
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: "https://image.tmdb.org/t/p/w500$image",
          height: width / 1.8,
          width: width / 2.2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget voteAverage(double? voteAverage, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Style.defaultPaddingSize.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            IconPath.star_fill.iconPath(),
            height: Style.defaullIconHeight * 0.6,
            // ignore: deprecated_member_use
            color: Style.starColor,
          ),
          Padding(
            padding: EdgeInsets.only(left: Style.defaultPaddingSizeHorizontal / 6),
            child: Text(
              "${LocaleKeys.score.tr()} : ${voteAverage.toString().substring(0, 3)}",
              style: context.textThemeContext().bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget titleAndDate(String? titleCard, String? name, String? dateCard, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: Style.defaultSymetricPadding / 3,
          child: Center(
            child: Text(
              (titleCard == null) ? name.toString() : titleCard.toString(),
              textAlign: TextAlign.center,
              style: context.textThemeContext().titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        (mediaType == null)
            ? SizedBox.shrink()
            : Text(
                (mediaType ?? "") == MediaTypes.movie.name ? LocaleKeys.movie_actor.tr() : LocaleKeys.seral_actor.tr(),
                style: context.textThemeContext().bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
        Padding(
          padding: EdgeInsets.only(
            top: Style.defaultPaddingSizeVertical / 3,
          ),
          child: Text(
            (dateCard ?? DateTime.now()).toString().isNotEmpty ? toRevolveDate((dateCard ?? DateTime.now()).toString()) : "-",
            style: TextStyle(color: Style.dateColor, fontSize: 30.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

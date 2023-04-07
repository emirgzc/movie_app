import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/translations/locale_keys.g.dart';

class DrawerMenuScreen extends StatelessWidget {
  const DrawerMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal / 2),
      child: LayoutBuilder(
        builder: (p0, p1) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: p1.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    drawerListItem(
                      LocaleKeys.movies_in_cinemas.tr(),
                      IconPath.camera.iconPath(),
                      () {
                        Navigator.of(context).pushNamed(
                          "/listPage",
                          arguments: ListType.movies_in_cinemas,
                        );
                      },
                      context,
                    ),
                    drawerListItem(
                      LocaleKeys.trend_movies.tr(),
                      IconPath.star.iconPath(),
                      () {
                        Navigator.of(context).pushNamed(
                          "/listPage",
                          arguments: ListType.trend_movies,
                        );
                      },
                      context,
                    ),
                    drawerListItem(
                      LocaleKeys.upcoming_movies.tr(),
                      IconPath.times.iconPath(),
                      () {
                        Navigator.of(context).pushNamed(
                          "/listPage",
                          arguments: ListType.upcoming_movies,
                        );
                      },
                      context,
                    ),
                    drawerListItem(
                      LocaleKeys.favorites.tr(),
                      IconPath.favorite.iconPath(),
                      () {},
                      context,
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget drawerListItem(String text, String? icon, void Function()? onTap, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Style.defaultRadiusSize / 2),
            bottomRight: Radius.circular(Style.defaultRadiusSize / 2),
          ),
        ),
        //tileColor: backgroundColor,
        minLeadingWidth: 50.w,
        leading: SvgPicture.asset(
          icon ?? '',
          height: Style.defaullIconHeight * 0.8,
          // ignore: deprecated_member_use
          color: context.iconThemeContext().color,
        ),
        onTap: onTap,
        title: Text(
          text,
        ),
      ),
    );
  }
}

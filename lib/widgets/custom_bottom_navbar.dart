import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/translations/locale_keys.g.dart';

// ignore: must_be_immutable
class CustomBottomNavbar extends StatefulWidget {
  CustomBottomNavbar(this._currentIndex, {required this.setIndex, super.key});
  final ValueSetter setIndex;
  int _currentIndex;
  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  @override
  Widget build(BuildContext context) {
    ;

    return BubbleBottomBar(
      backgroundColor: context.publicThemeContext().scaffoldBackgroundColor,
      borderRadius: Style.defaultRadius,
      opacity: .2,
      hasNotch: true,
      hasInk: true,
      fabLocation: BubbleBottomBarFabLocation.end,
      currentIndex: widget._currentIndex,
      onTap: (value) {
        setState(() {
          widget._currentIndex = value!;
          widget.setIndex(widget._currentIndex);
        });
      },
      elevation: 10,
      tilesPadding: EdgeInsets.only(
        bottom: 10,
        top: 10,
      ),
      items: [
        bubbleBottomBarItem(
          Style.movieTabColor,
          IconPath.film.iconPath(),
          LocaleKeys.movie.tr(),
        ),
        bubbleBottomBarItem(
          Style.serieTabColor,
          IconPath.tv.iconPath(),
          LocaleKeys.tv_series.tr(),
        ),
        bubbleBottomBarItem(
          Style.favoriteTabColor,
          IconPath.favorite.iconPath(),
          LocaleKeys.favorites.tr(),
        ),
        bubbleBottomBarItem(
          Style.settingsTabColor,
          IconPath.settings.iconPath(),
          LocaleKeys.settings.tr(),
        ),
      ],
    );
  }

  BubbleBottomBarItem bubbleBottomBarItem(
    Color color,
    String icon,
    String text,
  ) {
    return BubbleBottomBarItem(
      backgroundColor: color,
      icon: SvgPicture.asset(
        icon,
        height: Style.defaullIconHeight * 0.9,
      ),
      activeIcon: SvgPicture.asset(
        icon,
        height: Style.defaullIconHeight * 0.9,
        // ignore: deprecated_member_use
        color: color,
      ),
      title: Text(text),
    );
  }
}

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/translations/locale_keys.g.dart';

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
    return BubbleBottomBar(
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
          Icons.movie_creation_outlined,
          LocaleKeys.movie.tr(),
        ),
        bubbleBottomBarItem(
          Style.serieTabColor,
          Icons.tv_outlined,
          LocaleKeys.tv_series.tr(),
        ),
        bubbleBottomBarItem(
          Style.favoriteTabColor,
          Icons.favorite_border_outlined,
          LocaleKeys.favorites.tr(),
        ),
        bubbleBottomBarItem(
          Style.settingsTabColor,
          Icons.settings_outlined,
          LocaleKeys.settings.tr(),
        ),
      ],
    );
  }

  BubbleBottomBarItem bubbleBottomBarItem(
    Color color,
    IconData icon,
    String text,
  ) {
    return BubbleBottomBarItem(
      backgroundColor: color,
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      activeIcon: Icon(
        icon,
        color: color,
      ),
      title: Text(text),
    );
  }
}

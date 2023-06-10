import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/constants/util.dart';
import 'package:movie_app/helper/ui_helper.dart';
import 'package:movie_app/pages/favorite_page.dart';
import 'package:movie_app/pages/maps_page.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/settings_page.dart';
import 'package:movie_app/pages/tv_page.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/custom_appbar.dart';
import 'package:movie_app/widgets/custom_bottom_navbar.dart';
import 'package:movie_app/widgets/drawer_menu_screen.dart';

part '../widgets/part_of_apbar_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late ZoomDrawerController _drawerController;
  int _currentPage = 0;

  late StreamSubscription<InternetConnectionStatus> internetConnectionListener;

  @override
  void initState() {
    internetConnectionListener =
        InternetConnectionChecker().onStatusChange.listen((status) {
      ScaffoldMessenger.of(context).clearSnackBars();
      setState(() {});
    });

    _pageController = PageController(keepPage: true);
    _drawerController = ZoomDrawerController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    internetConnectionListener.cancel();

    super.dispose();
  }

  List<Widget> pageList = [
    const MoviePage(),
    const TVPage(),
    FavoritePage(),
    const SettingsPage(),
    MapsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    connectionStatusSnackbar();

    return Scaffold(
      extendBody: true,
      // appbar
      appBar: PartOfHomePageAppBar(drawerController: _drawerController),

      // body
      body: drawer(context),

      // bottomnavbar
      bottomNavigationBar: CustomBottomNavbar(
        _currentPage,
        setIndex: (index) {
          _pageController.jumpToPage(index);
        },
      ),

      floatingActionButton: floatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  connectionStatusSnackbar() async {
    await (InternetConnectionChecker().hasConnection).then(
      (value) {
        if (!value) {
          Uihelper.showSnackBarDialogBasic(
              context: context,
              text: LocaleKeys.you_are_offline_now.tr(),
              duration: 100);
        }
      },
    );
  }

  Widget floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        _pageController.jumpToPage(4);
      },
      elevation: 0,
      backgroundColor: Style.fabColor,
      child: Container(
        padding: EdgeInsets.all(Style.defaultPaddingSize * 0.9),
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: SvgPicture.asset(
          IconPath.location.iconPath(),
          height: Style.defaullIconHeight,
          // ignore: deprecated_member_use
          color: Style.whiteColor,
        ),
      ),
    );
  }

  Widget drawer(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.defaultStyle,
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      controller: _drawerController,
      menuBackgroundColor: context.publicThemeContext().scaffoldBackgroundColor,
      shadowLayer1Color: Colors.grey.shade200,
      shadowLayer2Color: Colors.grey.shade400,
      menuScreen: DrawerMenuScreen(),
      mainScreen: PageView.builder(
        physics: BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        onPageChanged: (value) {
          if (value != 4) {
            setState(() {
              _currentPage = value;
            });
          }
        },
        controller: _pageController,
        itemCount: pageList.length,
        itemBuilder: (context, index) {
          return pageList[index];
        },
      ),
    );
  }
}

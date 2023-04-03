import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/settings_page.dart';
import 'package:movie_app/pages/tv_page.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/custom_bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;
  late PageController _pageController;
  final _drawerController = ZoomDrawerController();

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> pageList = [
    const MoviePage(),
    const TVPage(),
    Container(color: Colors.purple.shade200),
    SettingsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    print(context.locale);
    return Scaffold(
      backgroundColor: Style.whiteColor,
      extendBody: true,
      // appbar
      appBar: appBar(context),

      // body
      body: drawer(context),

      // bottomnavbar
      bottomNavigationBar: CustomBottomNavbar(
        setIndex: (index) {
          _pageController.jumpToPage(index);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Style.fabColor,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            boxShadow: [
              BoxShadow(
                color: Style.fabColor.withOpacity(0.3),
                spreadRadius: 7,
                blurRadius: 7,
                offset: Offset(3, 5),
              ),
            ],
          ),
          child: Icon(Icons.location_pin),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget drawer(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.defaultStyle,
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      controller: _drawerController,
      menuBackgroundColor: Style.whiteColor,
      //borderRadius: 24.0,
      //showShadow: true,
      //angle: -0.0,
      //mainScreenScale: 0.2,
      shadowLayer1Color: Colors.grey.shade200,
      shadowLayer2Color: Colors.grey.shade400,
      // drawer ekrani
      menuScreen: Padding(
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
                        Icons.person_outline_outlined,
                        () {
                          Navigator.of(context).pushNamed(
                            "/listPage",
                            arguments: "Yayında Olan Filmler",
                          );
                        },
                      ),
                      drawerListItem(
                        LocaleKeys.trend_movies.tr(),
                        Icons.star_border_outlined,
                        () {
                          Navigator.of(context).pushNamed(
                            "/listPage",
                            arguments: "Trend Filmler",
                          );
                        },
                      ),
                      drawerListItem(
                        LocaleKeys.upcoming_movies.tr(),
                        Icons.hourglass_empty_outlined,
                        () {
                          Navigator.of(context).pushNamed(
                            "/listPage",
                            arguments: "Gelmekte Olan Filmler",
                          );
                        },
                      ),
                      drawerListItem(LocaleKeys.favorites.tr(),
                          Icons.favorite_border_outlined, () {}),
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
      ),
      mainScreen: PageView.builder(
        controller: _pageController,
        itemCount: pageList.length,
        itemBuilder: (context, index) {
          return pageList[index];
        },
      ),
      //pageList[_selectedIndex],
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      foregroundColor: Style.blackColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // menu icon
          IconButton(
            onPressed: () {
              _drawerController.toggle?.call();
            },
            icon: const Icon(
              Icons.menu,
            ),
          ),
          // header
          Image.asset(
            "assets/logo/light-lg1.jpg",
            width: 300.w,
            fit: BoxFit.contain,
          ),
          // search icon
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/searchPage");
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerListItem(String text, IconData? icon, void Function()? onTap) {
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
        leading: Icon(
          icon,
          color: Style.blackColor,
        ),
        onTap: onTap,
        title: Text(
          text,
          style: const TextStyle(
            color: Style.blackColor,
          ),
        ),
      ),
    );
  }
}

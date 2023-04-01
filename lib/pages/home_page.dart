import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/settings_page.dart';
import 'package:movie_app/pages/tv_page.dart';

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

  List pageList = [
    const MoviePage(),
    const TVPage(),
    Container(color: Colors.purple.shade200),
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
      bottomNavigationBar: bottomNavBar(),
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
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: p1.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      drawerListItem(
                        "Vizyondaki Filmler",
                        Icons.person_outline_outlined,
                        () {
                          Navigator.of(context).pushNamed(
                            "/listPage",
                            arguments: "Yayında Olan Filmler",
                          );
                        },
                      ),
                      drawerListItem(
                        "Trend Filmler",
                        Icons.star_border_outlined,
                        () {
                          Navigator.of(context).pushNamed(
                            "/listPage",
                            arguments: "Trend Filmler",
                          );
                        },
                      ),
                      drawerListItem(
                        "Gelecek Filmler",
                        Icons.hourglass_empty_outlined,
                        () {
                          Navigator.of(context).pushNamed(
                            "/listPage",
                            arguments: "Gelmekte Olan Filmler",
                          );
                        },
                      ),
                      drawerListItem(
                          "Favoriler", Icons.favorite_border_outlined, () {}),
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

      mainScreen: pageList[_selectedIndex],
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

  SafeArea bottomNavBar() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(Style.defaultPaddingSize / 2),
        decoration: BoxDecoration(
          // dış kutu borderradius
          borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
          color: Style.whiteColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Style.blackColor.withOpacity(.1),
            )
          ],
        ),
        child: Padding(
          padding: Style.defaultSymetricPadding / 2,
          child: GNav(
            tabBorderRadius: Style.defaultRadiusSize / 2,
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,

            iconSize: Style.defaultIconsSize * (3 / 2),
            padding: EdgeInsets.symmetric(
              horizontal: Style.defaultPaddingSizeHorizontal,
              vertical: (Style.defaultPaddingSizeVertical / 4) * 3,
            ),
            duration: const Duration(milliseconds: 400),
            color: Style.blackColor,
            // curve: Curves.bounceIn,
            tabs: [
              GButton(
                backgroundColor: Colors.red.withOpacity(0.2),
                iconActiveColor: Colors.red,
                textColor: Colors.red,
                icon: Icons.movie_creation_outlined,
                text: 'Film',
              ),
              GButton(
                backgroundColor: Colors.blue.withOpacity(0.2),
                iconActiveColor: Colors.blue,
                textColor: Colors.blue,
                icon: Icons.tv_outlined,
                text: 'Dizi',
              ),
              GButton(
                backgroundColor: Colors.purple.withOpacity(0.2),
                iconActiveColor: Colors.purple,
                textColor: Colors.purple,
                icon: Icons.favorite_border_outlined,
                text: 'Favori',
              ),
              GButton(
                backgroundColor: Colors.cyan.withOpacity(0.2),
                iconActiveColor: Colors.cyan,
                textColor: Colors.cyan,
                icon: Icons.settings_outlined,
                text: 'Ayarlar',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
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

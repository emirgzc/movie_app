import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/pages/movie_page.dart';
import 'package:movie_app/pages/settings_page.dart';
import 'package:movie_app/pages/tv_page.dart';
import 'package:movie_app/theme/theme_data_provider.dart';
import 'package:movie_app/theme/theme_light.dart';
import 'package:movie_app/widgets/custom_bottom_navbar.dart';
import 'package:movie_app/widgets/drawer_menu_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late ZoomDrawerController _drawerController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(keepPage: true);
    _drawerController = ZoomDrawerController();
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
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    print(context.locale);
    return Scaffold(
      extendBody: true,
      // appbar
      appBar: appBar(context),

      // body
      body: drawer(context),

      // bottomnavbar
      bottomNavigationBar: CustomBottomNavbar(
        _currentPage,
        setIndex: (index) {
          _pageController.jumpToPage(index);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        backgroundColor: Style.fabColor,
        child: Container(
          padding: EdgeInsets.all(Style.defaultPaddingSize * 0.9),
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: SvgPicture.asset(
            IconPath.location.iconPath(),
            height: Style.defaullIconHeight,
            color: Style.whiteColor,
          ),
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
      menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //borderRadius: 24.0,
      //showShadow: true,
      //angle: -0.0,
      //mainScreenScale: 0.2,
      shadowLayer1Color: Colors.grey.shade200,
      shadowLayer2Color: Colors.grey.shade400,

      menuScreen: DrawerMenuScreen(),
      mainScreen: PageView.builder(
        onPageChanged: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        controller: _pageController,
        itemCount: pageList.length,
        itemBuilder: (context, index) {
          return pageList[index];
        },
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    ThemeData themeData = Provider.of<ThemeDataProvider>(context).getThemeData;

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // menu icon
          IconButton(
            onPressed: () {
              _drawerController.toggle?.call();
            },
            icon: SvgPicture.asset(
              IconPath.menu_list.iconPath(),
              height: Style.defaullIconHeight,
            ),
          ),
          // header
          Image.asset(
            themeData != LightTheme().lightTheme ? "assets/logo/png-logo-1-dark.png" : "assets/logo/png-logo-1-day.png",
            width: 300.w,
            fit: BoxFit.contain,
          ),
          // search icon
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/searchPage");
            },
            icon: SvgPicture.asset(
              IconPath.search.iconPath(),
              height: Style.defaullIconHeight,
            ),
          ),
        ],
      ),
    );
  }
}

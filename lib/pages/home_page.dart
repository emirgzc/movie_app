import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movie_app/pages/movie_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedIndex = 0;
  late PageController _pageController;
  final _drawerController = ZoomDrawerController();
  final double borderRadius = 12.0;

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
    MoviePage(),
    Container(color: Colors.blue.shade200),
    Container(color: Colors.purple.shade200),
    Container(color: Colors.cyan.shade200),
  ];

  @override
  Widget build(BuildContext context) {
    Color drawerBackgroundColor = Colors.white;

    return Scaffold(
      extendBody: true,
      // appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                color: Colors.black,
              ),
            ),
            // header
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Image.asset(
                  "assets/header_logo.png",
                ),
              ),
            ),
            // search icon
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/searchPage");
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),

      // body
      body: ZoomDrawer(
        style: DrawerStyle.defaultStyle,
        androidCloseOnBackTap: true,
        mainScreenTapClose: true,
        controller: _drawerController,
        menuBackgroundColor: drawerBackgroundColor,
        //borderRadius: 24.0,
        //showShadow: true,
        //angle: -0.0,
        //mainScreenScale: 0.2,
        shadowLayer1Color: Colors.grey.shade200,
        shadowLayer2Color: Colors.grey.shade400,
        // drawer ekrani
        menuScreen: Padding(
          padding: const EdgeInsets.only(right: 8.0),
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
                            "Popüler", Icons.person_outline_outlined),
                        drawerListItem(
                            "En Çok Oy Alanlar", Icons.star_border_outlined),
                        drawerListItem(
                            "Gelmekte Olanlar", Icons.hourglass_empty_outlined),
                        drawerListItem(
                            "Favoriler", Icons.favorite_border_outlined),
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
      ),

      // bottomnavbar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          // dış kutu borderradius
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: GNav(
              tabBorderRadius: borderRadius,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,

              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              color: Colors.black,
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
      ),
    );
  }

  Widget drawerListItem(String text, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
        ),
        //tileColor: backgroundColor,
        minLeadingWidth: 20,
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        onTap: () {},
        title: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/cache/hive/hive_abstract.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/locator.dart';
import 'package:movie_app/models/detail_movie.dart';
import 'package:movie_app/models/detail_tv.dart';
import 'package:movie_app/widgets/card/favori_card.dart';
import 'package:movie_app/widgets/packages/masonry_grid.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late HiveAbstract<DetailMovie> _hiveMovie;
  late HiveAbstract<TvDetail> _hiveTv;
  late List<DetailMovie> _allMovie;
  late List<TvDetail> _allTv;
  final int _crossAxisCount = 2;

  @override
  void initState() {
    _hiveMovie = locator<HiveAbstract<DetailMovie>>();
    _hiveTv = locator<HiveAbstract<TvDetail>>();
    _allMovie = <DetailMovie>[];
    _allTv = <TvDetail>[];
    _getItems();
    _tabController = TabController(length: TabItem.values.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TabItem.values.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Style.transparentColor,
          toolbarHeight: 0,
          elevation: Style.defaultElevation / 2,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: _myTabBar().preferredSize,
            child: Material(
              elevation: Style.defaultElevation,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Theme(
                data: ThemeData().copyWith(
                  splashColor: Style.primaryColor,
                ),
                child: _myTabBar(),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: Style.pagePadding,
          child:  _tabBarView(),
        ),
      ),
    );
  }

  TabBar _myTabBar() {
    return TabBar(
      indicatorColor: Style.primaryColor,
      labelColor: Theme.of(context).iconTheme.color,
      padding: EdgeInsets.zero,
      onTap: (value) {},
      controller: _tabController,
      tabs: TabItem.values
          .map(
            (e) => Tab(
              text: e.name.tr(),
            ),
          )
          .toList(),
    );
  }

  TabBarView _tabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
           _allMovie.length==0 ? Text('veri yok') :   MasonryGrid(
                crossAxisCount: _crossAxisCount,
                length: _allMovie.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      FavoriCard(
                        title: _allMovie[index].title,
                        date: _allMovie[index].releaseDate.toString(),
                        vote: _allMovie[index].voteAverage.toString(),
                        id: _allMovie[index].id,
                        path: _allMovie[index].posterPath,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _deleteButton(
                          index,
                          () async {
                            await _hiveMovie.delete(detail: _allMovie[index]);
                            debugPrint('silindi -> ${_allMovie[index].title.toString()}');
                            _allMovie.removeAt(index);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: Style.defaultPaddingSize * 13),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
             _allTv.length==0 ? Text('veri yok') :   MasonryGrid(
                crossAxisCount: _crossAxisCount,
                length: _allTv.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      FavoriCard(
                        title: _allTv[index].name,
                        date: _allTv[index].firstAirDate.toString(),
                        vote: _allTv[index].voteAverage.toString(),
                        id: _allTv[index].id,
                        path: _allTv[index].posterPath,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _deleteButton(
                          index,
                          () async {
                            await _hiveTv.delete(detail: _allTv[index]);
                            debugPrint('silindi -> ${_allTv[index].name.toString()}');
                            _allTv.removeAt(index);

                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: Style.defaultPaddingSize * 13),
            ],
          ),
        ),
      ],
    );
  }

  Widget _deleteButton(int index, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Style.defaultPaddingSize / 4),
        decoration: BoxDecoration(
          color: Style.whiteColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Style.primaryColor.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.delete_forever,
          color: Style.primaryColor,
          size: Style.defaultIconsSize * 1.4,
        ),
      ),
    );
  }

  Future<void> _getItems() async {
    _allMovie = await _hiveMovie.getAll();
    _allTv = await _hiveTv.getAll();
    setState(() {});
  }
}

enum TabItem {
  movie,
  tv_series,
}

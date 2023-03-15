import 'package:flutter/material.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/data/tv_api_client.dart';
import 'package:movie_app/widgets/create_poster_list.dart';

class TVPage extends StatefulWidget {
  const TVPage({super.key});

  @override
  State<TVPage> createState() => _TVPageState();
}

class _TVPageState extends State<TVPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: Style.pagePadding,
        child: Column(
          children: [
            CreatePosterList(
              listName: "Haftanın Trend Dizileri",
              width: width,
              futureGetDataFunc: MovieApiClient().trendData("tv"),
            ),
            CreatePosterList(
              listName: "En Çok Oy Alan Diziler",
              width: width,
              futureGetDataFunc: TvApiClient().topRatedTvData(),
            ),
            CreatePosterList(
              listName: "Popüler Diziler",
              width: width,
              futureGetDataFunc: TvApiClient().popularTvData(),
            ),
            CreatePosterList(
              listName: "Yayında Olan Diziler",
              width: width,
              futureGetDataFunc: TvApiClient().onTheAirTvData(),
            ),
            const SizedBox(height: 200),
          ],
        ),
      )),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _textEditingController;
  String searchValue = '';

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        // The search area here
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade800,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: TextField(
              controller: _textEditingController,
              onChanged: (value) => setState(() => searchValue = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red.shade700,
                  ),
                  onPressed: () => setState(() {
                    _textEditingController.text = "";
                  }),
                ),
                hintText: 'Ara...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),

      /*
      EasySearchBar(
        searchHintText: "Ara",
        elevation: 0,                                                                                             
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            "assets/header_logo.png",
          ),
        ),
        onSearch: (value) => setState(() => searchValue = value),
      ),    Zdffvfgv                                       
      */
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
              future: ApiClient()
                  .search(query: searchValue.isNotEmpty ? searchValue : "a"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  var data = snapshot.data as Search;

                  return Expanded(
                    child: MasonryGridView.count(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.results.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        if (data.results[index].backdropPath?.isEmpty ??
                            null == null) {
                          return const SizedBox();
                        }

                        return GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            Navigator.of(context).pushNamed(
                              "/detailPage",
                              arguments: data.results[index].id,
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // resim
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Hero(
                                      tag:
                                          "https://image.tmdb.org/t/p/w500${data.results[index].posterPath.toString()}",
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://image.tmdb.org/t/p/w500${data.results[index].posterPath.toString()}",
                                        width: 50,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // isim, tarih, derecelendirme, kategoriler
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // film ismi
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.results[index].title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Text(
                                                toRevolveDate(data
                                                    .results[index].releaseDate
                                                    .toString()),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // rating
                                        RatingBar.builder(
                                          ignoreGestures: true,
                                          itemSize: 20,
                                          glowColor: Colors.yellow,
                                          unratedColor: Colors.black,
                                          initialRating:
                                              data.results[index].voteAverage /
                                                  2,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                          onRatingUpdate: (double value) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    /* child: ListView.builder(
                      clipBehavior: Clip.antiAlias,
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      itemCount: data.results.length,
                      
                    ), */
                  );
                } else {
                  return const Center(
                    child: LinearProgressIndicator(
                      color: Colors.grey,
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

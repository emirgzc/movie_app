import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
      appBar: AppBar(
        // The search area here
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade800,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              controller: _textEditingController,
              onChanged: (value) => setState(() => searchValue = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
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
      ),
      */
      body: Column(
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
                  child: ListView.builder(
                    clipBehavior: Clip.antiAlias,
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemCount: data.results.length,
                    itemBuilder: (context, index) {
                      if (data.results[index].backdropPath?.isEmpty ??
                          null == null) {
                        return const SizedBox();
                      }

                      return GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // resim
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Hero(
                                  tag:
                                      "https://image.tmdb.org/t/p/w500${data.results[index].posterPath.toString()}",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/w500${data.results[index].posterPath.toString()}",
                                      height: 50 * 1.5,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),

                              // isim, tarih, derecelendirme, kategoriler
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // film ismi
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 2),
                                          child: Text(
                                            data.results[index].title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 12),
                                          child: Text(
                                            data.results[index].releaseDate
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // rating
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: RatingBar.builder(
                                        ignoreGestures: true,
                                        itemSize: 20,
                                        glowColor: Colors.yellow,
                                        unratedColor: Colors.black,
                                        initialRating:
                                            data.results[index].voteAverage /
                                                2.0,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        onRatingUpdate: (double value) {},
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 8,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
    );
  }
}

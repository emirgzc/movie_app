import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
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
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey.shade800,
        title: SizedBox(
          width: double.infinity,
          height: 160.h,
          child: Center(
            child: TextField(
              autofocus: true,
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
                hintText: 'Aramak için yazınız...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: Style.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
              future: MovieApiClient().search(query: searchValue.isNotEmpty ? searchValue : "a"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                  var data = snapshot.data as Search;

                  return Expanded(
                    child: MasonryGridView.count(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.results?.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        if ((data.results?[index].profilePath?.isEmpty == null) && data.results?[index].posterPath?.isEmpty == null) {
                          return const SizedBox();
                        }

                        return searcItemCard(context, data, index, data.results?[index].mediaType);
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
      ),
    );
  }

  Widget searcItemCard(BuildContext context, Search data, int index, String? mediaType) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        Navigator.of(context).pushNamed(
          mediaType == 'movie' ? "/movieDetailPage" : (mediaType == 'tv' ? "/tvDetailPage" : "/castPersonsMoviesPage"),
          arguments: mediaType == 'person'
              ? [
                  data.results?[index].id,
                  data.results?[index].name,
                ]
              : data.results?[index].id,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: Style.defaultElevation,
        child: Padding(
          padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // resim
              image(data, index, mediaType),

              // isim, tarih, derecelendirme, kategoriler
              titleDateStar(data, index, mediaType),
            ],
          ),
        ),
      ),
    );
  }

  Widget image(Search data, int index, String? mediaType) {
    return Padding(
      padding: EdgeInsets.only(
        right: Style.defaultPaddingSizeHorizontal / 2,
      ),
      child: Hero(
        tag:
            'https://image.tmdb.org/t/p/w500${(mediaType == 'movie' || mediaType == 'tv') ? (data.results?[index].posterPath) : data.results?[index].profilePath}',
        child: CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${(mediaType == 'movie' || mediaType == 'tv') ? (data.results?[index].posterPath) : data.results?[index].profilePath}',
          width: 130.w,
          height: 250.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget titleDateStar(Search data, int index, String? mediaType) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // film ismi
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mediaType == 'movie' ? (data.results?[index].title ?? '-') : (data.results?[index].name ?? '-'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              (mediaType == 'person')
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 2),
                      child: Text(
                        toRevolveDate(checkDateType(mediaType, data.results?[index]) ?? DateTime.now().toString()),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSizeVertical / 2),
                child: Text(checkMediaType(data.results?[index].mediaType) ?? '-'),
              ),
            ],
          ),

          // rating
          (mediaType == 'person')
              ? const SizedBox()
              : RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: 48.r,
                  glowColor: Style.starColor,
                  unratedColor: Colors.black,
                  initialRating: (data.results?[index].voteAverage ?? 0.0) / 2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Style.starColor,
                  ),
                  onRatingUpdate: (double value) {},
                ),
        ],
      ),
    );
  }

  String? checkMediaType(String? mediaType) {
    if (mediaType == 'movie') {
      return 'Film';
    } else if (mediaType == 'tv') {
      return 'Dizi';
    } else if (mediaType == 'person') {
      return 'Oyuncu';
    } else {
      return null;
    }
  }

  String? checkDateType(String? mediaType, SearchResult? result) {
    if (result != null) {
      if (mediaType == 'movie') {
        return result.releaseDate.toString();
      } else if (mediaType == 'tv') {
        return result.firstAirDate.toString();
      } else {
        return DateTime.now().toString();
      }
    } else {
      return DateTime.now().toString();
    }
  }
}

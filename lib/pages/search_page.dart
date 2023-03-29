import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/models/search.dart';
import 'package:movie_app/widgets/person/person_detail_dialog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _textEditingController;
  late final ScrollController _scrollController;
  String searchValue = '';

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();

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
                    child: MasonryGridView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.results?.length,
                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
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

        if (mediaType == MediaType.person.name) {
          showPersonDetail(data.results?[index]);
        } else {
          Navigator.of(context).pushNamed(
            mediaType == MediaType.movie.name ? "/movieDetailPage" : "/tvDetailPage",
            arguments: data.results?[index].id,
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: Style.defaultElevation,
        child: Padding(
          padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // resim
              image(data, index, mediaType),

              // isim, tarih, derecelendirme, kategoriler
              Text(
                mediaType == MediaType.movie.name ? (data.results?[index].title ?? '-') : (data.results?[index].name ?? '-'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              (mediaType == MediaType.person.name)
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSizeVertical / 4),
                      child: Text(
                        toRevolveDate(checkDateType(mediaType, data.results?[index]) ?? DateTime.now().toString()),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ),
              (mediaType == MediaType.person.name)
                  ? const SizedBox()
                  : RatingBar.builder(
                      ignoreGestures: true,
                      itemSize: 36.r,
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
        ),
      ),
    );
  }

  Future showPersonDetail(SearchResult? data) {
    return showDialog(
      barrierColor: Style.blackColor.withOpacity(0.9),
      useSafeArea: true,
      context: context,
      builder: (context) {
        return PersonDetailDialog(data: data);
      },
    );
  }

  Widget image(Search data, int index, String? mediaType) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Style.defaultPaddingSizeHorizontal / 2,
      ),
      child: Hero(
        tag:
            'https://image.tmdb.org/t/p/w500${(mediaType == MediaType.movie.name || mediaType == MediaType.tv.name) ? (data.results?[index].posterPath) : data.results?[index].profilePath}',
        child: CachedNetworkImage(
          imageUrl:
              'https://image.tmdb.org/t/p/w500${(mediaType == MediaType.movie.name || mediaType == MediaType.tv.name) ? (data.results?[index].posterPath) : data.results?[index].profilePath}',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String? checkMediaType(String? mediaType) {
    if (mediaType == MediaType.movie.name) {
      return ConvertToMediaTypes.Film.name.toString();
    } else if (mediaType == MediaType.tv.name) {
      return ConvertToMediaTypes.Dizi.name.toString();
    } else if (mediaType == MediaType.person.name) {
      return ConvertToMediaTypes.Oyuncu.name.toString();
    } else {
      return null;
    }
  }

  String? checkDateType(String? mediaType, SearchResult? result) {
    if (result != null) {
      if (mediaType == MediaType.movie.name) {
        return result.releaseDate.toString();
      } else if (mediaType == MediaType.tv.name) {
        return result.firstAirDate.toString();
      } else {
        return DateTime.now().toString();
      }
    } else {
      return DateTime.now().toString();
    }
  }
}

// ignore: constant_identifier_names
enum ConvertToMediaTypes { Film, Dizi, Oyuncu }

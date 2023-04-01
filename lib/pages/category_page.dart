import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/movie_api_client.dart';
import 'package:movie_app/models/trend_movie.dart';
import 'package:movie_app/widgets/card/image_detail_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.genreId});
  final int? genreId;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int page = 1;
  late TextEditingController _textEditingController;
  late Future<List<Result>?> listDataFuture;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = page.toString();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Style.blackColor,
        title: Image.asset(
          "assets/logo/light-lg1.jpg",
          width: 300.w,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: Style.pagePadding,
        child: FutureBuilder(
          future:
              MovieApiClient().nowPlayingMovieData(context.locale, page: page),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              var data = snapshot.data as List<Result>;
              return ListView(
                children: [
                  MasonryGridView.count(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    crossAxisCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      if (data[index].genreIds?.contains(widget.genreId) ??
                          false) {
                        return ImageDetailCard(
                          title: data[index].title,
                          id: data[index].id ?? 0,
                          posterPath: data[index].posterPath ?? "",
                          voteAverageNumber: data[index].voteAverage ?? 0,
                          dateCard: data[index].releaseDate.toString() == "null"
                              ? data[index].firstAirDate.toString()
                              : data[index].releaseDate.toString(),
                          width: width,
                          name: data[index].name ?? "",
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  pageIndicator(),
                ],
              );
            } else {
              return buildLastProcessCardEffect(
                const SizedBox(
                  child: CircularProgressIndicator(),
                ),
                context,
              );
            }
          },
        ),
      ),
    );
  }

  Widget pageIndicator() {
    String arrowLeft = "Önceki Sayfa";
    String arrowRight = "Sonraki Sayfa";

    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical * 0.75,
        bottom: Style.defaultPaddingSizeHorizontal * 0.75,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // onceki sayfa
          Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: ElevatedButton(
              onPressed: () {
                if (page > 1) {
                  setState(() {
                    page--;
                    _textEditingController.text = page.toString();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 4),
                elevation: 0,
                shadowColor: Colors.red,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Style.blackColor,
                  ),
                  Text(
                    arrowLeft,
                    style: const TextStyle(
                      color: Style.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // page number
          Expanded(
            child: TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(
                  2,
                ),
              ],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                fillColor: Style.blackColor.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Style.defaultRadiusSize / 2),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {},
              onChanged: (value) {},
              onSubmitted: (value) {
                /*
                                  if (100 > int.parse(value) &&
                                      0 < int.parse(value)) {
                                    setState(() {
                                      page = int.parse(value);
                                    });
                                    */
              },
            ),
          ),
          // sonraki sayfa
          Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: ElevatedButton(
              onPressed: () {
                if (page < 101) {
                  setState(() {
                    page++;
                    _textEditingController.text = page.toString();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 4),
                elevation: 0,
                shadowColor: Colors.red,
              ),
              child: Row(
                children: [
                  Text(
                    arrowRight,
                    style: const TextStyle(color: Style.blackColor),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Style.blackColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

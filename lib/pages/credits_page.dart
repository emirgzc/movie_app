import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/credits.dart';

class CreditsPage extends StatelessWidget {
  CreditsPage({super.key});
  int movieId = 804150;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
      body: FutureBuilder(
        future: ApiClient().credits(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            var creditsData = snapshot.data as Credits;

            // profil resmi olmayanları kaldır
            creditsData.cast
                .removeWhere((element) => element.profilePath == null);

            return GridView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: creditsData.cast.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (.4 / 1.02),
              ),
              itemBuilder: (BuildContext context, int index) {
                // film kartları
                return GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 8,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://image.tmdb.org/t/p/w500${creditsData.cast[index].profilePath.toString()}",
                            height: width / 2.2 * 1.5,
                            width: width / 2.2,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

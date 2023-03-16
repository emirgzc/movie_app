import 'package:flutter/material.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/widgets/card/brochure_item.dart';

class CreatePosterList extends StatelessWidget {
  const CreatePosterList(
      {super.key,
      required this.listName,
      required this.width,
      required this.futureGetDataFunc});
  final String listName;
  final double width;
  final Future<List<dynamic>?> futureGetDataFunc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // liste adı
        Padding(
          padding:  EdgeInsets.only(bottom: Style.defaultPaddingSizeVertical / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listName,
                textScaleFactor: 1.2,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/listPage", arguments: listName);
                },
                icon: const Icon(Icons.arrow_forward),
              )
            ],
          ),
        ),
        // film afis resmi
        FutureBuilder(
          future: futureGetDataFunc,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              var data = snapshot.data as List<dynamic>;
              return SizedBox(
                width: double.infinity,
                height: (width / 3) * 1.5,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        (data[index].name == null)
                            ? "/movieDetailPage"
                            : "/tvDetailPage",
                        arguments: (data[index]?.id ?? 0),
                      ),
                      child: BrochureItem(
                        brochureUrl:
                            "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
                        width: width,
                      ),
                    );
                  },
                ),
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
      ],
    );
  }
}
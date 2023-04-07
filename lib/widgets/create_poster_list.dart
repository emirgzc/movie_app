import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/constants/util.dart';
import 'package:movie_app/widgets/card/brochure_item.dart';
import 'package:movie_app/widgets/text/big_text.dart';

class CreatePosterList extends StatelessWidget {
  const CreatePosterList({super.key, required this.listType, required this.listName, required this.width, required this.futureGetDataFunc});
  final ListType listType;
  final String listName;
  final double width;
  final Future<List<dynamic>?> futureGetDataFunc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // liste adı
        Padding(
          padding: EdgeInsets.only(bottom: Style.defaultPaddingSizeVertical / 2),
          child: titleHead(context),
        ),
        // film afis resmi
        listAllItem(),
      ],
    );
  }

  FutureBuilder<List<dynamic>?> listAllItem() {
    return FutureBuilder(
      future: futureGetDataFunc,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
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
                    (data[index].name == null) ? "/movieDetailPage" : "/tvDetailPage",
                    arguments: (data[index]?.id ?? 0),
                  ),
                  child: BrochureItem(
                    brochureUrl: "https://image.tmdb.org/t/p/w500${data[index]?.posterPath.toString()}",
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
    );
  }

  Widget titleHead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BigText(title: listName),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/listPage", arguments: listType);
          },
          icon: SvgPicture.asset(
            IconPath.arrow_right.iconPath(),
            height: Style.defaullIconHeight,
            color: context.iconThemeContext().color,
          ),
        )
      ],
    );
  }
}

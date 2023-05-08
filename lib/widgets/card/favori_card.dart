import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/constants/revolve_date.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/models/detail_movie.dart';

class FavoriCard extends StatelessWidget {
  const FavoriCard({super.key, required this.title, required this.date, required this.vote, required this.id, this.path});
  final int? id;
  final String? title;
  final String? date;
  final String? vote;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          "/movieDetailPage",
          arguments: id,
        );
      },
      child: Card(
        elevation: Style.defaultElevation,
        shadowColor: Theme.of(context).iconTheme.color,
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 30.sp,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Style.defaultPaddingSize / 2),
                        child: Text(
                          toRevolveDate(
                            (date?.split(" ")[0]??''),
                          ),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontSize: 26.sp,
                              ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: Style.defaultPaddingSize / 6),
                            child: SvgPicture.asset(
                              'assets/icons/star_fill.svg',
                              height: Style.defaultIconsSize * 0.8,
                              color: Style.starColor,
                            ),
                          ),
                          Text(
                            (vote).toString().substring(0, 3),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: CachedNetworkImage(
                    imageUrl: "https://image.tmdb.org/t/p/w500${path}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/models/to_watch.dart';

class WatchCard extends StatelessWidget {
  const WatchCard({super.key, required this.result, required this.width});
  final List<Flatrate> result;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Style.defaultPaddingSizeVertical / 2),
      child: SizedBox(
        height: 200.h,
        width: double.infinity,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: result.length,
          // ilk eleman olarak varsa
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 30.0,
                        sigmaY: 30.0,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Style.defaultPaddingSizeHorizontal * 3,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: "https://image.tmdb.org/t/p/w500${result[index].logoPath}",
                          fit: BoxFit.contain,
                          width: width,
                        ),
                      ),
                    ),
                  );
                },
              ),
              child: Container(
                margin: EdgeInsets.only(right: Style.defaultPaddingSize / 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Style.blackColor.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(
                    Style.defaultRadiusSize / 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                      spreadRadius: 4,
                      color: Theme.of(context).shadowColor,
                    ),
                  ],
                  color: Style.whiteColor,
                ),
                height: 200.h,
                width: 200.w,
                child: CachedNetworkImage(
                  imageUrl: "https://image.tmdb.org/t/p/w500${result[index].logoPath ?? ""}",
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

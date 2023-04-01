import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/style.dart';

class PublicImage extends StatelessWidget {
  const PublicImage(
      {super.key,
      required this.path,
      required this.width,
      required this.height});
  final String? path;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
                ),
                child: Material(
                  //elevation: 14,
                  color: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/w500${path.toString()}",
                    fit: BoxFit.contain,
                    width: width,
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Hero(
        tag: "https://image.tmdb.org/t/p/w500${path.toString()}",
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(Style.defaultRadiusSize / 3),
          ),
          child: SizedBox(
            width: width - 200,
            height: height * 0.4,
            child: CachedNetworkImage(
              imageUrl: "https://image.tmdb.org/t/p/w500${path.toString()}",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }
}

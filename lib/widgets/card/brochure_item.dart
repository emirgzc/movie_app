import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/style.dart';

class BrochureItem extends StatelessWidget {
  const BrochureItem(
      {super.key, required this.brochureUrl, required this.width});
  final String brochureUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Style.defaultPaddingSize / 2),
      child: Material(
        elevation: Style.defaultElevation,
        color: Style.transparentColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              Style.defaultRadiusSize / 2,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: brochureUrl,
            fit: BoxFit.cover,
            width: width / 3,
            height: (width / 3) * 1.5,
          ),
        ),
      ),
    );
  }
}

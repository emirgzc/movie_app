import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BlurryImage extends StatelessWidget {
  const BlurryImage({super.key, required this.path});
  final String? path;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: path != null
          ? CachedNetworkImage(
              imageUrl: "https://image.tmdb.org/t/p/w500${path.toString()}",
              fit: BoxFit.cover,
            )
          : const SizedBox(),
    );
  }
}

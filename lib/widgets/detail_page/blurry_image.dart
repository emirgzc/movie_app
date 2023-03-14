import 'package:flutter/material.dart';

class BlurryImage extends StatelessWidget {
  const BlurryImage({super.key, required this.path});
  final String? path;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: path != null
          ? Image.network(
              "https://image.tmdb.org/t/p/w500${path.toString()}",
              fit: BoxFit.cover,
            )
          : const SizedBox(),
    );
  }
}

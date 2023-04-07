import 'package:flutter/material.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';

class DescText extends StatelessWidget {
  const DescText({super.key, required this.description, this.color});
  final String description;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      overflow: TextOverflow.ellipsis,
      maxLines: 30,
      style: context.textThemeContext().bodySmall!.copyWith(
            height: 1.4,
            color: color ?? Style.whiteColor.withOpacity(0.8),
          ),
    );
  }
}

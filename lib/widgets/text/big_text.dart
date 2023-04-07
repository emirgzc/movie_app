import 'package:flutter/material.dart';
import 'package:movie_app/constants/extension.dart';

class BigText extends StatelessWidget {
  const BigText({super.key, required this.title, this.color});
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textThemeContext().titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? context.iconThemeContext().color,
          ),
    );
  }
}

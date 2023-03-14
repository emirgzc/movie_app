import 'package:flutter/material.dart';
import 'package:movie_app/constants/style.dart';

class ButtonForDetailMovie extends StatelessWidget {
  const ButtonForDetailMovie({
    super.key,
    required this.onPressed,
    required this.icondata,
    required this.width,
    required this.height,
  });
  final void Function()? onPressed;
  final IconData icondata;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Style.defaultPaddingSize / 2),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(Style.defaultRadiusSize),
        ),
        child: Container(
          width: (width - 90) / 6,
          height: (width - 90) / 6,
          color: Style.widgetBackgroundColor,
          child: MaterialButton(
            onPressed: onPressed,
            child: Icon(
              icondata,
              color: Style.whiteColor.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}

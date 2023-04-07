import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final String icondata;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal / 2),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(Style.defaultRadiusSize / 2),
        ),
        child: Container(
          width: (width) / 7.5,
          height: (width) / 7.5,
          color: Style.widgetBackgroundColor,
          child: MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            child: SvgPicture.asset(
              icondata,
              height: Style.defaullIconHeight * 0.9,
              // ignore: deprecated_member_use
              color: Style.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

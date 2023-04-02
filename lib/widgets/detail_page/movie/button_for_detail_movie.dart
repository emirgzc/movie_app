import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal / 2),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(Style.defaultRadiusSize / 2),
        ),
        child: Container(
          width: (width) / 7.4,
          height: (width) / 7.4,
          color: Style.widgetBackgroundColor,
          child: MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            child: Icon(
              icondata,
              color: Style.whiteColor.withOpacity(0.8),
              size: 64.r,
            ),
          ),
        ),
      ),
    );
  }
}

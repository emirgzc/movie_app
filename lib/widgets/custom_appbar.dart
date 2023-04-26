// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.title,
    required this.leading,
    required this.trailing,
    this.isCenter = true,
  }) : super(key: key);
  final Widget title;
  final Widget? leading;
  final List<Widget>? trailing;
  bool isCenter;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      actions: trailing,
      centerTitle: isCenter,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget appBarButton(void Function()? onPressed, String iconPath, BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        iconPath,
        height: Style.defaullIconHeight,
        color: context.iconThemeContext().color,
      ),
    );
  }
}

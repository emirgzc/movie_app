import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/style.dart';

enum UiType {
  positive,
  negative,
  info,
  warning,
}

extension UiTypeExtension on UiType {
  String iconPath() {
    switch (this) {
      case UiType.positive:
        return AssetsPath.success;
      case UiType.negative:
        return AssetsPath.failure;
      case UiType.info:
        return AssetsPath.help;
      case UiType.warning:
        return AssetsPath.warning;
    }
  }

  Color getColor() {
    switch (this) {
      case UiType.positive:
        return DefaultColors.successGreen;
      case UiType.negative:
        return DefaultColors.failureRed;
      case UiType.info:
        return DefaultColors.helpBlue;
      case UiType.warning:
        return DefaultColors.warningYellow;
    }
  }

  Color getIconColor() {
    switch (this) {
      case UiType.positive:
        return const Color.fromARGB(255, 16, 75, 48);
      case UiType.negative:
        return const Color.fromARGB(255, 113, 32, 42);
      case UiType.info:
        return const Color.fromARGB(255, 19, 74, 110);
      case UiType.warning:
        return const Color.fromARGB(255, 177, 113, 50);
    }
  }
}

class Uihelper {
  static showSnackBarDialogForInfo({
    required BuildContext context,
    required UiType type,
    required String title,
    required String message,
    bool useDialog = false,
    int maxLines = 2,
  }) {
    Widget bodyCard = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 3),
          height: 230.h /* + (maxLines * 40.h) */,
          decoration: BoxDecoration(
            color: type.getColor(),
            borderRadius: BorderRadius.circular(Style.defaultRadiusSize),
          ),
          child: Row(
            children: [
              SizedBox(width: 140.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 43.sp,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 33.sp,
                        height: 1.3,
                        color: Colors.white,
                      ),
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Style.defaultRadiusSize),
            ),
            child: SvgPicture.asset(
              'assets/info/bubbles.svg',
              height: 140.h,
              width: 120.w,
              color: type.getIconColor(),
            ),
          ),
        ),
        Positioned(
          top: -38.h,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/info/back.svg',
                height: 110.h,
                color: type.getColor(),
              ),
              Positioned(
                top: 28.h,
                child: SvgPicture.asset(
                  type.iconPath(),
                  height: 40.h,
                  color: Style.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (useDialog) {
      showDialog(
        context: context,
        useSafeArea: true,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Dialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: bodyCard,
          );
        },
      ).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          Navigator.maybePop(context);
        },
      );
    } else {
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) {
        log('"ScaffoldMessenger.maybeOf(context)" is null. UIType is "$type", content is "$message"', name: 'UIHelper-showSnackBar');
        return;
      }
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          elevation: 0,
          content: bodyCard,
        ),
      );
    }
  }
}

class AssetsPath {
  static const String help = 'assets/info/help.svg';
  static const String failure = 'assets/info/failure.svg';
  static const String success = 'assets/info/success.svg';
  static const String warning = 'assets/info/warning.svg';

  static const String back = 'assets/info/back.svg';
  static const String bubbles = 'assets/info/bubbles.svg';
}

class DefaultColors {
  /// help
  static const Color helpBlue = Color(0xff3282B8);
  /// failure
  static const Color failureRed = Color(0xffc72c41);
  /// success
  static const Color successGreen = Color(0xff2D6A4F);
  /// warning
  static const Color warningYellow = Color(0xffFCA652);
}

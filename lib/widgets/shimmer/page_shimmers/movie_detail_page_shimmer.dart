import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
import 'package:movie_app/widgets/shimmer/shimmers.dart';
import 'package:movie_app/widgets/text/big_text.dart';

class MovieDetailPageShimmers {
  Widget movieDetailPageShimmer(double height, double width) {
    return Container(
      color: Colors.grey.shade100,
      padding: Style.pagePadding,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appbar(),

              // film resmi
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Style.defaultRadiusSize / 3),
                  ),
                  child: SizedBox(
                    width: width * 0.56,
                    height: width * 1.5 * 0.56,
                    child: Shimmers.customProgressIndicatorBuilder(),
                  ),
                ),
              ),

              // acıklama ve detaylar
              Padding(
                padding: EdgeInsets.only(
                  top: Style.defaultPaddingSizeVertical / 1.25,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Style.defaultRadiusSize / 2),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 500.h,
                    child: Shimmers.customProgressIndicatorBuilder(),
                  ),
                ),
              ),

              // butonlar
              Padding(
                padding: EdgeInsets.only(
                  top: Style.defaultPaddingSizeVertical * 0.75,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: (width) / 7.5,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      _button(IconPath.play.iconPath(), width, height),
                      _button(IconPath.file.iconPath(), width, height),
                      _button(IconPath.info.iconPath(), width, height),
                      _button(IconPath.users.iconPath(), width, height),
                      _button(IconPath.comment.iconPath(), width, height),
                      _button(IconPath.share.iconPath(), width, height),
                    ],
                  ),
                ),
              ),

              // ekran goruntuleri text
              Padding(
                padding: EdgeInsets.only(
                  top: Style.defaultPaddingSizeVertical,
                  bottom: Style.defaultPaddingSizeVertical / 2,
                ),
                child: Row(
                  children: [
                    BigText(
                      title: LocaleKeys.screenshots.tr(),
                      color: Style.whiteColor,
                    ),
                  ],
                ),
              ),

              // ekran goruntuleri
              _screenshots(width),

              SizedBox(height: 500.h),
            ],
          ),
        ),
      ),
    );
  }

  Padding _screenshots(double width) {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical / 2,
      ),
      child: SizedBox(
        width: double.infinity,
        // dogru oranin yakalanmasi icin
        // 281 / 500 : resim cozunurlugu
        height: (width / 2) * (281 / 500),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(
                right: Style.defaultPaddingSizeHorizontal * 0.75,
              ),
              child: Material(
                //elevation: 14,
                color: Style.transparentColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Style.defaultRadiusSize / 2),
                  ),
                  child: SizedBox(
                    width: width / 2,
                    // 281 / 500 : resim cozunurlugu
                    height: (width / 2) * (281 / 500),
                    child: Shimmers.customProgressIndicatorBuilder(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding _appbar() {
    return Padding(
      padding: EdgeInsets.only(
        top: Style.defaultPaddingSizeVertical * 2.5,
        bottom: Style.defaultPaddingSizeVertical * 1.25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // geri
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
              color: Style.widgetBackgroundColor,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: SvgPicture.asset(
              IconPath.arrow_left.iconPath(),
              height: Style.defaullIconHeight,
              // ignore: deprecated_member_use
              color: Style.whiteColor,
            ),
          ),

          // logo
          Image.asset(
            LogoPath.light_lg1_removebg.iconPath(),
            width: 290.w,
            fit: BoxFit.contain,
          ),

          // kalp
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Style.defaultRadiusSize / 2),
              color: Style.widgetBackgroundColor,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: SvgPicture.asset(
              IconPath.favorite.iconPath(),
              height: Style.defaullIconHeight,
              // ignore: deprecated_member_use
              color: Style.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(
    String icondata,
    double width,
    double height,
  ) {
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
            onPressed: () {},
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

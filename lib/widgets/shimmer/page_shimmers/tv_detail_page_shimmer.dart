
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/widgets/shimmer/shimmers.dart';

class TvDetailPageShimmer {
  Widget tvDetailPageShimmer(
      double height, double width, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // image and buttons
          Stack(
            children: [
              _textShimmer(height * 0.58, width),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
                  child: _rectangleBox(180.w, context),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: _circleButton(IconPath.arrow_left.iconPath(), context),
              ),
              Positioned(
                left: 180.w,
                bottom: 0,
                child: _circleButton(IconPath.play.iconPath(), context),
              ),
              Positioned(
                left: 360.w,
                bottom: 0,
                child: _circleButton(IconPath.favorite.iconPath(), context),
              ),
            ],
          ),

          Container(
            padding: Style.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ustteki paylas butonu kısmı
                Row(
                  children: [
                    _rectangleBox(180.w, context),
                    _rectangleBox(140.w, context),
                    _rectangleBox(60.w, context),
                    const Spacer(),
                    SvgPicture.asset(
                      IconPath.share.iconPath(),
                      height: Style.defaullIconHeight * 0.8,
                      color: Style.blackColor,
                    ),
                  ],
                ),

                // dizi ismi olan kısım
                Padding(
                  padding: EdgeInsets.only(
                    top: (Style.defaultPaddingSizeVertical / 2) * 3,
                    bottom: Style.defaultPaddingSizeVertical / 2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Style.defaultRadiusSize / 4,
                    ),
                    // 260w 48h
                    child: _textShimmer(48.h, 260.w),
                  ),
                ),
                SizedBox(
                  height: Style.defaultPaddingSize,
                ),
                _detailText(800.w),
                _detailText(700.w),
                _detailText(750.w),
                _detailText(600.w),

                // ulke, yayın tarihi
                Padding(
                  padding: EdgeInsets.only(
                    top: Style.defaultPaddingSizeVertical,
                    bottom: Style.defaultPaddingSizeVertical / 2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Style.defaultRadiusSize / 4,
                    ),
                    child: _textShimmer(40.h, 300.w),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Style.defaultPaddingSizeVertical / 4,
                    bottom: Style.defaultPaddingSizeVertical / 2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Style.defaultRadiusSize / 4,
                    ),
                    child: _textShimmer(40.h, 400.w),
                  ),
                ),

                // oyuncular text
                Padding(
                  padding: EdgeInsets.only(
                    top: (Style.defaultPaddingSizeVertical / 1.3),
                    bottom: Style.defaultPaddingSizeVertical,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Style.defaultRadiusSize / 4,
                    ),
                    // 260w 48h
                    child: _textShimmer(48.h, 260.w),
                  ),
                ),

                // oyuncu resimleri
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _playerCard(),
                      _playerCard(),
                      _playerCard(),
                      _playerCard(),
                      _playerCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _playerCard() {
    return SizedBox(
      width: 230.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: Style.defaultPaddingSizeVertical / 2,
              right: Style.defaultPaddingSizeHorizontal / 2,
            ),
            height: 250.h,
            width: 230.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                Style.defaultRadiusSize / 4,
              ),
              child: Material(
                elevation: Style.defaultElevation,
                child: Shimmers().customProgressIndicatorBuilder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _detailText(double width) {
    return Padding(
      padding: EdgeInsets.only(bottom: Style.defaultPaddingSize / 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          Style.defaultRadiusSize / 4,
        ),
        child: _textShimmer(26.h, width),
      ),
    );
  }

  SizedBox _textShimmer(double height, double width) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmers().customProgressIndicatorBuilder(),
    );
  }

  Widget _rectangleBox(double width, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Style.defaultPaddingSize / 2),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Style.defaultPaddingSizeVertical / 4,
          horizontal: Style.defaultPaddingSizeHorizontal / 3,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: context.iconThemeContext().color!.withOpacity(0.15),
          ),
          color: context.publicThemeContext().scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(
            Style.defaultRadiusSize / 4,
          ),
        ),
        child: SizedBox(
          height: 42.h,
          width: width,
          child: Shimmers().customProgressIndicatorBuilder(),
        ),
      ),
    );
  }

  Container _circleButton(String iconPath, BuildContext context) {
    return Container(
      padding: EdgeInsets.all((Style.defaultPaddingSize / 4) * 3),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(5, 5),
            blurRadius: 10,
            color: context.publicThemeContext().shadowColor,
          ),
        ],
        shape: BoxShape.circle,
        color: context.publicThemeContext().scaffoldBackgroundColor,
        border: Border.all(
          width: 1,
          color: context.iconThemeContext().color!.withOpacity(0.15),
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Style.defaultPaddingSizeHorizontal / 1.5,
        vertical: Style.defaultPaddingSizeVertical / 1.5,
      ),
      child: Center(
        child: SvgPicture.asset(
          iconPath,
          height: Style.defaullIconHeight * 0.8,
          color: context.iconThemeContext().color,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/constants/enums.dart';
import 'package:movie_app/constants/extension.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/widgets/packages/masonry_grid.dart';
import 'package:movie_app/widgets/shimmer/shimmers.dart';

class ListPageShimmer {
  Widget listPageShimmer(double width, BuildContext context) {
    return Padding(
      padding: Style.pagePadding,
      child: MasonryGrid(
        length: 6,
        itemBuilder: (BuildContext context, int index) {
          return movieCard(context, width);
        },
      ),
    );
  }

  Card movieCard(BuildContext context, double width) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: Style.defaultPaddingSize.h,
        horizontal: Style.defaultPaddingSize.w,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: Style.defaultRadius,
      ),
      elevation: Style.defaultElevation,
      shadowColor: context.publicThemeContext().shadowColor.withOpacity(0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // resim
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                Style.defaultRadiusSize / 2,
              ),
              topRight: Radius.circular(
                Style.defaultRadiusSize / 2,
              ),
            ),
            child: SizedBox(
              height: width / 1.8,
              width: width / 2.2,
              child: Shimmers().customProgressIndicatorBuilder(),
            ),
          ),

          // isim ve tarih
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: Style.defaultSymetricPadding / 3,
                child: Center(
                  child: _textShimmer(60.h, 256.w),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: Style.defaultPaddingSizeVertical / 3,
                ),
                child: _textShimmer(20.h, 300.w),
              ),
            ],
          ),

          // divider
          const Divider(
            thickness: 1,
          ),

          Padding(
            padding: EdgeInsets.only(bottom: Style.defaultPaddingSize.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  IconPath.star_fill.iconPath(),
                  height: Style.defaullIconHeight * 0.6,
                  // ignore: deprecated_member_use
                  color: Style.starColor,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: Style.defaultPaddingSizeHorizontal / 6),
                  child: _textShimmer(40.h, 180.w),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textShimmer(double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        Style.defaultRadiusSize / 4,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Shimmers().customProgressIndicatorBuilder(),
      ),
    );
  }
}

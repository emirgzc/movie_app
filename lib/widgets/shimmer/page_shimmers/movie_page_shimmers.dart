import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/widgets/shimmer/shimmers.dart';

class MoviePageShimmers {
  Widget topSliderShimmer() {
    return CarouselSlider(
      items: [
        Container(
          margin: EdgeInsets.all(Style.defaultPaddingSize / 4),
          padding: EdgeInsets.fromLTRB(0, Style.defaultPaddingSizeVertical / 2,
              0, Style.defaultPaddingSizeVertical),
          child: Material(
            elevation: Style.defaultElevation,
            color: Style.transparentColor,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Style.defaultRadiusSize / 2,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 1000,
                    child: Shimmers().customProgressIndicatorBuilder(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 1.9,
        enlargeCenterPage: true,
      ),
    );
  }

  Widget categoriesShimmer(double height, double width) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ListView.builder(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(Style.defaultPaddingSize / 2),
            child: Material(
              elevation: Style.defaultElevation,
              color: Style.transparentColor,
              shadowColor: Style.blackColor,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Style.defaultRadiusSize / 2,
                  ),
                ),
                child: Container(
                  width: width,
                  height: height,
                  child: Shimmers().customProgressIndicatorBuilder(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget posterListShimmer(double height, double width) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ListView.builder(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(right: Style.defaultPaddingSizeHorizontal),
            child: Material(
              elevation: Style.defaultElevation,
              color: Style.transparentColor,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    Style.defaultRadiusSize / 4,
                  ),
                ),
                child: Container(
                  width: width / 3,
                  height: (width / 3) * 1.5,
                  child: Shimmers().customProgressIndicatorBuilder(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

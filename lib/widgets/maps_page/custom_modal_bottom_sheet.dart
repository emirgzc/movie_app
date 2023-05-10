import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/data/api_client.dart';
import 'package:movie_app/models/place_details.dart';
import 'package:movie_app/widgets/text/big_text.dart';
import 'package:movie_app/widgets/text/desc_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    super.key,
    required this.placeName,
    required this.vicinity,
    required this.rating,
    required this.photoReference,
    required this.placeId,
    required this.lat,
    required this.lng,
  });

  final String placeName;
  final String vicinity;
  final double rating;
  final String photoReference;
  final String placeId;
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(100.w, 0, 24, 100.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Style.defaultRadiusSize),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Style.defaultPaddingSizeHorizontal,
          0,
          Style.defaultPaddingSizeHorizontal,
          0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top divider
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                width: 100.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // infos
            BigText(
              title: placeName,
              color: Theme.of(context).iconTheme.color,
            ),

            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DescText(
                    description: rating.toString(),
                    color: Colors.grey.shade400,
                  ),
                  // stars
                  Flexible(
                    child: RatingBar(
                      ignoreGestures: true,
                      itemCount: 5,
                      itemSize: 80.w,
                      itemPadding: Style.defaultVerticalPadding / 4,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: Colors.yellow,
                        ),
                        empty: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ),
                      initialRating: rating,
                      allowHalfRating: true,
                      onRatingUpdate: (value) {},
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: DescText(
                description: vicinity,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // image slider
            FutureBuilder(
              future: ApiClient().getPlaceDetails(placeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
                  PlaceDetails placeDetails = snapshot.data as PlaceDetails;
                  List<String> placePhotoUrls = [];
                  if (placeDetails.result != null && placeDetails.result!.photos != null) {
                    for (var element in placeDetails.result!.photos!) {
                      placePhotoUrls.add(
                          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=800&photo_reference=${element.photoReference}&key=${ApiClient().googleApiKey}");
                    }
                  }

                  return placePhotoUrls.isNotEmpty
                      ? CarouselSlider.builder(
                          itemCount: placePhotoUrls.length,
                          itemBuilder: (context, index, realIndex) {
                            return ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(Style.defaultRadiusSize / 3),
                              ),
                              child: SizedBox(
                                width: 1000.w,
                                height: 300.h,
                                child: Image.network(
                                  placePhotoUrls[index],
                                  fit: BoxFit.fill,
                                  width: 372,
                                  height: 124,
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            aspectRatio: 2,
                            enlargeCenterPage: true,
                          ),
                        )
                      : DescText(
                          description: "Resim Bulunamadı",
                          color: Colors.grey.shade400,
                        );
                } else {
                  return CarouselSlider(
                    items: [
                      SizedBox(
                        width: 1000.w,
                        height: 300.h,
                      ),
                    ],
                    options: CarouselOptions(
                      aspectRatio: 2,
                      enlargeCenterPage: true,
                    ),
                  );
                }
              },
            ),

            // buttons
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                Style.defaultPaddingSize,
                0,
                Style.defaultPaddingSize,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _modalBottomSheetButton(
                    Icons.rotate_90_degrees_ccw,
                    "Yol Tarifi",
                    () {
                      _launchMapsUrl(lat, lng);
                    },
                  ),
                  _modalBottomSheetButton(Icons.ads_click_outlined, "Adresi Kopyala", () {})
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modalBottomSheetButton(
    IconData icon,
    String text,
    Function onPressedFunction,
  ) {
    return MaterialButton(
      color: Style.primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Style.defaultRadiusSize),
      ),
      onPressed: () {
        onPressedFunction();
      },
      child: Row(
        children: [
          Icon(
            icon,
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }

  void _launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}

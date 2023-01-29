import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagePage extends StatefulWidget {
  const ImagePage(
      {required this.imageUrls, required this.clickedIndex, super.key});
  final List<String> imageUrls;
  final int clickedIndex;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late PageController _pageController;
  int _current = 0;
  late PhotoViewController _photoViewController;
  late PhotoViewScaleStateController _photoViewScaleStateController;

  @override
  void initState() {
    _current = widget.clickedIndex;
    _pageController = PageController(initialPage: _current);
    _photoViewController = PhotoViewController();
    _photoViewScaleStateController = PhotoViewScaleStateController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                controller: _photoViewController,
                // maxScale: PhotoViewComputedScale.covered,
                minScale: PhotoViewComputedScale.contained,
                scaleStateController: _photoViewScaleStateController,
                onScaleEnd: (context, details, controllerValue) {
                  // if user zoomed out on initial position, go back
                  if (_photoViewScaleStateController.prevScaleState ==
                          PhotoViewScaleState.initial &&
                      _photoViewScaleStateController.scaleState ==
                          PhotoViewScaleState.zoomedOut) {
                    Navigator.of(context).pop(_current);
                  }
                },
                initialScale: PhotoViewComputedScale.contained,
                imageProvider: CachedNetworkImageProvider(
                    "https://image.tmdb.org/t/p/w500${widget.imageUrls[index]}"),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
              );
            },
            itemCount: widget.imageUrls.length,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),

          // back button
          Positioned(
            top: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(_current);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

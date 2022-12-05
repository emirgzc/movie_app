import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});
  final double myRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double categoryItemWidht = widht / 2.4;

    List<Widget> categoriesItemList = [
      createCategoriesItem(
          "assets/black_adam_backdrop.jpg", "DISCOVER", categoryItemWidht),
      createCategoriesItem(
          "assets/black_adam_backdrop.jpg", "HORROR", categoryItemWidht),
      createCategoriesItem("assets/black_adam_backdrop.jpg", "SCIENCE FICTION",
          categoryItemWidht),
    ];

    List<Widget> brochureItemList = [
      createBrochureItem("assets/black_adam_brochure.jpg", widht),
      createBrochureItem("assets/black_adam_brochure.jpg", widht),
      createBrochureItem("assets/black_adam_brochure.jpg", widht),
      createBrochureItem("assets/black_adam_brochure.jpg", widht),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // menu icon
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            // header
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Image.asset(
                  "assets/header_logo.png",
                ),
              ),
            ),
            // search icon
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top trend movies slider
              CarouselSlider(
                items: [
                  createTopSliderItem(
                      "assets/black_adam_backdrop.jpg", "Black Adam 1"),
                  createTopSliderItem(
                      "assets/black_adam_backdrop.jpg", "Black Adam 2"),
                  createTopSliderItem(
                      "assets/black_adam_backdrop.jpg", "Black Adam 3")
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1.9,
                  enlargeCenterPage: true,
                ),
              ),

              // categories part, red boxes
              Container(
                width: double.infinity,
                height: categoryItemWidht / 2.2,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesItemList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      categoriesItemList[index],
                ),
              ),

              // custom lists, My List
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My List",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: (widht / 3) * 1.5,
                      child: ListView.builder(
                        clipBehavior: Clip.none,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: brochureItemList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            brochureItemList[index],
                      ),
                    ),
                  ],
                ),
              ),

              // custom lists, Tends
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Trends",
                          textScaleFactor: 1.2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: (widht / 3) * 1.5,
                      child: ListView.builder(
                        clipBehavior: Clip.none,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: brochureItemList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            brochureItemList[index],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createBrochureItem(String brochureUrl, double widht) {
    return GestureDetector(
      onTap: () {
        print(brochureUrl);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Material(
          elevation: 14,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(myRadius)),
            child: // image.network
                Image.asset(
              brochureUrl,
              fit: BoxFit.cover,
              width: widht / 3,
              height: (widht / 3) * 1.5,
            ),
          ),
        ),
      ),
    );
  }

  createCategoriesItem(
      String backgroudImageUrl, String text, double categoryItemWidht) {
    return GestureDetector(
      onTap: () {
        print("$backgroudImageUrl , $text");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 12,
          color: Colors.transparent,
          shadowColor: Colors.red,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(myRadius)),
            child: Stack(
              children: [
                // image.network
                Image.asset(
                  backgroudImageUrl,
                  fit: BoxFit.none,
                  width: categoryItemWidht,
                  height: categoryItemWidht / 2.8,
                ),
                Container(
                  color: const Color.fromARGB(255, 160, 13, 3).withOpacity(0.8),
                  // image widht ve height ile ayni olmali
                  width: categoryItemWidht,
                  height: categoryItemWidht / 2.8,
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createTopSliderItem(String movieBannerUrl, String movieName) {
    return GestureDetector(
      onTap: () {
        print("$movieBannerUrl , $movieName");
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: Material(
          elevation: 12,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(myRadius)),
            child: Stack(
              children: [
                // image.network
                Image.asset(movieBannerUrl, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: Text(
                      movieName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

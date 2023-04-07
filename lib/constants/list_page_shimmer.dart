import 'package:flutter/material.dart';
import 'package:movie_app/constants/util.dart';

class ListPageShimmer extends StatefulWidget {
  const ListPageShimmer({
    super.key,
  });

  @override
  State<ListPageShimmer> createState() => _ListPageShimmerState();
}

class _ListPageShimmerState extends State<ListPageShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return buildLastProcessCardEffect(
                          Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              child: const Text("isoisoiso"),
                            ),
                          ),
                          context);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                clipBehavior: Clip.antiAlias,
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (.4 / 1.02),
                ),
                itemBuilder: (context, index) {
                  return buildLastProcessCardEffect(
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                      ),
                      context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

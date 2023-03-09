import 'package:flutter/material.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPage extends StatefulWidget {
  const TrailerPage({
    super.key,
    required this.id,
    required this.videoURL,
  });
  final int id;
  final List<List<Results>?>? videoURL;

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    for (var i = 0; i < (widget.videoURL?[0]?.length ?? 0); i++) {
      if (widget.videoURL?[0]?[i].type == "Trailer") {
        _controllers.add(
          YoutubePlayerController(
            initialVideoId: YoutubePlayer.convertUrlToId(
                    "https://www.youtube.com/watch?v=${widget.videoURL?[0]?[i].key ?? ""}") ??
                '',
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              forceHD: true,
            ),
          ),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (int i = 0; i < (_controllers.length); i++)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: YoutubePlayer(
                        controller: _controllers[i],
                        showVideoProgressIndicator: true,
                        liveUIColor: Colors.yellow,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              Text("Toplam ${_controllers.length} adet fragman bulunmaktadır."),
            ],
          ),
        ),
      ),
    );
  }
}

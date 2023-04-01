import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/constants/style.dart';
import 'package:movie_app/models/trailer.dart';
import 'package:movie_app/translations/locale_keys.g.dart';
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
  void dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Style.blackColor,
        title: Image.asset(
          "assets/header_logo.png",
          width: 290.w,
          fit: BoxFit.contain,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              for (int i = 0;
                  i < (_controllers.length > 2 ? 2 : _controllers.length);
                  i++)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: YoutubePlayer(
                        controller: _controllers[i],
                        showVideoProgressIndicator: true,
                        liveUIColor: Style.starColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              Text(
                LocaleKeys.there_are_x_trailers_total.tr(
                  args: [_controllers.length.toString()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

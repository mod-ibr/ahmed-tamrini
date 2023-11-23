import 'package:flutter/material.dart';
import 'package:tamrini/screens/exercises_screens/video_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../utils/helper_functions.dart';

class VideoViewer extends StatefulWidget {
  final String? imageUrl, videourl;
  final double width, height;
  final String? title;
  // final Function onEnterFullScreen;
  // final Function onExitFullScreen;

  const VideoViewer(
      {super.key,
      this.imageUrl,
      this.videourl,
      // required this.onEnterFullScreen,
      // required this.onExitFullScreen,
      required this.width,
      required this.height,
      this.title});

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late YoutubePlayerController _controller;
  bool _showVideo =
      false; // Initially, video is not shown until the user presses play.

  @override
  void initState() {
    super.initState();
    String? videoId = extractVideoIdFromUrl(widget.videourl!);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
          useHybridComposition: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.width * 0.8,
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(10.0),
            child: (widget.imageUrl != null)
                ? ZoomOverlay(
                    modalBarrierColor: Colors.black12,
                    minScale: 0.5,
                    maxScale: 3.0,
                    twoTouchOnly: true,
                    animationDuration: const Duration(milliseconds: 100),
                    animationCurve: Curves.fastOutSlowIn,
                    child: Image(
                      image: HelperFunctions.ourFirebaseImageProvider(
                        url: widget.imageUrl!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.image,
                  color: (!_showVideo)
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _showVideo = false;
                  });
                },
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: (_showVideo)
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () {
                  if (!_showVideo) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VideoScreen(
                            controller: _controller, title: widget.title ?? ""),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  String? extractVideoIdFromUrl(String url) {
    Uri uri = Uri.parse(url);
    if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      return uri.queryParameters['v'];
    } else if (uri.host == 'youtu.be') {
      return uri.pathSegments.first;
    }
    return '';
  }
}

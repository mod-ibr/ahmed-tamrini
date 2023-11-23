import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeManager extends StatefulWidget {
  final String youtubeUrl;
  // final void Function(bool)? setFullScreen;

  const YoutubeManager({
    required this.youtubeUrl,
    // this.setFullScreen,
    Key? key,
  }) : super(key: key);

  @override
  State<YoutubeManager> createState() => _YoutubeManagerState();
}

class _YoutubeManagerState extends State<YoutubeManager> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool isFullScreen = false;
  String getVideoID(String url) {
    url = url.replaceAll("https://www.youtube.com/watch?v=", "");
    url = url.replaceAll("https://m.youtube.com/watch?v=", "");
    return url;
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: getVideoID(widget.youtubeUrl),
      autoPlay: false,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        mute: false,
        enableJavaScript: true,
        showControls: true,
        playsInline: true,
        strictRelatedVideos: true,
      ),
    );
    // _controller = YoutubePlayerController(
    //   initialVideoId: YoutubePlayer.convertUrlToId(
    //     widget.youtubeUrl,
    //   )!,
    //   flags: const YoutubePlayerFlags(
    //     mute: false,
    //     autoPlay: false,
    //     forceHD: false,
    //     enableCaption: true,
    //     controlsVisibleAtStart: true,
    //     disableDragSeek: true,
    //   ),
    // );
    // if (!_controller.) {
    //   _controller.toggleFullScreenMode();
    //   isFullScreen = true;
    //   // if (widget.setFullScreen != null) {
    //   //   debugPrint('setting fullscreen inside init state');
    //   //   Future.delayed(const Duration())
    //   //       .then((value) => widget.setFullScreen!(true));
    //   // }
    // }
    // _controller.addListener(listener);
  }

  // void listener() {
  //   // if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
  //   if (_isPlayerReady && mounted) {
  //     // if (widget.setFullScreen != null) {
  //     //   if (isFullScreen != _controller.value.isFullScreen) {
  //     //     debugPrint(
  //     //         'YouTube listener fullscreen?: ${_controller.value.isFullScreen}');
  //     //     debugPrint('setting fullscreen inside listener');
  //     //     widget.setFullScreen!(_controller.value.isFullScreen);
  //     //     setState(() => isFullScreen = _controller.value.isFullScreen);
  //     //   }
  //     // }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return player;
      },
    );

    // YoutubePlayerBuilder(
    //   player: YoutubePlayer(
    //     controller: _controller,
    //     showVideoProgressIndicator: true,
    //     progressIndicatorColor: Colors.blueAccent,
    //     progressColors: const ProgressBarColors(
    //       playedColor: Colors.amber,
    //       handleColor: Colors.amberAccent,
    //     ),
    //     onReady: () => setState(() => _isPlayerReady = true),
    //     bottomActions: [
    //       CurrentPosition(),
    //       ProgressBar(isExpanded: true),
    //       RemainingDuration(),
    //       FullScreenButton(),
    //     ].reversed.toList(),
    //   ),
    //   builder: (context, player) => Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       player,
    //     ],
    //   ),
    // );

    // return YoutubePlayerBuilder(
    //   onExitFullScreen: () {
    //     // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
    //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //   },
    //   player: YoutubePlayer(
    //     controller: _controller,
    //     showVideoProgressIndicator: true,
    //     progressIndicatorColor: Colors.blueAccent,
    //     onReady: () {
    //       print('----- player is ready ------');
    //       _isPlayerReady = true;
    //     },
    //     onEnded: (data) {},
    //   ),
    //   builder: (context, player) => Column(
    //     children: [
    //       player,
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    // if (mounted) {
    //   if (_controller.value.isFullScreen) {
    //     _controller.toggleFullScreenMode();
    //     if (widget.setFullScreen != null) {
    //       debugPrint('setting fullscreen inside dispose');
    //       widget.setFullScreen!(false);
    //     }
    //   }
    // }
    // _controller.dispose();
    super.dispose();
  }
}

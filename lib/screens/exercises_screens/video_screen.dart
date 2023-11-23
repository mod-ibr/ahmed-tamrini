import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatelessWidget {
  final String title;
  final YoutubePlayerController controller;

  const VideoScreen({super.key, required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        showVideoProgressIndicator: true,
        onReady: () => log("Video ready"),
        controller: controller,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: player,
        ),
      ),
    );
  }
}

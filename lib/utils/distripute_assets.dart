import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tamrini/utils/regex.dart';
import 'package:tamrini/utils/video_manager.dart';
import 'package:tamrini/utils/youtube_manager.dart';
import 'dart:developer';

import 'helper_functions.dart';

List<Widget> distributeAssets(List<String> assets
    // void Function(bool)? setFullScreen,
    ) {
  List<Widget> distributedAssets = [];
  for (int i = 0; assets.length > i; i++) {
    if (RegExp(RegexPatterns.allowedYoutubeUrlFormat).hasMatch(assets[i]) ==
        true) {
      distributedAssets.add(YoutubeManager(
        youtubeUrl: assets[i],
        // setFullScreen: setFullScreen,
      ));
    }
    //  else if (!assets[i].contains(RegExp(
    //     "[^\\s]+(.*?)\\.(jpg|jpeg|png|JPG|JPEG|PNG|WEBP|webp|tiff|Tiff|TIFF|GIF|gif|bmp|BMP|svg|SVG)"))) {
    //   distributedAssets.add(//VideoManager(
    //     remoteUrl: assets[i],
    //     // setFullScreen: setFullScreen,
    //   ));
    // }
    else {
      log("assets[i] : ${assets[i]}");
      distributedAssets.add(PhotoView(
        imageProvider: HelperFunctions.ourFirebaseImageProvider(url: assets[i]),
      ));
    }
  }
  return distributedAssets;
}

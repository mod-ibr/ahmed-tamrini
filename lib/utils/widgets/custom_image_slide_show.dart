import 'package:flutter/material.dart';

import 'package:tamrini/screens/exercises_screens/article_assets_view.dart';

class CustomImageSlideShow extends StatelessWidget {
  final List<String> assets;
  // final Function onEnterFullScreen;
  // final Function onExitFullScreen;
  final int? current;
  final void Function(int)? updateCurrent;

  const CustomImageSlideShow({
    // required this.onEnterFullScreen,
    // required this.onExitFullScreen,
    this.current,
    this.updateCurrent,
    Key? key,
    required this.assets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return VideoViewer(
      // onEnterFullScreen: onEnterFullScreen,
      // onExitFullScreen: onExitFullScreen,
      width: size.width,
      height: size.height,
      imageUrl: assets.first,
      videourl: assets.last,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constants.dart';
import '../regex.dart';

class ImageSlideShowNavigation extends StatelessWidget {
  final List<String> assets;
  final int currentIndex;
  final void Function(int) onSliderChanged;

  const ImageSlideShowNavigation(
      {required this.assets, required this.currentIndex, required this.onSliderChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...assets
              .map(
                (asset) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      print('index of : ${assets.indexOf(asset)}');
                      onSliderChanged(assets.indexOf(asset));
                    },
                    child: Icon(
                      asset.contains(
                        RegExp(RegexPatterns.allowedImageFormat),
                      )
                          ? Ionicons.image_outline
                          : Ionicons.videocam,
                      color: currentIndex == assets.indexOf(asset)
                          ? kSecondaryColor
                          : const Color.fromRGBO(192, 194, 194, 0.9),
                    ),
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}

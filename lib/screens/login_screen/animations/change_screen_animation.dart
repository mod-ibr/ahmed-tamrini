import 'package:flutter/material.dart';

import '../components/login_content.dart';

class ChangeScreenAnimation {
  static late final AnimationController topTextController;
  static late final Animation<Offset> topTextAnimation;

  // static late final AnimationController bottomTextController;
  // static late final Animation<Offset> bottomTextAnimation;

  static final List<AnimationController> createAccountControllers = [];
  static final List<Animation<Offset>> createAccountAnimations = [];

  static final List<AnimationController> loginControllers = [];
  static final List<Animation<Offset>> loginAnimations = [];

  static var isPlaying = false;
  static bool isInitialized = false;
  static var currentScreen = Screens.welcomeBack;

  static Animation<Offset> _createAnimation({
    required Offset begin,
    required Offset end,
    required AnimationController parent,
  }) {
    return Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: parent,
        curve: Curves.easeInOut,
      ),
    );
  }

  static void initialize({
    required TickerProvider vsync,
    required int createAccountItems,
    required int loginItems,
  }) {
    isInitialized = true;
    topTextController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
    );

    topTextAnimation = _createAnimation(
      begin: Offset.zero,
      end: const Offset(0, -1.2),
      parent: topTextController,
    );

    // bottomTextController = AnimationController(
    //   vsync: vsync,
    //   duration: const Duration(milliseconds: 200),
    // );
    //
    // bottomTextAnimation = _createAnimation(
    //   begin: Offset.zero,
    //   end: const Offset(0, 0.82),
    //   parent: bottomTextController,
    // );

    for (var i = 0; i < loginItems; i++) {
      loginControllers.add(
        AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 200),
        ),
      );

      loginAnimations.add(
        _createAnimation(
          begin: Offset.zero,
          end: const Offset(1, 0),
          parent: loginControllers[i],
        ),
      );
    }
    for (var i = 0; i < createAccountItems; i++) {
      createAccountControllers.add(
        AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 200),
        ),
      );

      createAccountAnimations.add(
        _createAnimation(
          begin: const Offset(-1, 0),
          end: Offset.zero,
          parent: createAccountControllers[i],
        ),
      );
    }
  }
  //
  // static void dispose() {
  //   for (final controller in [
  //     topTextController,
  //     // bottomTextController,
  //     ...createAccountControllers,
  //     ...loginControllers,
  //   ]) {
  //     // controller.dispose();
  //   }
  // }

  static Future<void> forward() async {
    isPlaying = true;

    topTextController.forward();

    for (final controller in [
      ...createAccountControllers,
      ...loginControllers,
    ]) {
      controller.reverse();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // bottomTextController.reverse();
    print("reversed");
    await topTextController.reverse();

    isPlaying = false;
  }

  static Future<void> reverse() async {
    isPlaying = true;

    topTextController.forward();
    // bottomTextController.forward();

    for (final controller in [
      ...loginControllers,
      ...createAccountControllers,
    ]) {
      controller.forward();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    await topTextController.reverse();

    isPlaying = false;
  }
}

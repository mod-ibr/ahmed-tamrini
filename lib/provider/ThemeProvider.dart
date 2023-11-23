import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class ThemeProvider extends ChangeNotifier {
  bool isAdReady = false;

  ThemeProvider() {
    init();
  }

  static SharedPreferences? sharedPreferences;
  int tabCalculator = 0;
  String placementId =
      Platform.isAndroid ? "Interstitial_Android" : "Interstitial_iOS";
  String rewardedPlacementId =
      Platform.isAndroid ? "Rewarded_Android" : "Rewarded_iOS";

  init() async {
    await UnityAds.init(
      gameId: Platform.isAndroid ? '5168360' : "5168361",
      onComplete: () {
        print("unity init Success");
        _loadAd(placementId);
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );

    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences?.getBool('isDark') == null) {
      await sharedPreferences?.setBool('isDark', false);
    }
    if (sharedPreferences?.getBool('isArabic') == null) {
      await sharedPreferences?.setBool('isArabic', true);
    }
  }

  void _loadAd(String placementId) {
    UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        isAdReady = true;
        print('Load Complete $placementId');
      },
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  loadRewardedAd() {
    print("loadRewardedAd");
    _loadAd(rewardedPlacementId);
  }

  showRewardedAd() {
    print("showRewardedAd");

    _showAd(rewardedPlacementId);
  }

  void _showAd(String placementId) {
    UnityAds.showVideoAd(
      placementId: placementId,
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);
      },
      onFailed: (placementId, error, message) {
        print('Video Ad $placementId failed: $error $message');
        _loadAd(placementId);
      },
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) {
        print('Video Ad $placementId skipped');
        _loadAd(placementId);
      },
    );
  }

  addTabCalculator() {
    tabCalculator++;
    print(tabCalculator);
    if (tabCalculator == 100) {
      tabCalculator = 0;
      if (isAdReady) {
        _showAd(placementId);
      }
    }
    notifyListeners();
  }

  bool isDark = false;

  void changeAppMode({required bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      notifyListeners();
    } else
      isDark = !isDark;
    sharedPreferences?.setBool('isDark', isDark).then((value) {
      notifyListeners();
    });
  }

  bool isArabic = true;

  Future<void> changeLanguage(
      {required bool arabic, required Locale lang}) async {
    isArabic = arabic;
    await navigationKey.currentContext!.setLocale(lang);
    await Get.updateLocale(lang);
    sharedPreferences?.setBool('isArabic', isArabic).then((value) {
      notifyListeners();
    });
  }
}

import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/article.dart';
import 'package:tamrini/model/exercise.dart' as exer;
import 'package:tamrini/model/gym.dart';
import 'package:tamrini/provider/artical_provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/product_provider.dart' as prodProvider;
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../model/product.dart' as prod;
import '../screens/home_screen_body.dart';
import 'exercise_provider.dart';

class HomeProvider extends ChangeNotifier {
  List banners = [];
  UserProvider userProvider = UserProvider();
  prodProvider.ProductProvider productProvider = prodProvider.ProductProvider();
  GymProvider gymProvider = GymProvider();
  ArticleProvider articleProvider = ArticleProvider();
  ExerciseProvider exerciseProvider = ExerciseProvider();
  bool isLoaded = false;
  bool isLoading = false;

  List<Gym> gyms = [];
  List<exer.ExerciseData> exercises = [], _exercises = [];
  List<Article> articles = [];
  List<prod.Data> products = [], _products = [];
  bool gymsLoaded = false;
  bool articlesLoaded = false;
  bool exerciseLoaded = false;
  bool productLoaded = false;

  init({
    required UserProvider userProvider,
    required prodProvider.ProductProvider productProvider,
    required GymProvider gymProvider,
    required ArticleProvider articleProvider,
    required ExerciseProvider exerciseProvider,
  }) async {
    this.userProvider = userProvider;
    this.productProvider = productProvider;
    this.gymProvider = gymProvider;
    this.articleProvider = articleProvider;
    this.exerciseProvider = exerciseProvider;

    isLoading = true;

    if (!isLoaded) {
      isLoaded = true;

      debugPrint("setupInteractedMessage ya hossam");
      setupInteractedMessage();

      Dio()
          .get(
              'https://tamrini-app-default-rtdb.europe-west1.firebasedatabase.app/banner/.json')
          .then((value) async {
        var data = value.data != null ? value.data as List : [];
        await FirebaseFirestore.instance
            .collection('general')
            .doc('banner')
            .getSavy()
            .then((event) {
          banners = data;

          var dataC = event.data()! as Map;
          // assign every counter to its banner
          for (var element in banners) {
            var url = element['url']
                .toString()
                .replaceAll('/', '\\')
                .replaceAll('.', '``')
                .replaceAll("~", "!")
                .replaceAll("*", "<")
                .replaceAll("[", ">")
                .replaceAll("]", ", ,");
            element['counter'] = dataC[url] ?? 0;
          }

          notifyListeners();
        });
        // notifyListeners();
      });
    }

    // gymProvider.sortByDistance();
    gyms = gymProvider.gyms
        .take(5)
        .where((element) => element.assets.first.contains(RegExp(
            "[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF|webp|WEBP)")))
        .toList();

    gyms.sort((a, b) => a.distance.compareTo(b.distance));
    gymsLoaded = true;

    if (exerciseProvider.allExercises.data!.isNotEmpty && !exerciseLoaded) {
      _exercises = exerciseProvider.allExercises.data!
          .where((element) =>
              element.assets != null &&
              element.assets!.isNotEmpty &&
              element.assets!.first.contains(RegExp(
                  "[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF|webp|WEBP)")))
          .toList()
        ..shuffle();

      exercises = _exercises.take(5).toList();
      exerciseLoaded = true;
    }

    articles = articleProvider.articles
        .where((element) =>
            element.image != null &&
            element.image!.isNotEmpty &&
            element.image!.first.contains(RegExp(
                "[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF|webp|WEBP)")))
        .take(5)
        .toList();
    articlesLoaded = true;

    if (productProvider.allProducts.data!.isNotEmpty && !productLoaded) {
      _products = productProvider.allProducts.data!
          .where((element) =>
              element.assets != null &&
              element.assets!.isNotEmpty &&
              element.assets!.first.contains(RegExp(
                  "[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF|webp|WEBP)")))
          .toList()
        ..shuffle();
      products = _products.take(5).toList();

      productLoaded = true;
    }

    if (gymsLoaded && articlesLoaded && exerciseLoaded && productLoaded) {
      isLoading = false;
      notifyListeners();
    }

    // Future.delayed(const Duration(seconds: 5)).then((value) {
    //   HomeScreenBody.loading = false;
    //   notifyListeners();
    // });
  }

  addBanner(Map<String, String> banner) async {
    banners.add(banner);
    await Dio().put(
        'https://tamrini-app-default-rtdb.europe-west1.firebasedatabase.app/banner/.json',
        data: [...banners]).then((value) {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(msg: tr('added_banner'));
        log(value.data.toString());
        var data = value.data['banner'] as List<Map<String, String>>;
        banners = data;
        notifyListeners();
        pop();
      } else {
        Fluttertoast.showToast(msg: tr('wrong'));
        banners.remove(banner);
      }
    });
  }

  deleteBanner({required Map<String, dynamic> banner}) async {
    var data = banner;
    banners.remove(banner);
    await Dio().put(
        'https://tamrini-app-default-rtdb.europe-west1.firebasedatabase.app/banner/.json',
        data: [...banners]).then((value) async {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(msg: tr('deleted_banner'));

        await FirebaseStorage.instance
            .ref(data['image'].split('tamrini-app.appspot.com/')[1])
            .delete();
        bannerIndex = 0;
        // var data = value.data['banner'];
        // banners = data;
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: tr('wrong'));
      }
    });
  }

  onClickBanner({required int index}) {
    try {
      var data = banners[index]['url']
          .toString()
          .replaceAll('/', '\\')
          .replaceAll('.', '``')
          .replaceAll("~", "!")
          .replaceAll("*", "<")
          .replaceAll("[", ">")
          .replaceAll("]", ", ,");
      FirebaseFirestore.instance
          .collection('general')
          .doc('banner')
          .update({data: FieldValue.increment(1)}).then((value) {
        log("banner clicked");
        ++banners[index]['counter'];
        notifyListeners();
      });
      launchUrl(Uri.parse(banners[index]['url'] ?? 'https://www.google.com'),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  banUser({String? username}) async {
    try {
      // showLoaderDialog(navigationKey.currentContext!);
      await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .getSavy()
          .then((value) {
        var data = value.docs.first.data() as Map<String, dynamic>;
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          title: tr('are_you_sure'),
          desc:
              "${"${tr('user_will_be_blocked')} " + data['name']} ${tr('from_app')}",
          btnOkOnPress: () {
            value.docs.first.reference.update({'isBanned': true});
            AwesomeDialog(
              context: navigationKey.currentContext!,
              dialogType: DialogType.success,
              animType: AnimType.BOTTOMSLIDE,
              title: tr('block_user'),
              desc:
                  "${"${tr('block_user')} " + data['name']} ${tr('from_app')}",
              btnOkOnPress: () {
                pop();
                pop();
              },
            ).show();
          },
        ).show();
      });

      // pop();

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

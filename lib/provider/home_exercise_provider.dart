import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/home_exercise.dart';
import 'package:tamrini/provider/user_provider.dart';

import '../screens/home_exercises_screens/home_exercise_Articles_Screen.dart';
import '../utils/helper_functions.dart';
import '../utils/widgets/global Widgets.dart';
import 'Upload_Image_provider.dart';

class HomeExerciseProvider extends ChangeNotifier {
  List<HomeExercise> exercises = [], _Originalexercises = [];
  HomeExercise _allExercises = HomeExercise(data: [], id: ""),
      allExercises = HomeExercise(data: [], id: "");
  UserProvider userProvider = UserProvider();
  List<Data> selectedExercise = [], _selectedExercise = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  Future<void> fetchAndSetExercise() async {
    try {
      isLoading = true;
      FirebaseFirestore.instance
          .collection('homeExercises')
          .doc('data')
          .collection('data')
          .getSavy()
          .then((event) {
        exercises = event.docs.map((e) {
          HomeExercise homeExercise =
              HomeExercise.fromJson(e.data() as Map<String, dynamic>, e.id);
          if (homeExercise.image != null || homeExercise.image!.isEmpty) {
            // log("Image not null or empty : ${homeExercise.data[0].}");
          }
          return homeExercise;
        }).toList();
        print('home Exercises fetched ${exercises.length}');
        _Originalexercises = exercises;
        isLoading = false;
        showAllExercises();

        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      print(error);

      //TODO: Show error screen
    }
  }

  showAllExercises() {
    allExercises.data = [];
    for (HomeExercise i in _Originalexercises) {
      print(i.data!.length);
      allExercises.data?.addAll(i.data!);
    }
    print("all exe ${allExercises.data!.length}");
    _allExercises = allExercises;
    notifyListeners();
  }

  searchAll() {
    if (searchController.text.isEmpty) {
      selectedExercise = _allExercises.data!;
      notifyListeners();
      return;
    }
    selectedExercise = allExercises.data!
        .where(
          (element) => HelperFunctions.matchesSearch(
            searchController.text.toLowerCase().split(" "),
            element.title!,
          ),
        )
        .toList();

    notifyListeners();
  }

  search(String title) {
    if (searchController.text.isEmpty ||
        searchController.text == "" ||
        searchController.text == " ") {
      selectedExercise =
          _Originalexercises.where((element) => element.title == title)
              .first
              .data!;

      notifyListeners();
      return;
    }
    selectedExercise =
        _Originalexercises.where((element) => element.title == title)
            .first
            .data!
            .where(
              (element) => HelperFunctions.matchesSearch(
                searchController.text.toLowerCase().split(" "),
                element.title!,
              ),
            )
            .toList();

    notifyListeners();
  }

  clearSearch() {
    searchController.clear();
    selectedExercise = _allExercises.data!;
  }

  Future<void> addCategory(
      {required String title,
      required String image,
      required int order}) async {
    try {
      print("title $title image $image");

      //TODO: Show Loading

      FirebaseFirestore.instance
          .collection('homeExercises')
          .doc('data')
          .collection('data')
          .add({
        "title": title,
        "image": image,
        "order": order,
        "data": []
      }).then((value) {
        print(value.id);
        exercises.add(HomeExercise(
            title: title, image: image, data: [], id: value.id, order: order));
        notifyListeners();
        _Originalexercises = exercises;

        pop();
        pop();

        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('accomplished_successfully'),
          desc: tr('section_added_successfully'),
          btnOkOnPress: () {},
        ).show();

        //TODO: Hide Loading

        //TODO: Show Success
      });
    } catch (e) {
      print(e);

      //TODO: Show error screen
    }
  }

  Future<void> addExercise({
    required String title,
    required List<String> images,
    required String description,
    required HomeExercise category,
  }) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      var id = category.id! + DateTime.now().millisecond.toString();

      var data = Data(
        title: title,
        assets: images,
        description: description,
        id: id,
      );

      FirebaseFirestore.instance
          .collection('homeExercises')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        "data": FieldValue.arrayUnion([data.toJson()])
      }).then((value) {
        exercises
            .firstWhere((element) => element.title == category.title)
            .data!
            .add(Data(
              title: title,
              assets: images,
              description: description,
              id: id,
            ));
        notifyListeners();
        _Originalexercises = exercises;
        showAllExercises();

        pop();
        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('accomplished_successfully'),
          desc: tr('exercise_added_successfully'),
          btnOkOnPress: () {},
        ).show();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCategory({required String id}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      log("id $id");
      var assets = exercises.firstWhere((element) => element.id == id).image!;
      var data = exercises
          .firstWhere((element) => element.id == id)
          .data
          ?.map((e) => e.assets)
          .toList();

      FirebaseFirestore.instance
          .collection('homeExercises')
          .doc('data')
          .collection('data')
          .doc(id)
          .delete()
          .then((value) async {
        exercises.removeWhere((element) => element.id == id);
        _Originalexercises = exercises;
        showAllExercises();

        await UploadProvider().deleteAllAssets([assets]);

        for (var i in data!) {
          await UploadProvider().deleteAllAssets(i!);
        }
      });
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accomplished_successfully'),
        desc: tr('delete_partition'),
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      print(e);
      //TODO: Show error screen
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_category'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  moveToExercise(HomeExercise exercise, {bool isAll = false}) {
    selectedExercise = exercise.data!;
    notifyListeners();
    To(HomeExerciseArticlesScreen(
      homeExercise: exercise,
      isAll: isAll,
    ));
  }

  Future<void> deleteExercise(
      {required Data exercise, required HomeExercise category}) async {
    try {
      //TODO: show loading

      var exerciseAssets = exercise.assets;

      exercises
          .firstWhere((element) => element.id == category.id)
          .data!
          .removeWhere((element) => element.id == exercise.id);
      FirebaseFirestore.instance
          .collection('homeExercises')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        'data': exercises
            .firstWhere((element) => element.id == category.id)
            .data!
            .map((e) => e.toJson())
            .toList()
      }).then((value) async {
        await UploadProvider().deleteAllAssets(exerciseAssets!);

        notifyListeners();
        _Originalexercises = exercises;
        showAllExercises();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('delete_successfully'),
          desc: tr('exercise_deleted'),
          btnOkOnPress: () {},
        ).show();
      });
    } catch (e) {
      print(e);

      //TODO: Show error screen
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_workout'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> editCategory({
    required String title,
    required String image,
    required String oldTitle,
    required int order,
  }) async {
    try {
      var oldImage =
          exercises.firstWhere((element) => element.title == oldTitle).image;
      FirebaseFirestore.instance
          .collection('homeExercises')
          .doc('data')
          .collection('data')
          .where('title', isEqualTo: oldTitle)
          .getSavy()
          .then((value) {
        value.docs.first.reference.update({
          "title": title,
          "image": image,
          "order": order,
        }).then((value) async {
          if (image != oldImage) {
            await UploadProvider().deleteAllAssets([oldImage!]);
          }
          exercises.firstWhere((element) => element.title == oldTitle).title =
              title;
          exercises.firstWhere((element) => element.title == oldTitle).image =
              image;
          exercises.firstWhere((element) => element.title == oldTitle).order =
              order;
          notifyListeners();
          _Originalexercises = exercises;
        });
      });
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accomplished_successfully'),
        desc: tr('modified_classification'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_classification'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> editExercise(
      {required String title,
      required List<String> images,
      required String description,
      required String catID,
      required String id}) async {
    try {
      var oldImages = exercises
          .firstWhere((element) => element.id == catID)
          .data!
          .firstWhere((element) => element.id == id)
          .assets;

      exercises
          .firstWhere((element) => element.id == catID)
          .data!
          .removeWhere((element) => element.id == id);

      exercises.firstWhere((element) => element.id == catID).data!.add(
          Data(title: title, assets: images, description: description, id: id));

      FirebaseFirestore.instance
          .collection('homeExercises')
          .doc('data')
          .collection('data')
          .doc(catID)
          .update({
        "data": exercises
            .firstWhere((element) => element.id == catID)
            .data!
            .map((e) => e.toJson())
            .toList()
      }).then((value) async {
        await UploadProvider()
            .deleteOldImages(oldImages: oldImages!, newImages: images);

        _Originalexercises = exercises;

        notifyListeners();
        pop();
        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('modified_successfully'),
          desc: tr('exercise_modified'),
          btnOkOnPress: () {},
        ).show();
      });

      //TODO: stop loading
      //TODO: show success
    } catch (e) {
      print(e);

      //TODO: show error screen
    }
  }

  Future<void> suggestExercise({
    required String title,
    required String description,
    required String categoryTitle,
  }) async {
    try {
      Map myData = {
        'category_title': categoryTitle,
        "title": title,
        "description": description,
      };

      FirebaseFirestore.instance
          .collection('requests')
          .doc('homeExercises')
          .set({
        "data": FieldValue.arrayUnion([myData])
      }, SetOptions(merge: true));
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('sent_successfully'),
        desc: tr('sent_proposal'),
        btnOkOnPress: () {
          pop();
          pop();
        },
      ).show();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteHomeExerciseSuggestion(
      {required Map<String, dynamic> data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc('homeExercises')
          .update({
        "data": FieldValue.arrayRemove([data])
      });

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('delete_successfully'),
        desc: tr('suggestion_deleted'),
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      print(e);
    }
  }
}

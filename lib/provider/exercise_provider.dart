import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/screens/trainer_screens/add_trainee_exercise_screen.dart';
import 'package:tamrini/screens/trainer_screens/exercise_superset_screen.dart';

import '../screens/exercises_screens/exercise_Articles_Screen.dart';
import '../utils/helper_functions.dart';
import '../utils/widgets/global Widgets.dart';
import 'Upload_Image_provider.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> exercises = [], _Originalexercises = [];
  Exercise _allExercises = Exercise(data: [], id: '0'),
      allExercises = Exercise(id: "0", data: []);

  // UserProvider userProvider = UserProvider();
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  List<ExerciseData> selectedExercise = [];
  List<ExerciseData> selectedSuperSetExercise = [];

  Future<void> fetchAndSetExercise() async {
    try {
      isLoading = true;

      FirebaseFirestore.instance
          .collection('exercises')
          .doc('data')
          .collection('data')
          .getSavy()
          .then((event) {
        exercises = event.docs
            .map((e) =>
                Exercise.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        isLoading = false;
        _Originalexercises = exercises;
        showAllExercises();

        print("exercises :  ${exercises.length}");

        notifyListeners();
      });
    } catch (error) {
      print(error);
      isLoading = false;
    }
  }

  moveToExercise(Exercise exercise,
      {bool isAll = false,
      bool isAdd = false,
      String dayID = "",
      bool? superSet = false,
      ExerciseData? mainExercise}) {
    if (superSet == true) {
      selectedSuperSetExercise = exercise.data!;
    } else {
      selectedExercise = exercise.data!;
    }
    notifyListeners();
    isAdd && superSet == false
        ? To(AddTraineeExerciseScreen(
            dayID: dayID,
            exercise: exercise,
            isAll: isAll,
          ))
        : superSet == true
            ? To(ExerciseSupersetScreen(
                exercise: exercise,
                isAll: isAll,
                mainExercise: mainExercise,
                dayID: dayID,
              ))
            : To(ExerciseArticlesScreen(
                exercise: exercise,
                isAll: isAll,
              ));
  }

  showAllExercises() {
    allExercises.data!.clear();
    for (Exercise i in _Originalexercises) {
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

  search(String id) {
    if (searchController.text.isEmpty ||
        searchController.text == "" ||
        searchController.text == " ") {
      selectedExercise =
          _Originalexercises.where((element) => element.id == id).first.data!;
      notifyListeners();
      return;
    }
    selectedExercise = _Originalexercises.where((element) => element.id == id)
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
  }

  Future<void> addCategory(
      {required String title,
      required String image,
      required int order}) async {
    try {
      FirebaseFirestore.instance
          .collection('exercises')
          .doc('data')
          .collection('data')
          .add({
        "title": title,
        "image": image,
        "order": order,
        "data": []
      }).then((value) {
        exercises.add(Exercise(
            title: title, image: image, data: [], id: value.id, order: order));
        notifyListeners();
        _Originalexercises = exercises;

        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('added_successfully'),
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

  Future<void> addExercise(
      {required String title,
      required List<String> images,
      required String description,
      required String category}) async {
    try {
      // if (!UserProvider.isAdmin && !UserProvider.isCaptain) {
      //   return;
      // }

      FirebaseFirestore.instance
          .collection('exercises')
          .doc('data')
          .collection('data')
          .where('title', isEqualTo: category)
          .getSavy()
          .then((value) {
        var id = value.docs.first.id + DateTime.now().millisecond.toString();
        value.docs.first.reference.update({
          "data": FieldValue.arrayUnion([
            {
              "title": title,
              "image": images,
              "description": description,
              "id": id
            }
          ])
        }).then((value) {
          exercises
              .firstWhere((element) => element.title == category)
              .data!
              .add(ExerciseData(
                  title: title,
                  assets: images,
                  description: description,
                  id: id));
          allExercises.data!.add(ExerciseData(
              title: title, assets: images, description: description, id: id));
          notifyListeners();
          _Originalexercises = exercises;
        });
      });
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('added_successfully'),
        desc: tr('exercise_added_successfully'),
        btnOkOnPress: () {
          pop();
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
        desc: tr('error_while_adding_exercise'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future<void> deleteCategory({required String id}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      var assets = exercises.firstWhere((element) => element.id == id).image!;
      var data = exercises
          .firstWhere((element) => element.id == id)
          .data
          ?.map((e) => e.assets)
          .toList();

      FirebaseFirestore.instance
          .collection('exercises')
          .doc('data')
          .collection('data')
          .doc(id)
          .delete()
          .then((value) async {
        exercises.removeWhere((element) => element.id == id);
        _Originalexercises = exercises;
        showAllExercises();
        notifyListeners();

        await UploadProvider().deleteAllAssets([assets]);

        for (var i in data!) {
          await UploadProvider().deleteAllAssets(i!);
        }
        pop();

        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('delete_successfully'),
          desc: tr('delete_partition'),
          btnOkOnPress: () {},
        ).show();
      });
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_while_deleting_partition'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future<void> deleteExercise(
      {required ExerciseData exercise, required Exercise category}) async {
    try {
      //TODO: show loading
      var exerciseAssets = exercise.assets;
      exercises
          .firstWhere((element) => element.id == category.id)
          .data!
          .removeWhere((element) => element.id == exercise.id);

      FirebaseFirestore.instance
          .collection('exercises')
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

        _Originalexercises = exercises;
        allExercises.data!.removeWhere((element) => element.id == exercise.id);
        notifyListeners();

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
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('wrong'),
        desc: tr('error_while_deleting'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> editCategory({
    required String title,
    required String image,
    required String id,
    required int order,
  }) async {
    try {
      FirebaseFirestore.instance
          .collection('exercises')
          .doc('data')
          .collection('data')
          .doc(id)
          .update({
        "title": title,
        "image": image,
        "order": order,
      }).then((value) async {
        if (image !=
            exercises.firstWhere((element) => element.id == id).image) {
          await FirebaseStorage.instance
              .ref(exercises
                  .firstWhere((element) => element.id == id)
                  .image!
                  .split('tamrini-app.appspot.com/')[1])
              .delete();
        }
        exercises.firstWhere((element) => element.id == id).title = title;
        exercises.firstWhere((element) => element.id == id).image = image;
        exercises.firstWhere((element) => element.id == id).order = order;
        notifyListeners();
        _Originalexercises = exercises;
      });
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('modified_successfully'),
        desc: tr('section_modified_successfully'),
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
        desc: tr('error_while_modified'),
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
      var oldData = exercises
          .firstWhere((element) => element.id == catID)
          .data!
          .firstWhere((element) => element.id == id)
          .assets;

      exercises
          .firstWhere((element) => element.id == catID)
          .data!
          .removeWhere((element) => element.id == id);

      exercises.firstWhere((element) => element.id == catID).data!.add(
          ExerciseData(
              title: title, assets: images, description: description, id: id));

      FirebaseFirestore.instance
          .collection('exercises')
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
        _Originalexercises = exercises;

        await UploadProvider()
            .deleteOldImages(oldImages: oldData!, newImages: images);

        allExercises.data!.removeWhere((element) => element.id == id);
        allExercises.data!.add(ExerciseData(
            title: title, assets: images, description: description, id: id));

        notifyListeners();

        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('modified_successfully'),
          desc: tr('exercise_modified'),
          btnOkOnPress: () {
            pop();
            pop();
            pop();
          },
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
      FirebaseFirestore.instance.collection('requests').doc('exercises').set({
        "data": FieldValue.arrayUnion([
          {
            "category_title": categoryTitle,
            "title": title,
            "description": description,
          }
        ])
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

  Future<void> deleteExerciseSuggestion(
      {required Map<String, dynamic> data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc('exercises')
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

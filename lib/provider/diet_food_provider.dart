import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/diet_food.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../utils/helper_functions.dart';
import 'Upload_Image_provider.dart';

class DietFoodProvider with ChangeNotifier {
  List<DietFood> foodList = [], filteredFoodList = [];
  bool isAdmin = false, isCaptain = false;
  List<DietFood> pendingFood = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  Future<void> setRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    print("rooooooole $role");
    if (role == 'admin') {
      isAdmin = true;
      isCaptain = false;
    } else if (role == 'captain') {
      isCaptain = true;
      isAdmin = false;
    } else {
      isAdmin = false;
      isCaptain = false;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetMeals() async {
    try {
      isLoading = true;
      FirebaseFirestore.instance
          .collection('dietFood')
          .doc('data')
          .collection('data')
          .orderBy('title', descending: true)
          .getSavy()
          .then((event) {
        foodList = event.docs
            .map((e) =>
                DietFood.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        filteredFoodList = foodList;
        isLoading = false;
        print('food fetched ${foodList.length}');
        notifyListeners();
        setRole();
      });
    } catch (error) {
      isLoading = false;
      notifyListeners();
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }

  Future<void> fetchAndSetPendingMeal() async {
    isLoading = true;
    try {
      FirebaseFirestore.instance
          .collection('dietFood')
          .doc('pending')
          .collection('data')
          .orderBy('title', descending: true)
          .getSavy()
          .then((event) {
        pendingFood = event.docs
            .map((e) =>
                DietFood.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        print('pending articles fetched ${pendingFood.length}');
        isLoading = false;
        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: Text(tr('wrong')),
                content: Text(error.toString()),
              ));
    }
  }

  search() {
    if (searchController.text.isEmpty) {
      filteredFoodList = foodList;
      notifyListeners();
      return;
    }
    filteredFoodList = foodList
        .where(
          (element) => HelperFunctions.matchesSearch(
            searchController.text.toLowerCase().split(" "),
            element.title,
          ),
        )
        .toList();
    notifyListeners();
  }

  clearSearch() {
    searchController.clear();
    filteredFoodList = foodList;
  }

  Future<void> addMeal(DietFood dietFood) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      await FirebaseFirestore.instance
          .collection('dietFood')
          .doc('pending')
          .collection('data')
          .add(dietFood.toJson());

      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: tr('accomplished_successfully'),
        desc: tr('the_food_deleted'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (error) {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('wrong'),
        desc: error.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      var data = foodList.firstWhere((element) => element.id == id).assets;
      if (isAdmin) {
        await FirebaseFirestore.instance
            .collection('dietFood')
            .doc('data')
            .collection('data')
            .doc(id)
            .delete();

        await UploadProvider().deleteAllAssets(data);

        foodList.removeWhere((element) => element.id == id);
        filteredFoodList.removeWhere((element) => element.id == id);
      }

      notifyListeners();
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: tr('accomplished_successfully'),
        desc: tr('the_food_deleted'),
        btnOkOnPress: () {},
      ).show();
    } catch (error) {
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }

  Future<void> rejectMeal(String id) async {
    showLoaderDialog(navigationKey.currentContext!);

    var data = pendingFood.firstWhere((element) => element.id == id).assets;

    try {
      await FirebaseFirestore.instance
          .collection('dietFood')
          .doc('pending')
          .collection('data')
          .doc(id)
          .delete();

      await UploadProvider().deleteAllAssets(data);

      pendingFood.removeWhere((element) => element.id == id);

      pop();
      notifyListeners();
    } catch (error) {
      pop();
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }

  Future<void> approveMeal(DietFood meal) async {
    showLoaderDialog(navigationKey.currentContext!);
    try {
      await FirebaseFirestore.instance
          .collection('dietFood')
          .doc('data')
          .collection('data')
          .add(meal.toJson());

      await FirebaseFirestore.instance
          .collection('dietFood')
          .doc('pending')
          .collection('data')
          .doc(meal.id)
          .delete();

      pendingFood.removeWhere((element) => element.id == meal.id);
      foodList.add(meal);
      filteredFoodList = foodList;
      pop();
      notifyListeners();
    } catch (error) {
      pop();
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }

  Future<void> updateMeal(DietFood meal, String type) async {
    showLoaderDialog(navigationKey.currentContext!);
    try {
      var data = foodList.firstWhere((element) => element.id == meal.id).assets;
      var newData = meal.assets;
      switch (type) {
        case 'pending':
          await FirebaseFirestore.instance
              .collection('dietFood')
              .doc('pending')
              .collection('data')
              .doc(meal.id)
              .update(meal.toJson());
          break;
        case 'existing':
          await FirebaseFirestore.instance
              .collection('dietFood')
              .doc('data')
              .collection('data')
              .doc(meal.id)
              .update(meal.toJson());
          break;
      }

      await UploadProvider()
          .deleteOldImages(oldImages: data!, newImages: newData!);

      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        title: tr('accomplished_successfully'),
        desc: tr('the_recipe_successfully'),
        btnOkOnPress: () {
          pop();
          pop();
        },
      ).show();

      foodList.removeWhere((element) => element.id == meal.id);
      foodList.add(meal);
      filteredFoodList = foodList;
      notifyListeners();
    } catch (error) {
      pop();
      showDialog(
          context: navigationKey.currentContext!,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text(error.toString()),
              ));
    }
  }
}

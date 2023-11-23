import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/nutrition_classes.dart';
import 'package:tamrini/model/nutritional.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:uuid/uuid.dart';

import '../utils/helper_functions.dart';

class NutritionalValueProvider extends ChangeNotifier {
  bool isLoading = false;
  double protein = 0.0;
  double fat = 0.0;
  double carbs = 0.0;
  double calories = 0.0;
  List<Nutritious> _nutritiousList = [], nutritiousList = [];
  List<NutritionClasses> _nutritionClassesList = [], nutritionClassesList = [];
  Nutritious nutritiousAdded = Nutritious(
      title: tr('pick_meal'),
      // title: "اختر الوجبة",
      calories: 0.0,
      proteins: 0.0,
      fats: 0.0,
      carbs: 0.0,
      classification: "",
      id: "id");

  NutritionClasses nutritionClassesAdded =
      NutritionClasses(classification: '', id: '');

  bool isInitiated = false;
  bool isClassesInitiated = false;

  int selectedClass = 0;

  // List<String> nutrientsClassificationsList = [
  //   NutritiousClasses.dairyAndEggs,
  //   NutritiousClasses.fatsAndOils,
  //   NutritiousClasses.soupsAndBroths,
  //   NutritiousClasses.breakfastCereals,
  //   NutritiousClasses.vegetables,
  //   NutritiousClasses.beefProducts,
  //   NutritiousClasses.seafood,
  //   NutritiousClasses.lambAndVeal,
  //   NutritiousClasses.desserts,
  //   NutritiousClasses.fastFood,
  //   NutritiousClasses.snacks,
  //   NutritiousClasses.herbsAndSpices,
  //   NutritiousClasses.poultryProducts,
  //   NutritiousClasses.processedMeats,
  //   NutritiousClasses.fruitsAndJuices,
  //   NutritiousClasses.nutsAndSeeds,
  //   NutritiousClasses.beverages,
  //   NutritiousClasses.legumesAndDerivatives,
  //   NutritiousClasses.bakeryProducts,
  //   NutritiousClasses.grainsAndPasta,
  //   NutritiousClasses.mealsAppetizersSandwiches,
  // ];

  calculate({required Nutritious nutritious, required int weight}) {
    protein = nutritious.proteins * weight;
    fat = nutritious.fats * weight;
    carbs = nutritious.carbs * weight;
    calories = nutritious.calories * weight;
    notifyListeners();
  }

  search(String query) {
    if (query.isEmpty) {
      nutritiousList = _nutritiousList;
    } else {
      nutritiousList = _nutritiousList
          .where(
            (element) => HelperFunctions.matchesSearch(
              query.toLowerCase().split(" "),
              element.title,
            ),
          )
          .toList();
    }
    notifyListeners();
  }

  reset() {
    protein = 0.0;
    fat = 0.0;
    carbs = 0.0;
    calories = 0.0;
    notifyListeners();
  }

  // initiate() {
  //   if (isInitiated == true) _nutritiousList.clear();

  //   _nutritiousList.add(nutritiousAdded);

  //   try {
  //     FirebaseFirestore.instance
  //         .collection('nutritious')
  //         .doc('data')
  //         .collection('data')
  //         .orderBy('title', descending: false)
  //         .getSavy()
  //         .then((value) {
  //       for (var element in value.docs) {
  //         _nutritiousList.add(Nutritious.fromJson(
  //             element.data() as Map<String, dynamic>, element.id));
  //       }
  //       nutritiousList = _nutritiousList;

  //       print(nutritiousList.length);
  //     });
  //     isInitiated = true;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Start Nutritious
  initiate() async {
    if (isInitiated == true) _nutritiousList.clear();

    _nutritiousList.add(nutritiousAdded);

    try {
      await FirebaseFirestore.instance
          .collection('nutritious')
          .doc(nutritionClassesList[selectedClass].id)
          .collection('data')
          .orderBy('title', descending: false)
          .getSavy()
          .then((value) {
        for (var element in value.docs) {
          _nutritiousList.add(Nutritious.fromJson(
              element.data() as Map<String, dynamic>, element.id));
        }
        nutritiousList = _nutritiousList;
      });
      isInitiated = true;
      notifyListeners();
    } catch (e) {}
  }

  addNewNutritious(Nutritious nutritious) async {
    try {
      if (nutritious.proteins < 0.0 ||
          nutritious.fats < 0.0 ||
          nutritious.carbs < 0.0 ||
          nutritious.calories < 0.0) {
        showDialog(
            context: navigationKey.currentContext!,
            builder: (context) {
              return AlertDialog(
                title: Text(tr('wrong')),
                content: Text(tr('enter_data_correctly')),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(tr('ok')))
                ],
              );
            });
        return;
      }
      // await FirebaseFirestore.instance
      //     .collection('nutritious')
      //     .doc('data')
      //     .collection('data')
      //     .add(nutritious.toJson())
      //     .then((value) => nutritious.id = value.id);
//-------------------
      await FirebaseFirestore.instance
          .collection('nutritious')
          .doc(nutritionClassesList[selectedClass].id)
          .collection('data')
          .add(nutritious.toJson())
          .then((value) => nutritious.id = value.id);

//-------------------

      nutritiousList.add(nutritious);
      notifyListeners();
      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('added_successfully'),
          desc: tr('added_meal'),
          btnOkOnPress: () {
            pop();
          }).show();
    } catch (e) {}
  }

  deleteNutritious(Nutritious nutritious) async {
    try {
      await FirebaseFirestore.instance
          .collection('nutritious')
          .doc(nutritionClassesList[selectedClass].id)
          .collection('data')
          .doc(nutritious.id)
          .delete();

      AwesomeDialog(
              context: navigationKey.currentContext!,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              title: tr('delete_successfully'),
              desc: tr('delete_meal'),
              btnOkOnPress: () {
                // pop();
              })
          .show();

      nutritiousList.removeWhere((element) => nutritious.id == element.id);
      notifyListeners();
    } catch (e) {}
  }

  // updateNutritious(Nutritious nutritious) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('nutritious')
  //         .doc('data')
  //         .collection('data')
  //         .doc(nutritious.id)
  //         .update(nutritious.toJson());

  //     nutritiousList.removeWhere((element) => nutritious.id == element.id);
  //     nutritiousList.add(nutritious);
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

// End Nutritious
// Start Nutritious Class
// Generate Random Id
  String generateRandomId() {
    const uuid = Uuid();
    return uuid.v4();
  }

//Add New Nutritious Class
  addNewNutritiousClass(NutritionClasses nutritionClasses) async {
    isLoading = true;
    notifyListeners();
    try {
      String randId = generateRandomId();
      nutritionClasses.id = randId;
      await FirebaseFirestore.instance
          .collection('nutritious')
          .doc(randId)
          .set(nutritionClasses.toJson());

      nutritionClassesList.add(nutritionClasses);
      notifyListeners();
      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('added_successfully'),
          desc: tr('added_item'),
          btnOkOnPress: () {
            pop();
          }).show();
    } catch (e) {}
    isLoading = false;
    notifyListeners();
  }

  deleteNutritiousClass(NutritionClasses nutritionClasses) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('nutritious')
          .doc(nutritionClasses.id)
          .delete();

      AwesomeDialog(
              context: navigationKey.currentContext!,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              title: tr('delete_successfully'),
              desc: tr('deleted_item'),
              btnOkOnPress: () {
                // pop();
              })
          .show();

      nutritionClassesList
          .removeWhere((element) => nutritionClasses.id == element.id);
      notifyListeners();
    } catch (e) {}
    isLoading = false;
    notifyListeners();
  }

  updateNutritiousClassName(NutritionClasses nutritionClasses) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('nutritious')
          .doc(nutritionClasses.id)
          .update(nutritionClasses.toJson());

      nutritionClassesList
          .removeWhere((element) => nutritionClasses.id == element.id);
      nutritionClassesList.add(nutritionClasses);
      notifyListeners();
      AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: tr('added_successfully'),
          desc: tr('added_item'),
          btnOkOnPress: () {
            pop();
          }).show();
    } catch (e) {}
    isLoading = false;
    notifyListeners();
  }

  initiateClasses() async {
    isLoading = true;
    notifyListeners();
    _nutritionClassesList.clear();
    if (isClassesInitiated == true) _nutritionClassesList.clear();

    // _nutritionClassesList.add(nutritiousAdded);

    try {
      await FirebaseFirestore.instance
          .collection('nutritious')
          .orderBy('classification', descending: false)
          .getSavy()
          .then((value) {
        for (var element in value.docs) {
          _nutritionClassesList.add(NutritionClasses.fromJson(
              element.data() as Map<String, dynamic>));
        }
        nutritionClassesList = _nutritionClassesList;
      });
      isInitiated = true;
    } catch (e) {}
    isLoading = false;
    notifyListeners();
  }
// End Nutritious Class
}

import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/supplement.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/trainer_screens/add_trainee_supplement_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../screens/supplement_screens/supplement_Articles_Screen.dart';
import '../utils/helper_functions.dart';
import 'Upload_Image_provider.dart';

class SupplementProvider extends ChangeNotifier {
  List<Supplement> supplements = [];
  List<Supplement> _OriginalSupplements = [];
  Supplement allSupplements = Supplement(data: [], id: ''),
      _OriginalAllSupplements = Supplement(data: [], id: '');

  UserProvider userProvider = UserProvider();
  bool isLoading = true;
  List<SupplementData> selectedSupplement = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchAndSetSupplements() async {
    try {
      isLoading = true;
      FirebaseFirestore.instance
          .collection('supplements')
          .doc('data')
          .collection('data')
          .getSavy()
          .then((event) {
        supplements = event.docs
            .map((e) =>
                Supplement.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        print('supplements fetched ${supplements.length}');
        isLoading = false;
        _OriginalSupplements = supplements;

        allSupplements.data = [];
        for (var element in supplements) {
          allSupplements.data!.addAll(element.data!);
        }
        _OriginalAllSupplements = allSupplements;
        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      print(error);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('error'),
        desc: tr('wrong'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  SelectSupplement(Supplement supplement, bool? canAddSupplementToTrainee) {
    selectedSupplement = supplement.data!;
    notifyListeners();
    canAddSupplementToTrainee == true
        ? To(AddTraineeSupplementScreen(
            supplement: supplement,
            isAll: false,
          ))
        : To(SupplementArticlesScreen(supplement: supplement));
  }

  searchAll() {
    if (searchController.text.isEmpty) {
      selectedSupplement = allSupplements.data!;
      notifyListeners();
      return;
    }
    selectedSupplement = allSupplements.data!
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
      selectedSupplement =
          _OriginalSupplements.where((element) => element.title == title)
              .first
              .data!;
      notifyListeners();
      return;
    }
    selectedSupplement =
        _OriginalSupplements.where((element) => element.title == title)
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
    selectedSupplement = _OriginalAllSupplements.data!;
  }

  Future<void> addCategory(
      {required String title, required String image}) async {
    showLoaderDialog(navigationKey.currentContext!);

    try {
      showLoaderDialog(navigationKey.currentContext!);
      FirebaseFirestore.instance
          .collection('supplements')
          .doc('data')
          .collection('data')
          .add({"title": title, "image": image, "data": []}).then((value) {
        supplements.add(
            Supplement(title: title, image: image, data: [], id: value.id));
        notifyListeners();
        _OriginalSupplements = supplements;

        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.scale,
          title: tr('done'),
          desc: tr('added_successfully'),
          btnOkOnPress: () {
            pop();
            pop();
          },
        ).show();
      });
    } catch (e) {
      print(e);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('error'),
        desc: tr('wrong'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future<void> addSupplement(
      {required SupplementData supplement,
      required Supplement category}) async {
    try {
      log('supplement id ${supplement.id}');
      log('category id ${category.id}');
      supplement.id = DateTime.now().millisecond.toString() + category.id!;
      showLoaderDialog(navigationKey.currentContext!);
      log('supplement id ${supplement.id}');

      FirebaseFirestore.instance
          .collection('supplements')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        "data": FieldValue.arrayUnion([
          supplement.toJson(),
        ])
      }).then((value) {
        supplements
            .firstWhere((element) => element.id == category.id)
            .data!
            .add(supplement);
        _OriginalSupplements = supplements;
        notifyListeners();

        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.SUCCES,
          animType: AnimType.scale,
          title: tr('done'),
          desc: tr('added_successfully'),
          btnOkOnPress: () {
            pop();
          },
        ).show();
      });
    } catch (e) {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('error'),
        desc: tr('wrong'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
      print(e);
    }
  }

  Future<void> deleteCategory({required Supplement category}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      FirebaseFirestore.instance
          .collection('supplements')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .delete()
          .then((value) async {
        supplements.removeWhere((element) => element.id == category.id);

        await UploadProvider().deleteAllAssets([category.image!]);

        for (var item in category.data!) {
          await UploadProvider().deleteAllAssets(item.images!);
        }

        _OriginalSupplements = supplements;
        notifyListeners();
        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: tr('successfully'),
          desc: tr('delete_successfully'),
          btnOkOnPress: () {},
        ).show();
      });
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('error'),
        desc: tr('wrong'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> deleteSupplement(
      {required SupplementData supplement,
      required Supplement category}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      supplements
          .firstWhere((element) => element.id == category.id)
          .data!
          .removeWhere((element) => element.id == supplement.id);
      FirebaseFirestore.instance
          .collection('supplements')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        "data": supplements
            .firstWhere((element) => element.id == category.id)
            .data!
            .map((e) => e.toJson())
            .toList()
      }).then((value) async {
        await UploadProvider().deleteAllAssets(supplement.images!);

        _OriginalSupplements = supplements;
        notifyListeners();

        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: tr('successfully'),
          desc: tr('delete_successfully'),
          btnOkOnPress: () {
            pop();
          },
        ).show();
      });
    } catch (e) {
      print(e);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('error'),
        desc: tr('wrong'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future<void> editSupplement({
    required Supplement category,
    required SupplementData supplement,
  }) async {
    showLoaderDialog(navigationKey.currentContext!);

    var oldImages = supplements
        .firstWhere((element) => element.id == category.id)
        .data!
        .firstWhere((element) => element.id == supplement.id)
        .images;

    supplements
        .firstWhere((element) => element.id == category.id)
        .data!
        .removeWhere((element) => element.id == supplement.id);

    supplements
        .firstWhere((element) => element.id == category.id)
        .data!
        .add(supplement);

    try {
      FirebaseFirestore.instance
          .collection('supplements')
          .doc('data')
          .collection('data')
          .doc(category.id)
          .update({
        'data': supplements
            .firstWhere((element) => element.id == category.id)
            .data!
            .map((e) => e.toJson())
            .toList()
      }).then((value) async {
        await UploadProvider().deleteOldImages(
            oldImages: oldImages!, newImages: supplement.images!);

        pop();
        _OriginalSupplements = supplements;

        notifyListeners();

        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.scale,
          title: tr('successfully'),
          desc: tr('modified_successfully'),
          btnOkOnPress: () {
            pop();
          },
        ).show().then((value) => pop());
      });
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('error'),
        desc: tr('wrong'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future<void> editCategory(
      {required String title,
      required String image,
      required String oldTitle}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      var oldImage =
          supplements.firstWhere((element) => element.title == oldTitle).image;
      FirebaseFirestore.instance
          .collection('supplements')
          .doc('data')
          .collection('data')
          .where('title', isEqualTo: oldTitle)
          .getSavy()
          .then((value) {
        value.docs.first.reference.update({
          "title": title,
          "image": image,
        }).then((value) async {
          if (oldImage != image) {
            await FirebaseStorage.instance
                .ref(oldImage!.split('tamrini-app.appspot.com/')[1])
                .delete();
          }
          supplements.firstWhere((element) => element.title == oldTitle).title =
              title;
          supplements.firstWhere((element) => element.title == oldTitle).image =
              image;
          notifyListeners();
          _OriginalSupplements = supplements;
        });
      });
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: tr('successfully'),
        desc: tr('modified_successfully'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: tr('error'),
        desc: tr('wrong'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }
}

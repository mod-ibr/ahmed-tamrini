import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../utils/helper_functions.dart';

class PublisherProvider extends ChangeNotifier {
  List<User> publishers = [], _originalPublishers = [], pendingPublishers = [];

  UserProvider? user;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  initiate(UserProvider user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> fetchAndSetPublishers() async {
    try {
      isLoading = true;
      log("####### LOADING");
      await FirebaseFirestore.instance
          .collection('users')
          .where('isPublisher', isEqualTo: true)
          .getSavy()
          .then((event) {
        debugPrint('--- inside fetch Publisher ---');
        publishers = event.docs
            .map((e) => User.fromMap(e.data() as Map<String, dynamic>, e.id))
            .toList();
        _originalPublishers = publishers;

        isLoading = false;
        notifyListeners();
        log("####### FINISHED");
      });
    } catch (error) {
      isLoading = false;
      debugPrint(error.toString());
    }
  }

  Future<void> subscribeAsPublisher(User publisher) async {
    if (user!.isPublisher || user!.isAdmin) return;
    try {
      publisher.uid = user!.user.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc('pendingPublishers')
          .collection('data')
          .doc(publisher.uid)
          .set(publisher.toMap());
      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('success_data_sent'),
        desc: tr('contact_soon'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (error) {
      debugPrint(error.toString());

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('try_again'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> updatePublisherData(User publisher) async {
    publisher.isPublisher = false;
    publisher.uid = user!.user.uid;

    log("************* Start Update Publisher Data");
    try {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: tr('current_publisher_will_be_deleted'),
        btnCancelOnPress: () {
          return;
        },
        btnOkOnPress: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc('pendingPublishers')
              .collection('data')
              .doc(publisher.uid)
              .set(publisher.toMap())
              .then((value) => log('Publisher is Pending Now'));
          await FirebaseFirestore.instance
              .collection('users')
              .doc(publisher.uid)
              .get()
              .then((value) async {
            if (value.exists) {
              value.reference.update({
                "isPublisher": false,
                'publisherSummary': FieldValue.delete()
              });
              log('Publisher is remove from Publishers List till approved again');
            }
          });
          log("publisher Id : ${publisher.uid}");

          publishers.remove(publisher);
          _originalPublishers.remove(publisher);
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('delete_successfully'),
            desc: tr('publisher_deleted_successfully'),
            btnOkOnPress: () {
              pop();
            },
          ).show();
        },
      ).show();
    } catch (error) {
      debugPrint(error.toString());

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('try_again'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> deletePublisher(User publisher) async {
    if (!user!.isAdmin) return;
    try {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: tr('publisher_will_be_deleted'),
        btnCancelOnPress: () {
          return;
        },
        btnOkOnPress: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(publisher.uid)
              .update({
            "isPublisher": false,
            'publisherSummary': FieldValue.delete()
          });

          log("publisher Id : ${publisher.uid}");

          publishers.remove(publisher);
          _originalPublishers.remove(publisher);
          notifyListeners();

          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('delete_successfully'),
            desc: tr('publisher_deleted_successfully'),
            btnOkOnPress: () {},
          ).show();
        },
      ).show();
    } catch (error) {
      log(error.toString());

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('try_again'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  searchPublisher() {
    if (searchController.text.isEmpty ||
        searchController.text == '' ||
        searchController.text == ' ') {
      publishers = _originalPublishers;
      notifyListeners();
      return;
    }
    publishers = _originalPublishers
        .where(
          (element) => HelperFunctions.matchesSearch(
            searchController.text.toLowerCase().split(" "),
            element.name,
          ),
        )
        .toList();
    notifyListeners();
  }

  clearSearch() {
    publishers = _originalPublishers;
    searchController.clear();
  }

  /// Use this method to get pending publishers for Admin only
  Future<void> fetchAndSetPendingPublishers() async {
    if (!user!.isAdmin) return;
    try {
      isLoading = true;
      FirebaseFirestore.instance
          .collection('users')
          .doc('pendingPublishers')
          .collection('data')
          .getSavy()
          .then((event) {
        pendingPublishers = event.docs.map((e) {
          log("******************** " +
              e.data().toString() +
              " ,  ID : " +
              e.id);
          return User.fromMap(e.data() as Map<String, dynamic>, e.id);
        }).toList();
        isLoading = false;
        notifyListeners();
      });
    } catch (error) {
      isLoading = false;

      debugPrint(error.toString());
    }
  }

  Future<void> acceptPublisher(User publisher) async {
    if (!user!.isAdmin) return;
    try {
      publisher.isPublisher = true;
      log(publisher.toMap().toString());
      showLoaderDialog(navigationKey.currentContext!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(publisher.uid)
          .update(publisher.toMap());

      await FirebaseFirestore.instance
          .collection('users')
          .doc('pendingPublishers')
          .collection('data')
          .doc(publisher.uid)
          .delete();

      pop();

      pendingPublishers.remove(publisher);
      publishers.add(publisher);
      _originalPublishers.add(publisher);
      notifyListeners();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accepted_successfully'),
        desc: tr('publisher_accepted_successfully'),
        btnOkOnPress: () {},
      ).show();
    } catch (error) {
      debugPrint(error.toString());

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('try_again'),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<void> rejectPublisher(User publisher) async {
    try {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: tr('publisher_will_be_rejected'),
        btnCancelOnPress: () {
          return;
        },
        btnOkOnPress: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc('pendingPublishers')
              .collection('data')
              .doc(publisher.uid)
              .delete();

          pendingPublishers.remove(publisher);
          notifyListeners();
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('rejected_successfully'),
            desc: tr('publisher_rejected_successfully'),
            btnOkOnPress: () {},
          ).show();
        },
      ).show();
    } catch (error) {
      log(' ******************* ERROR While Reject : ${error.toString()}');
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('try_again'),
        btnOkOnPress: () {},
      ).show();
    }
  }
}

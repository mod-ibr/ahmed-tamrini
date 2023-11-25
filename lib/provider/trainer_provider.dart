import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../model/trainee.dart';
import '../utils/helper_functions.dart';
import 'Upload_Image_provider.dart';

class TrainerProvider extends ChangeNotifier {
  List<User> trainers = [], _originalTrainers = [], pendingTrainers = [];
  Trainee? selectedTrainee;

  UserProvider? user;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  initiate(UserProvider user) {
    this.user = user;
    debugPrint('initiate trainer provider');
    debugPrint(user.user.role);

    notifyListeners();
  }

  Future<void> fetchAndSetTrainers() async {
    try {
      isLoading = true;
      log("####### LOADING");
      await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'captain')
          .getSavy()
          .then((event) {
        debugPrint('--- inside fetch trainer ---');
        trainers = event.docs
            .map((e) => User.fromMap(e.data() as Map<String, dynamic>, e.id))
            .toList();
        _originalTrainers = trainers;

        isLoading = false;
        notifyListeners();
        log("####### FINISHED");
      });
    } catch (error) {
      isLoading = false;
      debugPrint(error.toString());
    }
  }

  Future<void> subscribeAsTrainer(User trainer) async {
    if (user!.isCaptain || user!.isAdmin) return;
    try {
      trainer.uid = user!.user.uid;
      trainer.role = 'user';
      // trainer.uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc('pending')
          .collection('data')
          .doc(trainer.uid)
          .set(trainer.toMap());
      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('subscribed_successfully'),
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

  Future<void> updateTrainerData(User trainer) async {
    log("************* Start Update Trainer Data");
    try {
      trainer.uid = user!.user.uid;
      trainer.role = 'user';
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: tr('current_trainer_will_be_deleted'),
        btnCancelOnPress: () {
          return;
        },
        btnOkOnPress: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc('pending')
              .collection('data')
              .doc(trainer.uid)
              .set(trainer.toMap())
              .then((value) => log('Trainer is Pending Now'));

          // await UploadProvider().deleteAllAssets(trainer.gallery!);
          // await UploadProvider().deleteAllAssets(trainer.gymImage!);

          // await deleteTrainerDataFromTrainee(trainer.uid);
          // await decrementTraineesCount(trainer.uid);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(trainer.uid)
              .get()
              .then((value) async {
            if (value.exists) {
              value.reference
                  .update({'role': 'user', 'questions': FieldValue.delete()});
              log('Trainer is remove from trainers List till approved again');
            }
          });
          trainers.remove(trainer);
          _originalTrainers.remove(trainer);

          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('subscribed_successfully'),
            desc: tr('contact_soon'),
            btnOkOnPress: () {
              pop();
              pop();
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

  searchTrainer() {
    if (searchController.text.isEmpty ||
        searchController.text == '' ||
        searchController.text == ' ') {
      trainers = _originalTrainers;
      notifyListeners();
      return;
    }
    trainers = _originalTrainers
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
    trainers = _originalTrainers;
    searchController.clear();
  }

  Future<void> deleteTrainerDataFromTrainee(String trainerID) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      // get each trainee subscribed for a trainer by trainer Id
      final QuerySnapshot querySnapshot = await firestore
          .collection('trainees')
          .where('trainerID', isEqualTo: trainerID)
          .get();
      // looping over all trainees to delete the trainer data in the trainee document , and got to the trainee user data to make the isSubscribedToTrainer equal false
      for (var doc in querySnapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('uid') && data.containsKey('trainerID')) {
          final String traineeUID = data['uid'] as String;

          // delete the Trainer Data in trainee collection
          final DocumentReference traineeDocRef =
              firestore.collection('trainees').doc(doc.id);
          await traineeDocRef.update({'trainerID': FieldValue.delete()});

          // set the trainer trainees Count to zero
          await FirebaseFirestore.instance
              .collection('users')
              .doc(trainerID)
              .update({'traineesCount': 0});

          // update to trainee data in user collection to make the isSubscribedToTrainer equal false
          await firestore
              .collection('users')
              .doc(traineeUID)
              .update({"isSubscribedToTrainer": false});
        } else {
          log('Document ID: ${doc.id} does not contain trainerID failed field.');
        }
      }
    } catch (error) {
      log('Error fetching documents: $error');
      rethrow;
    }
  }

  Future<void> decrementTraineesCount(String trainerID) async {
    try {
      final DocumentReference trainerDocRef =
          FirebaseFirestore.instance.collection('users').doc(trainerID);
      final DocumentSnapshot trainerDocSnapshot = await trainerDocRef.get();

      if (trainerDocSnapshot.exists) {
        final int currentTraineesCount =
            trainerDocSnapshot['traineesCount'] ?? 0;

        if (currentTraineesCount >= 1) {
          final int newTraineesCount = currentTraineesCount - 1;

          await trainerDocRef.update({'traineesCount': newTraineesCount});

          log('Trainees count decremented to $newTraineesCount for trainer with ID: $trainerID');
        } else {
          log('Trainees count is already 1 or less, no decrement needed for trainer with ID: $trainerID');
        }
      } else {
        log('Trainer document not found for ID: $trainerID');
      }
    } catch (error) {
      log('Error: $error');
    }
  }

  Future<void> deleteTrainer(User trainer) async {
    if (!user!.isAdmin) return;
    try {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: tr('trainer_deleted_permanently'),
        btnCancelOnPress: () {
          return;
        },
        btnOkOnPress: () async {
          // // var data = trainer.image;
          // FirebaseFirestore.instance
          //     .collection('users')
          //     .doc('data')
          //     .collection('data')
          //     .where('uid', isEqualTo: trainer.uid)
          //     .getSavy()
          //     .then((value) async {
          // await UploadProvider().deleteAllAssets([data!]);

          //   value.docs.first.reference.delete();
          // });
          await UploadProvider().deleteAllAssets(trainer.gallery!);
          await UploadProvider().deleteAllAssets(trainer.gymImage!);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(trainer.uid)
              .update({
            'role': 'user',
            'gallery': [],
            'gymImage': [],
            'questions': FieldValue.delete()
          });

          log("Trainer Id : ${trainer.uid}");
          await deleteTrainerDataFromTrainee(trainer.uid);
          await decrementTraineesCount(trainer.uid);
          trainers.remove(trainer);
          _originalTrainers.remove(trainer);
          notifyListeners();

          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('delete_successfully'),
            desc: tr('trainer_deleted_successfully'),
            btnOkOnPress: () {},
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

  Future<void> fetchAndSetPendingTrainers() async {
    if (!user!.isAdmin) return;
    try {
      log('************************ ANA ADMIN');
      isLoading = true;
      FirebaseFirestore.instance
          .collection('users')
          .doc('pending')
          .collection('data')
          .getSavy()
          .then((event) {
        pendingTrainers = event.docs.map((e) {
          debugPrint("******************** " +
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

  Future<void> acceptTrainer(User trainer) async {
    if (!user!.isAdmin) return;
    try {
      trainer.traineesCount = 0;
      trainer.role = 'captain';
      debugPrint(trainer.toMap().toString());
      showLoaderDialog(navigationKey.currentContext!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(trainer.uid)
          .update(trainer.toMap());

      await FirebaseFirestore.instance
          .collection('users')
          .doc('pending')
          .collection('data')
          .doc(trainer.uid)
          .delete();

      pop();

      pendingTrainers.remove(trainer);
      trainers.add(trainer);
      _originalTrainers.add(trainer);
      notifyListeners();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accepted_successfully'),
        desc: tr('accepted_trainer_successfully'),
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

  Future<void> rejectTrainer(User trainer) async {
    try {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: tr('rejected_coach'),
        btnCancelOnPress: () {
          return;
        },
        btnOkOnPress: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc('pending')
              .collection('data')
              .doc(trainer.uid)
              .delete();

          pendingTrainers.remove(trainer);
          notifyListeners();
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('rejected_successfully'),
            desc: tr('rejected_trainer_successfully'),
            btnOkOnPress: () {},
          ).show();
        },
      ).show();
    } catch (error) {
      debugPrint(error.toString());
      print(' ******************* ERROR While Reject');
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

//TODO: To  Edit Trainer Data
/*
  Future<void> editTrainerData(Trainer trainer) async {
    if (!user!.isCaptain) return;
    try {
      var oldImage =
          trainers.firstWhere((element) => element.uid == trainer.uid).image;
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: 'سيتم تعديل بيانات المدرب',
        btnCancelOnPress: () {
          return;
        },
        btnOkOnPress: () {
          FirebaseFirestore.instance
              .collection('trainers')
              .doc('data')
              .collection('data')
              .where('uid', isEqualTo: trainer.uid)
              .getSavy()
              .then((value) async {
            if (oldImage != trainer.image) {
              await UploadProvider().deleteAllAssets([oldImage!]);
            }
            value.docs.first.reference.update(trainer.toJson());

            trainers.removeWhere((element) => element.uid == trainer.uid);
            trainers.add(trainer);
            _originalTrainers = trainers;
            notifyListeners();
          });
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('modified_successfully'),
            desc: 'تم تعديل بيانات المدرب بنجاح',
            btnOkOnPress: () {},
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
*/
  /// ------------------------  trainee Part  ------------------------ ///
  ///
  ///
  FollowUpData addFollowUpToTrainee(List questions, List answers, List images) {
    if (answers.length != questions.length) {
      throw Exception("answers.length != questions.length");
    }
    var followUpData = [];
    for (int i = 0; i < questions.length; i++) {
      followUpData.add({
        "question": questions[i],
        "answer": answers[i],
      });
    }
    var data = FollowUpData(
      createdAt: Timestamp.now(),
      followUpData: followUpData.cast(),
      images: images.cast<String>(),
    );
    log(data.toJson().toString());
    return data;
  }

  Future<void> subscribeToTrainer(
      {required User trainer,
      required List answers,
      required List images}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      var traineeData = Trainee(
        name: user!.user.name,
        number: user!.user.phone,
        username: user!.user.username,
        uid: user!.user.uid,
        age: user!.user.age,
        gender: user!.user.gender,
        followUpList: [
          addFollowUpToTrainee(trainer.questions!, answers, images)
        ],
      ).toJson();

      traineeData['trainerID'] = trainer.uid;
      await FirebaseFirestore.instance
          .collection('trainees')
          .doc('pending')
          .collection('data')
          .add(traineeData);

      pop();

      notifyListeners();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('request_sent_successfully'),
        desc: tr('contact_trainer'),
        btnOkOnPress: () {
          pop();
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

  Future<void> addToGallery(User trainer, List<String> images) async {
    if (!user!.isCaptain) return;
    try {
      // var data = TrainerGalleryItem(
      //   createdAt: Timestamp.now(),
      //   before: images[0],
      //   after: images[1],
      // );
      List<String>? _allImages = trainer.gallery;
      _allImages?.addAll(images);
      FirebaseFirestore.instance
          .collection('users')
          .doc(trainer.uid)
          .update({'gallery': _allImages}).then((value) async {
        notifyListeners();
        fetchAndSetTrainers();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('accomplished_successfully'),
          desc: tr('work_added'),
          btnOkOnPress: () {
            pop();
          },
        ).show();
      });
      //
      // trainers.removeWhere((element) => element.uid == trainer.uid);
      // trainers.add(trainer);
      // _originalTrainers = trainers;

      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(trainer.uid)
      //     .update({'gallery': images}).then((value) {
      //   notifyListeners();
      //   fetchAndSetTrainers();
      //   AwesomeDialog(
      //     context: navigationKey.currentContext!,
      //     dialogType: DialogType.success,
      //     animType: AnimType.bottomSlide,
      //     title: tr('accomplished_successfully'),
      //     desc: tr('work_added'),
      //     btnOkOnPress: () {
      //       pop();
      //     },
      //   ).show();
      // });
    } catch (error) {
      debugPrint(error.toString());
      pop();
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

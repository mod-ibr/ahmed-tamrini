import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/model/supplement.dart' as supplement;
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/provider/supplement_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../model/trainee_exercise.dart';
import '../model/user.dart';
import '../utils/helper_functions.dart';
import 'Upload_Image_provider.dart';

class TraineeProvider extends ChangeNotifier {
  List<Trainee> trainees = [],
      _originalTrainees = [],
      pendingTrainees = [],
      _originalPendingTrainees = [];

  TextEditingController notesController = TextEditingController();

  UserProvider userProvider = UserProvider();
  ExerciseProvider exerciseProvider = ExerciseProvider();
  SupplementProvider supplementProvider = SupplementProvider();

  List<supplement.SupplementData> supplements = [];

  Course newCourse = Course(
      dayWeekExercises: DayWeekExercises(
        mon: [],
        tue: [],
        wed: [],
        thurs: [],
        fri: [],
        sat: [],
        sun: [],
      ),
      createdAt: Timestamp.now());
  Map<String, List<TraineeExercise>> newDayWeekExercises = {
    'mon': [],
    'tue': [],
    'wed': [],
    'thurs': [],
    'fri': [],
    'sat': [],
    'sun': [],
  };

  User? trainer;
  Trainee? selectedTrainee;

  Trainee? traineeData;
  var isLoading = false;

  initiate(UserProvider userProvider, ExerciseProvider exerciseProvider,
      SupplementProvider supplementProvider) async {
    if (userProvider.isAdmin || userProvider.isCaptain) {
      this.userProvider = userProvider;
      this.exerciseProvider = exerciseProvider;
      this.supplementProvider = supplementProvider;
      log("initiate trainee provider as admin or captain");
      fetchAndSetTrainees();
    } else {
      this.userProvider = userProvider;
      this.exerciseProvider = exerciseProvider;
      this.supplementProvider = supplementProvider;
      log("initiate trainee provider as trainer");

      fetchAndSetTraineeData();
    }
  }

  Future<void> fetchAndSetTrainees() async {
    isLoading = true;
    try {
      FirebaseFirestore.instance
          .collection('trainees')
          .where('trainerID', isEqualTo: userProvider.user.uid)
          .getSavy()
          .then((event) {
        trainees.clear();
        _originalTrainees.clear();
        for (var i in event.docs) {
          log(i.data().toString());
          var trainee = Trainee.fromJson(
            i.data() as Map<String, dynamic>,
            exerciseProvider.allExercises.data!,
            supplementProvider.allSupplements.data!,
          );

          _originalTrainees.add(trainee);
        }
        trainees = _originalTrainees;
        log("trainees: ${trainees.length}" +
            " " +
            "original: ${_originalTrainees.length}");
        isLoading = false;

        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      print(error);
    }
  }

  Future<void> fetchAndSetPendingTrainees() async {
    isLoading = true;
    try {
      FirebaseFirestore.instance
          .collection('trainees')
          .doc('pending')
          .collection('data')
          .where('trainerID', isEqualTo: userProvider.user.uid)
          .getSavy()
          .then((event) {
        pendingTrainees = event.docs
            .map((e) => Trainee.fromJson(
                e.data() as Map<String, dynamic>,
                exerciseProvider.allExercises.data!,
                supplementProvider.allSupplements.data!))
            .toList();
        isLoading = false;
        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      print(error);
    }
  }

  searchTrainees(String query) {
    if (query.isEmpty) {
      trainees = _originalTrainees;
    } else {
      trainees = _originalTrainees
          .where(
            (element) => HelperFunctions.matchesSearch(
              query.toLowerCase().split(" "),
              element.name!,
            ),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> acceptTrainee(Trainee trainee) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      trainee.dateOfSubscription = Timestamp.now();
      trainee.courses = [];

      var data = trainee.toJson();

      data['trainerID'] = userProvider.user.uid;

      await FirebaseFirestore.instance
          .collection('trainees')
          .doc('pending')
          .collection('data')
          .where('uid', isEqualTo: trainee.uid)
          .where('trainerID', isEqualTo: userProvider.user.uid)
          .getSavy()
          .then((event) {
        event.docs.forEach((element) {
          element.reference.delete();
          pendingTrainees
              .where((eleme) => eleme.uid == (element.data()! as Map)['uid'])
              .toList()
              .forEach((element) {
            pendingTrainees.remove(element);
          });
        });
      });

      await FirebaseFirestore.instance.collection('trainees').doc().set(data);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProvider.user.uid)
          .update({'traineesCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(trainee.uid)
          .update({'isSubscribedToTrainer': true});

      pop();

      trainees.add(trainee);

      notifyListeners();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accomplished_successfully'),
        desc: tr('trainee_added_successfully'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (error) {
      print(error);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('error_occurred_trainee_added'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  Future<void> rejectTrainee(Trainee trainee) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      await FirebaseFirestore.instance
          .collection('trainees')
          .doc('pending')
          .collection('data')
          .where('uid', isEqualTo: trainee.uid)
          .where('trainerID', isEqualTo: userProvider.user.uid)
          .getSavy()
          .then((event) {
        event.docs.forEach((element) async {
          element.reference.delete();
          for (var i in (element.data()! as Map)['followUpList']) {
            await UploadProvider().deleteAllAssets(i['images'].cast<String>());

            // if (i.uid == trainee.uid) {
            //   pendingTrainees.remove(i);
            // }
          }
          pendingTrainees
              .where((eleme) => eleme.uid == (element.data()! as Map)['uid'])
              .toList()
              .forEach((element) {
            pendingTrainees.remove(element);
          });
        });
      });

      // delete image from storage using download url

      pop();

      notifyListeners();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accomplished_successfully'),
        desc: tr('trainee_rejected_successfully'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (error) {
      print(error);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('error_occurred_trainee_rejected'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  // Future<void> deleteTrainee(Trainee trainee) async {
  //   try {
  //     showLoaderDialog(navigationKey.currentContext!);

  //     await FirebaseFirestore.instance
  //         .collection('trainees')
  //         .doc('data')
  //         .collection('data')
  //         .where('uid', isEqualTo: trainee.uid)
  //         .where('trainerID', isEqualTo: userProvider.user.uid)
  //         .getSavy()
  //         .then((event) {
  //       event.docs.forEach((element) {
  //         element.reference.delete();
  //       });
  //     });

  //     pop();

  //     trainees.remove(trainee);

  //     notifyListeners();

  //     AwesomeDialog(
  //       context: navigationKey.currentContext!,
  //       dialogType: DialogType.success,
  //       animType: AnimType.bottomSlide,
  //       title: tr('accomplished_successfully'),
  //       desc: 'تم حذف المتدرب بنجاح',
  //       btnOkOnPress: () {
  //         pop();
  //       },
  //     ).show();
  //   } catch (error) {
  //     print(error);

  //     AwesomeDialog(
  //       context: navigationKey.currentContext!,
  //       dialogType: DialogType.error,
  //       animType: AnimType.bottomSlide,
  //       title: tr('wrong'),
  //       desc: 'حدث خطأ أثناء حذف المتدرب',
  //       btnOkOnPress: () {
  //         pop();
  //       },
  //     ).show();
  //   }
  // }

  Future<void> updateTrainee(Trainee trainee) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      await FirebaseFirestore.instance
          .collection('trainees')
          .doc('data')
          .collection('data')
          .where('uid', isEqualTo: trainee.uid)
          .where('trainerID', isEqualTo: userProvider.user.uid)
          .getSavy()
          .then((event) {
        event.docs.first.reference.update(trainee.toJson());
      });

      pop();

      print(trainee.toJson());

      trainees.removeWhere((element) => element.uid == trainee.uid);
      print("from update trainee" + trainees.length.toString());
      trainees.add(trainee);
      print("from update trainee" + trainees.length.toString());

      notifyListeners();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('accomplished_successfully'),
        desc: tr('trainee_data_updated_successfully'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (error) {
      print(error);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('error_occurred_trainee_data_updated'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    }
  }

  //TODO بتتحط لما اليوزر يشوف كورساته ونظامه
  Future<void> fetchAndSetTraineeData() {
    isLoading = true;

    try {
      if (userProvider.isCaptain) return Future.value();
      return FirebaseFirestore.instance
          .collection('trainees')
          .where('uid', isEqualTo: userProvider.user.uid)
          .getSavy()
          .then((value) {
        if (value.docs.isEmpty || value.docs == null) {
          isLoading = false;
          notifyListeners();
          return;
        }
        traineeData = Trainee.fromJson(
            value.docs.first.data() as Map<String, dynamic>,
            exerciseProvider.allExercises.data!,
            supplementProvider.allSupplements.data!);
        log("from fetch and set trainee data" +
            traineeData!.toJson().toString());
        isLoading = false;
        notifyListeners();
      });
    } catch (error) {
      isLoading = false;
      print(error);
      return Future.error(error);
    }
  }

  selectTrainee(Trainee trainee) {
    selectedTrainee = Trainee.fromJson(
        trainee.toJson(),
        exerciseProvider.allExercises.data!,
        supplementProvider.allSupplements.data!);
    notifyListeners();
    // To(trainee data page)
  }

  addSupplementToTrainee(supplement.SupplementData supplement) {
    if (!userProvider.isCaptain) return;
    supplements.add(supplement);

    notifyListeners();
  }

  removeSupplementFromTrainee(supplement.SupplementData supplement) {
    if (!userProvider.isCaptain) return;
    supplements.removeWhere((sup) => sup.id == supplement.id);
    notifyListeners();
  }

  addSuperSetToExercise(
      ExerciseData? exercise, ExerciseData? superSetExercise, String day) {
    switch (day) {
      case "sat":
        newCourse.dayWeekExercises!.sat!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        break;
      case "sun":
        newCourse.dayWeekExercises!.sun!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        break;
      case "mon":
        newCourse.dayWeekExercises!.mon!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        break;
      case "tue":
        newCourse.dayWeekExercises!.tue!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        break;
      case "wed":
        newCourse.dayWeekExercises!.wed!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        break;
      case "thurs":
        newCourse.dayWeekExercises!.thurs!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        break;
      case "fri":
        newCourse.dayWeekExercises!.fri!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = superSetExercise;
        break;
    }

    notifyListeners();
  }

  removeSuperSetFromExercise(ExerciseData? exercise, String day) {
    switch (day) {
      case "sat":
        newCourse.dayWeekExercises!.sat!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        break;
      case "sun":
        newCourse.dayWeekExercises!.sun!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        break;
      case "mon":
        newCourse.dayWeekExercises!.mon!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        break;
      case "tue":
        newCourse.dayWeekExercises!.tue!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        break;
      case "wed":
        newCourse.dayWeekExercises!.wed!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        break;
      case "thurs":
        newCourse.dayWeekExercises!.thurs!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        break;
      case "fri":
        newCourse.dayWeekExercises!.fri!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        newDayWeekExercises[day]!
            .firstWhere((traineeExercise) =>
                traineeExercise.exercise!.id == exercise!.id)
            .superSetExercise = null;
        break;
    }

    notifyListeners();
  }

  addExerciseToTrainee(TraineeExercise traineeExercise, String day) {
    if (!userProvider.isCaptain) return;

    newCourse.createdAt = Timestamp.now();

    print("from add exercise to trainee" + traineeExercise.exercise!.title!);

    switch (day) {
      case "sat":
        newCourse.dayWeekExercises!.sat!.add(traineeExercise);
        newDayWeekExercises[day]!.add(traineeExercise);
        break;
      case "sun":
        newCourse.dayWeekExercises!.sun!.add(traineeExercise);
        newDayWeekExercises[day]!.add(traineeExercise);
        break;
      case "mon":
        newCourse.dayWeekExercises!.mon!.add(traineeExercise);
        newDayWeekExercises[day]!.add(traineeExercise);
        break;
      case "tue":
        newCourse.dayWeekExercises!.tue!.add(traineeExercise);
        newDayWeekExercises[day]!.add(traineeExercise);
        break;
      case "wed":
        newCourse.dayWeekExercises!.wed!.add(traineeExercise);
        newDayWeekExercises[day]!.add(traineeExercise);
        break;
      case "thurs":
        newCourse.dayWeekExercises!.thurs!.add(traineeExercise);
        newDayWeekExercises[day]!.add(traineeExercise);
        break;
      case "fri":
        newCourse.dayWeekExercises!.fri!.add(traineeExercise);
        newDayWeekExercises[day]!.add(traineeExercise);
        break;
    }

    notifyListeners();
  }

  removeExerciseFromTrainee(ExerciseData exercise, String day) {
    if (!userProvider.isCaptain) return;

    print("removeExerciseFromTrainee");
    print(exercise.toJson());
    print(day);
    print(selectedTrainee!.toJson());

    switch (day) {
      case "sat":
        newCourse.dayWeekExercises!.sat!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        newDayWeekExercises[day]!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        break;
      case "sun":
        newCourse.dayWeekExercises!.sun!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        newDayWeekExercises[day]!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        break;
      case "mon":
        newCourse.dayWeekExercises!.mon!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        newDayWeekExercises[day]!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        break;
      case "tue":
        newCourse.dayWeekExercises!.tue!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        newDayWeekExercises[day]!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        break;
      case "wed":
        newCourse.dayWeekExercises!.wed!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        newDayWeekExercises[day]!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        break;
      case "thurs":
        newCourse.dayWeekExercises!.thurs!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        newDayWeekExercises[day]!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        break;
      case "fri":
        newCourse.dayWeekExercises!.fri!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        newDayWeekExercises[day]!.removeWhere(
            (traineeExercise) => traineeExercise.exercise == exercise);
        break;
    }

    notifyListeners();
  }

  addFoodToTrainee(Food food) async {
    if (!userProvider.isCaptain) return;
    print("addFoodToTrainee");
    print(selectedTrainee!.food!.length);

    food.createdAt = Timestamp.now();

    selectedTrainee!.food!.add(food);
    print(selectedTrainee!.food!.length);

    print(selectedTrainee!.toJson());
    // await saveChangedSelectedTraineeData();
    notifyListeners();
  }

  addSupplementsToTrainee() async {
    if (!userProvider.isCaptain) return;
    // print("addSupplementToTrainee");
    // print(selectedTrainee!.supplements!.length);
    //
    // selectedTrainee!.supplements!.addAll(supplements.map((s) => s));
    // print(selectedTrainee!.supplements!.length);
    //
    // print(selectedTrainee!.toJson());
    // await saveChangedSelectedTraineeData();
    List<supplement.SupplementData> localSupplements = [...supplements];
    if (selectedTrainee!.supplements != null &&
        selectedTrainee!.supplements!.isNotEmpty) {
      localSupplements.removeWhere((s) =>
          selectedTrainee!.supplements!.map((sup) => sup.id).contains(s.id));
    }
    selectedTrainee!.supplements!.addAll(localSupplements);
    notifyListeners();
  }

  Future<void> saveChangedSelectedTraineeData() async {
    if (!userProvider.isCaptain) return;
    try {
      print("saveChangedSelectedTraineeData");
      print(selectedTrainee!.food!.length);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('are_you_sure'),
        desc: tr('trainee_data_will_be_updated'),
        btnCancelOnPress: () {
          navigationKey.currentState!.pop();
          return;
        },
        btnOkOnPress: () {
          navigationKey.currentState!.pop();
          FirebaseFirestore.instance
              .collection('trainees')
              .where('uid', isEqualTo: selectedTrainee!.uid)
              .getSavy()
              .then((value) async {
            print("courses" + selectedTrainee!.courses.toString());
            print("supplements" + selectedTrainee!.supplements.toString());

            await FirebaseFirestore.instance
                .collection('trainees')
                .doc(value.docs.first.id)
                .update(selectedTrainee!.toJson());

            trainees
                .removeWhere((element) => element.uid == selectedTrainee!.uid);
            print("trainees.length: ${trainees.length}");

            trainees.add(selectedTrainee!);
            print("trainees.length: ${trainees.length}");
            notifyListeners();
          });
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: tr('modified_successfully'),
            desc: tr('trainee_data_updated_successfully'),
            btnOkOnPress: () {
              navigationKey.currentState!.pop();
              navigationKey.currentState!.pop();
            },
          ).show();
        },
      ).show();
    } catch (error) {
      print(error);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('try_again'),
        btnOkOnPress: () {
          navigationKey.currentState!.pop();
        },
      ).show();
    }
  }

  addFollowUpToTrainee({required String note, required List images}) async {
    if (userProvider.isCaptain) return;
    log("addFollowUpToTrainee");

    try {
      // showLoaderDialog(navigationKey.currentContext!);

      if (traineeData?.followUpList == null) {
        traineeData!.followUpList = [];
      }

      // if(traineeData!.followUpList!.last.createdAt!.toDate().isAfter(DateTime.now().subtract(Duration(days: 28)))){
      //  AwesomeDialog(
      //     context: navigationKey.currentContext!,
      //     dialogType: DialogType.warning,
      //     animType: AnimType.bottomSlide,
      //     title: 'تنبيه',
      //     desc: 'لا يمكنك اضافة ملاحظة جديدة لانها اقل من 28 يوم من الملاحظة السابقة',
      //     btnOkOnPress: () {
      //       navigationKey.currentState!.pop();
      //     },
      //   ).show();
      //   return;
      // }

      FollowUpData followUp = FollowUpData(
        followUpData: [
          {"question": "الملاحظات", "answer": note}
        ],
        images: images.cast<String>(),
        createdAt: Timestamp.now(),
      );

      await FirebaseFirestore.instance
          .collection('trainees')
          .where('uid', isEqualTo: traineeData!.uid)
          .getSavy()
          .then((value) async {
        log("courses" + followUp.toJson().toString());

        await FirebaseFirestore.instance
            .collection('trainees')
            .doc(value.docs.first.id)
            .update({
          "followUpList": FieldValue.arrayUnion([followUp.toJson()])
        });

        traineeData!.followUpList!.add(followUp);
        log("trainees.length: ${traineeData!.followUpList!.length}");
        notifyListeners();

        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('added_successfully'),
          desc: tr('note_added_successfully'),
          btnOkOnPress: () {
            pop();
          },
        ).show().then((value) => pop());
      });
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

  Future<void> getTrainerById(String trainerID) async {
    isLoading = true;
    notifyListeners();
    try {
      final DocumentReference trainerDocRef =
          FirebaseFirestore.instance.collection('users').doc(trainerID);
      final DocumentSnapshot trainerDocSnapshot = await trainerDocRef.get();

      if (trainerDocSnapshot.exists) {
        final Map<String, dynamic>? trainerData =
            trainerDocSnapshot.data() as Map<String, dynamic>?;
        if (trainerData != null) {
          trainer = User.fromMap(trainerData, trainerID);
          log("**************************************************************** Trainer Name :${trainer?.name}");
        } else {
          log('No data found in the Trainer document for ID: $trainerID');
        }
      } else {
        log('Can\'t get this Trainer, the document not found for ID: $trainerID');
      }
    } catch (error) {
      log('Error: $error');
    }
    isLoading = false;
    notifyListeners();
  }
}

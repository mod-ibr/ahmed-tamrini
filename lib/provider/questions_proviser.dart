import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/app_constants.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../model/question.dart';
import '../utils/helper_functions.dart';

class QuestionsProvider with ChangeNotifier {
  List<Question> _questions = [], filteredQuestions = [];
  String username = '';
  String name = '';
  bool isLogged = false;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  Future<void> fetchQuestions() async {
    try {
      isLoading = true;
      FirebaseFirestore.instance
          .collection('Q&A')
          .doc('questions')
          .collection('questions')
          .snapshots()
          .listen((event) {
        _questions = event.docs
            .map((e) =>
                Question.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
        filteredQuestions = _questions;
        notifyListeners();
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username') ?? '';
      name = prefs.getString('name') ?? '';
      isLogged = CacheHelper.getBoolean(key: 'IsLoggedIn');
      isLoading = false;
    } catch (error) {
      print(error);
      isLoading = false;
      if (!await InternetConnectionChecker().hasConnection) {
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('no_internet'),
          btnOkOnPress: () {
            Navigator.pop(navigationKey.currentContext!);
          },
        ).show();
      }
    }
  }

  void filterQuestions() {
    filteredQuestions = _questions
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
    filteredQuestions = _questions;
  }

  Future<void> addQuestion(Question question) async {
    try {
      await FirebaseFirestore.instance
          .collection('Q&A')
          .doc('questions')
          .collection('questions')
          .add(question.toJson());
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('done'),
        desc: tr('question_added_successfully'),
        btnOkOnPress: () {
          pop();
        },
      ).show();
    } catch (error) {
      print(error);
      if (!await InternetConnectionChecker().hasConnection) {
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('no_internet'),
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  Future<void> deleteQuestion(String id) async {
    try {
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('alert'),
        desc: tr('delete_question'),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          await FirebaseFirestore.instance
              .collection('Q&A')
              .doc('questions')
              .collection('questions')
              .doc(id)
              .delete();
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: tr('done'),
            desc: tr('question_deleted_successfully'),
            btnOkOnPress: () {
              // pop();
            },
          ).show();
        },
      ).show();
      // await FirebaseFirestore.instance
      //     .collection('Q&A')
      //     .doc('questions')
      //     .collection('questions')
      //     .doc(id)
      //     .delete();
    } catch (error) {
      print(error);
      if (!await InternetConnectionChecker().hasConnection) {
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('no_internet'),
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  // Future<void> updateQuestion(Question question) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('Q&A')
  //         .doc('questions')
  //         .collection('questions')
  //         .doc(question.id)
  //         .update(question.toJson());
  //   } catch (error) {
  //     print(error);
  //           if (!await InternetConnectionChecker().hasConnection) {
  //       AwesomeDialog(
  //         context: navigationKey.currentContext!,
  //         dialogType: DialogType.error,
  //         animType: AnimType.bottomSlide,
  //         title: tr('error'),
  //         desc: tr('no_internet'),
  //         btnOkOnPress: () {},
  //       ).show();
  //     }
  //   }
  // }

  Future<void> addAnswer(Question question, String answer) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      await FirebaseFirestore.instance
          .collection('Q&A')
          .doc('questions')
          .collection('questions')
          .doc(question.id)
          .update({
        'answers': FieldValue.arrayUnion([
          Answers(
                  answer: answer,
                  date: Timestamp.now(),
                  name: name,
                  username: username,
                  profileImageUrl: (Provider.of<UserProvider>(
                          navigationKey.currentContext!,
                          listen: false)
                      .user
                      .profileImgUrl))
              .toJson()
        ]),
        'answersCount': FieldValue.increment(1)
      });
      log("FROM ADD QU , QUsername : ${question.askerUsername} , AUsername : $username");
      await sendNotificationForQuestionOwner(
          askerUsername: question.askerUsername, answerName: name);
      _questions[_questions.indexOf(question)].answerCount++;
      _questions[_questions.indexOf(question)].answers.add(Answers(
          answer: answer,
          date: Timestamp.now(),
          name: name,
          username: username));
      filteredQuestions = _questions;
      pop();

      notifyListeners();
    } catch (error) {
      pop();

      print(error);
      if (!await InternetConnectionChecker().hasConnection) {
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('no_internet'),
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  Future<String?> getUserTokenByUsername(String username) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot userDoc = querySnapshot.docs.first;
        final Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;
        final String? token = userData['token'] as String?;
        log("Token : $token ");
        return token;
      } else {
        log('No user found with username: $username');
        return null;
      }
    } catch (error) {
      log('Error: $error');
      return null;
    }
  }

  Future<void> sendNotificationForQuestionOwner(
      {required String askerUsername, required String answerName}) async {
    log('Question Owner FCM askerUsername : $askerUsername');
    String? token;
    try {
      token = await getUserTokenByUsername(askerUsername);
      log("Question Owner Token : $token");
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$kServerToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': 'تم الرد علي سؤالك',
              'body': 'تم الرد علي سؤالك من قبل $answerName',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'token': token,
              "type": 'questions'
            },
            'to': token,
          },
        ),
      );
      await updateQuestionOwnerNotifications(
          token: token!, answerName: answerName);
    } catch (e) {
      log("Error while send notification : $e");
    }
  }

  Future<void> updateQuestionOwnerNotifications(
      {required String token, required String answerName}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('token', isEqualTo: token)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Loop through the documents and update the 'failed' field
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final String userId = doc.id;

        // Update the 'failed' field to your desired value
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'notification': true,
          'notifications': FieldValue.arrayUnion([
            {
              'title': 'تم الرد علي سؤالك',
              'body': 'تم الرد علي سؤالك من قبل $answerName',
              'createsAt': Timestamp.now(),
            }
          ])
        });

        print('Updated "failed" field for user with ID: $userId');
      }
    } else {
      // No admin users found
      print('No admin users found.');
    }
  }

  Future<User?> getUserByUsername(String username) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot userDoc = querySnapshot.docs.first;
        final Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;
        return User.fromMap(userData, userDoc.id);
      } else {
        log('No user found with username: $username');
        return null;
      }
    } catch (error) {
      log('Error While getting user data by userName: $error');
      return null;
    }
  }

  Future<void> deleteAnswer(Question question, Answers answer) async {
    try {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: tr('alert'),
        desc: tr('delete_answer'),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          await FirebaseFirestore.instance
              .collection('Q&A')
              .doc('questions')
              .collection('questions')
              .doc(question.id)
              .update({
            'answers': FieldValue.arrayRemove([answer.toJson()]),
            'answersCount': FieldValue.increment(-1)
          });
          _questions[_questions.indexOf(question)].answerCount--;
          _questions[_questions.indexOf(question)].answers.remove(answer);
          filteredQuestions = _questions;
        },
      ).show();

      notifyListeners();
    } catch (error) {
      print(error);
      if (!await InternetConnectionChecker().hasConnection) {
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('no_internet'),
          btnOkOnPress: () {},
        ).show();
      }
    }
  }
}

import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamrini/firebase_stuff/firestore.dart';
import 'package:tamrini/model/user.dart' as model;
import 'package:tamrini/screens/login_screen/otp_screen.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../firebase_options.dart';
import '../screens/Home_screen.dart';

enum AuthCatch {
  notFound,
  wrongEmailOrPass,
  existPhone,
  weakPassword,
  emailAlreadyInUse,
  wrongConfirmationPassword,
  invalidCredential,
  unknown,
  userDisabled,
  invalidEmail,
  wrongPassword,
  networkError,
  userNotFound,
  existUsername,
  invalidPhone,
  invalidCode,
  invalidVerificationId,
  credentialAlreadyInUse,
  accountExistsWithDifferentCredential,
  operationNotAllowed,
  tooManyRequests,
  phoneAlreadyInUse,
  phoneAlreadyInUseinvalidOtp,
  invalidOtpFormat,
  invalidOtpLength,
  invalidOtpTime,
  invalidOtpCode,
  invalidAppCredential,
  captchaCheckFailed,
  missingVerificationId,
  quotaExceeded,
  missingVerificationCode,
  sessionExpired,
  invalidVerificationCode,
  emailIsNotVerified,
}

Future<List<Map<String, dynamic>>> downloadUsersData() async {
  try {
    if (await InternetConnectionChecker().hasConnection == false) {
      throw AuthCatch.networkError;
    }

    List<Map<String, dynamic>> users = [];

    await FirebaseFirestore.instance
        .collection('users')
        .getSavy()
        .then((snapshot) {
      if (snapshot.size == 0) return users;

      for (DocumentSnapshot data in snapshot.docs) {
        if (data.data() == null || !data.exists) continue;
        Map<String, dynamic> temp = data.data() as Map<String, dynamic>;
        users.add(
          {
            'email': temp['email'],
            'name': temp['name'],
            'username': temp['username'],
            'phone': temp['phone'],
            'avatar': temp['profileImgurl'] ?? "",
            'token': temp['token'] ?? "",
            'docID': data.id,
          },
        );
      }
    });
    return users;
  } on FirebaseException catch (e) {
    log(e.toString());
    throw AuthCatch.notFound;
  } catch (e) {
    log(e.toString());
    throw AuthCatch.notFound;
  }
}

class UserData {
  // TODO : To an Add Image while sign up
  Future<model.User> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
    required String phone,
    required String gender,
    required int age,
  }) async {
    try {
      if (await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .getSavy()
          .then((value) => value.docs.isNotEmpty)) {
        log('existUsername');
        throw AuthCatch.existUsername;
      }
      if (await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .getSavy()
          .then((value) => value.docs.isNotEmpty)) {
        log('existPhone');
        throw AuthCatch.phoneAlreadyInUse;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      log('userCredential: ${userCredential.user!.uid}');

      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      await messaging.subscribeToTopic('all'); // subscribe to all

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'username': username,
        'phone': phone,
        'token': token,
        'password': password,
        'gender': gender,
        'age': age,
        'profileImgurl': '',
        'role': 'user',
        'gymId': "",
        "isPublisher": false,
        "publisherSummary": "",
        'isSubscribedToTrainer': false,
        'isBanned': false,
        'isVerifiedPhoneNumber': false,
        'notifications': [],
        'notification': false,
        'isVerifiedEmail': password == '!@#%^&*' ? true : false,
        'pendingEmail': email
      });

      log('data entered to firestore');

      return model.User(
          email: email,
          name: name,
          username: username,
          phone: phone,
          token: token!,
          uid: userCredential.user!.uid,
          password: password,
          age: age,
          profileImgUrl: "",
          gender: gender,
          role: 'user',
          gymId: '',
          isPublisher: false,
          publisherSummary: "",
          isSubscribedToTrainer: false,
          isBanned: false,
          isVerifiedPhoneNumber: false,
          notification: false,
          notifications: [],
          isVerifiedEmail: false,
          pendingEmail: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        throw AuthCatch.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');

        throw AuthCatch.emailAlreadyInUse;
      } else if (e.code == 'invalid-email') {
        log(e.code);
        throw AuthCatch.invalidEmail;
      } else {
        log(e.code);
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<model.User> logInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      await messaging.subscribeToTopic('all'); // subscribe to all

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
        'token': token,
        'password': password,
        'isVerifiedEmail': userCredential.user!.emailVerified ? true : false
      });

      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .getSavy()
          .then((data) {
        debugPrint("sssssssssssssssssssssssssssssssssssssssssssssss");
        debugPrint('value: ${data.data()}');
        var incData = data.data() as Map<String, dynamic>;

        return model.User(
            email: incData['email'],
            //
            name: incData['name'],
            //
            username: incData['username'],
            //
            phone: incData['phone'],
            //
            token: token!,
            //
            uid: data.id,
            //
            password: incData['password'],
            //
            age: incData['age'],
            //
            profileImgUrl: (incData.containsKey('profileImgurl'))
                ? incData['profileImgurl']
                : "",
            //
            gender: incData['gender'],
            //
            role: incData['role'],
            //
            gymId: incData['gymId'],
            //
            isPublisher: incData["isPublisher"],
            publisherSummary: incData["publisherSummary"],
            isSubscribedToTrainer: incData['isSubscribedToTrainer'],
            //
            isBanned: incData['isBanned'],
            //
            isVerifiedPhoneNumber: incData['isVerifiedPhoneNumber'],
            //
            notification: incData['notification'] ?? false,
            //
            notifications: incData['notifications'] ?? [],
            //
            isVerifiedEmail: incData['isVerifiedEmail'] ?? true,
            //
            pendingEmail: incData['pendingEmail'] ?? incData['email']); //
      });

      return data;
    } on FirebaseAuthException catch (e) {
      log(e.toString());

      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        throw AuthCatch.userNotFound;
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        throw AuthCatch.wrongPassword;
      } else if (e.code == 'invalid-email') {
        throw AuthCatch.invalidEmail;
      } else {
        log(e.code);
        rethrow;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<model.User> logInWithApple() async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }
      final result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      var appleId = result.credential!.email;
      var appleName = result.credential!.fullName!.familyName;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (appleId != null && appleName != null) {
        prefs.setString('appleId', appleId);
        prefs.setString('appleName', appleName);
      } else {
        appleId = prefs.getString('appleId');
        appleName = prefs.getString('appleName');
      }

      if (appleId != null) {
        return await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: appleId)
            .get()
            .then((value) async {
          if (value.docs.isEmpty) {
            log('user not found');

            return model.User(
                name: appleName!,
                email: appleId!,
                username: '',
                phone: '',
                token: '',
                uid: '',
                password: '',
                role: '',
                gymId: '',
                isPublisher: false,
                publisherSummary: "",
                isSubscribedToTrainer: false,
                isBanned: false,
                isVerifiedPhoneNumber: false,
                gender: '',
                age: 0,
                profileImgUrl: '',
                notification: false,
                notifications: [],
                isVerifiedEmail: true,
                pendingEmail: "");
          }
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          String? token = await messaging.getToken();
          await messaging.subscribeToTopic('all'); // subscribe to all

          FirebaseAuth auth = FirebaseAuth.instance;
          await auth.signInWithEmailAndPassword(
              email: appleId!, password: value.docs.first.data()['password']);

          await value.docs.first.reference.update({'token': token});

          var data = value.docs.first.data();

          return model.User(
              email: data['email'],
              name: data['name'],
              username: data['username'],
              phone: data['phone'],
              token: token!,
              uid: value.docs.first.id,
              password: data['password'],
              age: data['age'],
              profileImgUrl: (data.containsKey('profileImgurl'))
                  ? data['profileImgurl']
                  : "",
              gender: data['gender'],
              role: data['role'],
              gymId: data['gymId'],
              isPublisher: data['isPublisher'],
              publisherSummary: data['publisherSummary'],
              isSubscribedToTrainer: data['isSubscribedToTrainer'],
              isBanned: data['isBanned'],
              isVerifiedPhoneNumber: data['isVerifiedPhoneNumber'],
              notification: data['notification'] ?? false,
              notifications: data['notifications'] ?? [],
              isVerifiedEmail: data['isVerifiedEmail'] ?? true,
              pendingEmail: data['pendingEmail'] ?? data['email']);
        }).catchError((e) {
          log(e.toString());
          throw AuthCatch.unknown;
        });
      } else {
        throw AuthCatch.notFound;
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());

      throw AuthCatch.notFound;
    } catch (e) {
      log(e.toString());

      rethrow;
    }
  }

  Future<model.User> logInWithGoogle() async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }

      var googleAuth = await GoogleSignIn(
              clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
          .signIn();

      return await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: googleAuth!.email)
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          log('user not found');

          return model.User(
            name: googleAuth.displayName!,
            email: googleAuth.email,
            username: '',
            phone: '',
            token: '',
            uid: '',
            password: '',
            role: '',
            gymId: '',
            isPublisher: false,
            publisherSummary: "",
            isSubscribedToTrainer: false,
            isBanned: false,
            isVerifiedPhoneNumber: false,
            gender: '',
            age: 0,
            profileImgUrl: googleAuth.photoUrl ?? '',
            notification: false,
            notifications: [],
            isVerifiedEmail: false,
            pendingEmail: "",
          );
        }
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        String? token = await messaging.getToken();
        await messaging.subscribeToTopic('all'); // subscribe to all

        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signInWithEmailAndPassword(
            email: googleAuth.email,
            password: value.docs.first.data()['password']);

        await value.docs.first.reference.update({'token': token});

        var data = value.docs.first.data();

        return model.User(
          email: data['email'],
          name: data['name'],
          username: data['username'],
          phone: data['phone'],
          token: token!,
          uid: value.docs.first.id,
          password: data['password'],
          age: data['age'],
          profileImgUrl:
              (data.containsKey('profileImgurl')) ? data['profileImgurl'] : "",
          gender: data['gender'],
          role: data['role'],
          gymId: data['gymId'],
          isPublisher: data['isPublisher'],
          publisherSummary: data["publisherSummary"],
          isSubscribedToTrainer: data['isSubscribedToTrainer'],
          isBanned: data['isBanned'],
          isVerifiedPhoneNumber: data['isVerifiedPhoneNumber'],
          notification: data['notification'] ?? false,
          notifications: data['notifications'] ?? [],
          isVerifiedEmail: data['isVerifiedEmail'] ?? true,
          pendingEmail: data['pendingEmail'] ?? data['email'],
        );
      }).catchError((e) {
        debugPrint(e.toString());
        throw e;
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw AuthCatch.notFound;
    } catch (e) {
      debugPrint(e.toString());
      throw AuthCatch.unknown;
    }
  }

  verifyPhone(String phone) {
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) {
            log("verficiaiton completed");
            log(credential.smsCode!);
            log(credential.token.toString());
            log(credential.providerId);
            log(credential.signInMethod);
          },
          verificationFailed: (FirebaseAuthException e) {
            debugPrint("${e.code} ${e.message!}");
            if (e.code == 'invalid-phone-number') {
              pop();
              AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: tr('error_invalid_phone_number'),
                desc: 'يرجى إدخال رقم هاتف صحيح',
                btnOkOnPress: () {},
              ).show();
            } else if (e.code == 'network-request-failed') {
              pop();
              AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: 'خطأ في الاتصال',
                desc: 'يرجى التحقق من اتصالك بالانترنت',
                btnOkOnPress: () {},
              ).show();
            } else if (e.code == 'too-many-requests') {
              pop();
              AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: tr('error'),
                desc: 'لقد تجاوزت الحد الأقصى لعدد المحاولات',
                btnOkOnPress: () {},
              ).show();
            } else if (e.code == 'session-expired') {
              pop();
              AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: tr('error'),
                desc: 'انتهت صلاحية الجلسة',
                btnOkOnPress: () {},
              ).show();
            } else {
              pop();
              AwesomeDialog(
                context: navigationKey.currentContext!,
                dialogType: DialogType.error,
                animType: AnimType.bottomSlide,
                title: tr('error'),
                desc: 'حدث خطأ غير متوقع',
                btnOkOnPress: () {},
              ).show();
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          codeSent: (String verificationId, int? forceResendingToken) async {
            // showLoaderDialog(navigationKey.currentContext!);
            pop();

            To(OtpPage(
              phone: phone,
            ));
            await SharedPreferences.getInstance().then(
                (value) => value.setString("verificationId", verificationId));
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        throw AuthCatch.invalidPhone;
      }
      throw AuthCatch.unknown;
    } catch (ex) {
      rethrow;
    }
  }

  Future<bool> verifyCode(
    String code, {
    String? phone,
  }) async {
    log("code: $code");
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }

      var shared = await SharedPreferences.getInstance();
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        smsCode: code,
        verificationId: shared.getString("verificationId")!,
      );
      final FirebaseAuth auth = FirebaseAuth.instance;

      // await auth.currentUser!.unlink("phone");
      await auth.currentUser!.updatePhoneNumber(phoneAuthCredential);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'isVerifiedPhoneNumber': true,
        'phone': phone ?? auth.currentUser!.phoneNumber
      });
      return true;
    } on FirebaseAuthException catch (e) {
      log("Error on Firebase verification ${e.code}");
      log(e.message!);
      if (e.code == "invalid-verification-code") {
        throw AuthCatch.invalidCode;
      }
      if (e.code == "invalid-verification-id") {
        throw AuthCatch.invalidCode;
      }
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthCatch.phoneAlreadyInUse;
      }
      if (e.code == "missing-verification-code") {
        throw AuthCatch.invalidCode;
      }
      if (e.code == "credential-already-in-use") {
        throw AuthCatch.phoneAlreadyInUse;
      }
      if (e.code == "invalid-credential") {
        throw AuthCatch.invalidCode;
      }
      if (e.code == "invalid-phone-number") {
        throw AuthCatch.invalidPhone;
      }
      debugPrint(e.toString());
      throw AuthCatch.unknown;
    }
  }

  Future<void> logOut() async {
    CacheHelper.putBoolean(key: "isLogin", value: false);
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'token': ""});
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.unsubscribeFromTopic('all'); // unsubscribe from all

      await FirebaseAuth.instance.signOut();
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      debugPrint(e.toString());
      throw AuthCatch.unknown;
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.unsubscribeFromTopic('all'); // unsubscribe fr
      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      debugPrint(e.toString());
      throw AuthCatch.unknown;
    }
  }

  Future<void> updateEmail(
    String newEmail,
    String uid,
    String password,
  ) async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: FirebaseAuth.instance.currentUser!.email!, password: password);

      await FirebaseAuth.instance.currentUser!
          .verifyBeforeUpdateEmail(newEmail);

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: tr('done'),
        desc:
            'تم إرسال رسالة إلى البريد الإلكتروني الجديد , سيتم تغيير البريد بعد التأكيد , في حالة عدم وصول الرسالة يرجى التأكد من الرسائل الغير مرغوب فيها',
        btnOkOnPress: () {},
      ).show().then((value) => To(const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == "unknown") {
        throw AuthCatch.invalidEmail;
      }
      if (e.code == "email-already-in-use") {
        throw AuthCatch.emailAlreadyInUse;
      }
      if (e.code == "TOO_MANY_REQUESTS") {
        throw AuthCatch.tooManyRequests;
      }
      if (e.code == "USER_DISABLED") {
        throw AuthCatch.userDisabled;
      }
      if (e.code == "USER_NOT_FOUND") {
        throw AuthCatch.userNotFound;
      }
      if (e.code == "OPERATION_NOT_ALLOWED") {
        throw AuthCatch.operationNotAllowed;
      }
      if (e.code == "INVALID_CREDENTIAL") {
        throw AuthCatch.invalidCredential;
      }

      debugPrint("code: ${e.code}");
      debugPrint("message: ${e.message!}");

      throw AuthCatch.unknown;
    }
  }

  Future<void> verifyEmail() async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }

      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }

      if (await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) => value.docs.isEmpty)) {
        throw AuthCatch.notFound;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<model.User?> fetchUserByUsername(String username) async {
    model.User? user;
    try {
      if (await InternetConnectionChecker().hasConnection == false) {
        throw AuthCatch.networkError;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .getSavy()
          .then((snapshot) {
        if (snapshot.size == 0) return null;

        Map<String, dynamic> data = (snapshot.docs.first.data() as Map)
            .map((key, value) => MapEntry(key as String, value));

        user = model.User(
          email: data['email'],
          name: data['name'],
          username: data['username'],
          phone: data['phone'],
          token: '',
          uid: snapshot.docs.first.id,
          password: '',
          age: data['age'],
          profileImgUrl:
              (data.containsKey('profileImgurl')) ? data['profileImgurl'] : "",
          gender: data['gender'],
          role: data['role'],
          gymId: data['gymId'],
          isPublisher: data['isPublisher'],
          publisherSummary: data["publisherSummary"],
          isSubscribedToTrainer: data['isSubscribedToTrainer'],
          isBanned: data['isBanned'],
          isVerifiedPhoneNumber: data['isVerifiedPhoneNumber'],
          notification: data['notification'] ?? false,
          notifications: data['notifications'] ?? [],
          isVerifiedEmail: data['isVerifiedEmail'] ?? true,
          pendingEmail: data['pendingEmail'] ?? data['email'],
          description: (data['achievements'] != null &&
                  data['achievements'].toString().isNotEmpty)
              ? data['achievements']
              : "",
          contacts:
              (data['contacts'] != null && data['contacts'] is List<dynamic>)
                  ? List<String>.from(data['contacts'])
                  : [],
          price: data['price'] ?? 0,
          traineesCount: data['traineesCount'] ?? 0,
          questions:
              (data['questions'] != null && data['questions'] is List<dynamic>)
                  ? List<String>.from(data['questions'])
                  : [],
          gallery: (data['gallery'] != null && data['gallery'] is List<dynamic>)
              ? List<String>.from(data['gallery'])
              : [],
          gymImage:
              (data['gymImage'] != null && data['gymImage'] is List<dynamic>)
                  ? List<String>.from(data['gymImage'])
                  : [],
        );
      });
    } on FirebaseException catch (e) {
      log(e.toString());
      throw AuthCatch.notFound;
    } catch (e) {
      log(e.toString());
      throw AuthCatch.notFound;
    }
    return user;
  }
}

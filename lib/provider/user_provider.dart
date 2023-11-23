import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamrini/data/user_data.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/screens/Home_screen.dart';
import 'package:tamrini/screens/login_screen/complete_register_screen.dart';
import 'package:tamrini/utils/helper_functions.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../model/alarm_model.dart';
import '../screens/login_screen/login_screen.dart';
import '../screens/notifications_screen.dart';
import '../utils/alarm_database_helper.dart';
import '../utils/cache_helper.dart';

class UserProvider with ChangeNotifier {
  List<AlarmModel> _alarms = [];
  bool _isLoading = false;

  // Start For Alarm
  int waterLitres = 1;
  TimeOfDay? selectedTime;

  void decrease() {
    if (waterLitres > 1) {
      waterLitres = waterLitres - 1;
    }
    notifyListeners();
  }

  void increase() {
    if (waterLitres < 20) {
      waterLitres = waterLitres + 1;
    }
    notifyListeners();
  }

  void showTimePickerDialog(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      this.selectedTime = selectedTime;
    }
    notifyListeners();
  }

  void resetAlarm() {
    waterLitres = 1;
    selectedTime = null;
  }

  String getCurrentUid() {
    String uid = auth.FirebaseAuth.instance.currentUser!.uid;
    log("###################$uid");
    return uid;
  }

// Initialize the alarms from the database when the provider is created
  UserProvider() {
    _initAlarms();
  }

  // Function to initialize alarms from the database
  void _initAlarms() async {
    _isLoading = true;
    notifyListeners();

    _alarms = await AlarmDatabaseHelper.instance.getAllAlarms();

    _isLoading = false;
    notifyListeners();
  }

  // Function to add a new alarm
  Future<void> addAlarm(AlarmModel alarm) async {
    _isLoading = true;
    notifyListeners();

    int id = await AlarmDatabaseHelper.instance.insert(alarm);
    alarm.id = id;
    _alarms.add(alarm);
// TODO: make the Alarm notification logic

    _isLoading = false;
    notifyListeners();
  }

  // Function to update an existing alarm
  Future<void> updateAlarm(AlarmModel alarm) async {
    _isLoading = true;
    notifyListeners();

    await AlarmDatabaseHelper.instance.updateAlarm(alarm);
    _alarms[_alarms.indexWhere((element) => element.id == alarm.id)] = alarm;

    _isLoading = false;
    notifyListeners();
  }

  // Function to delete an alarm
  Future<void> deleteAlarm(int id) async {
    _isLoading = true;
    notifyListeners();

    await AlarmDatabaseHelper.instance.deleteAlarm(id);
    _alarms.removeWhere((element) => element.id == id);

    _isLoading = false;
    notifyListeners();
  }

// End For Alarm
  List<AlarmModel> get alarms => _alarms;
  bool get isLoading => _isLoading;
  late User _user = User(
      name: "",
      email: "",
      phone: "",
      role: "",
      isBanned: false,
      isVerifiedPhoneNumber: false,
      notification: false,
      notifications: [],
      username: '',
      password: '',
      token: '',
      uid: '',
      gymId: '',
      isPublisher: false,
      publisherSummary: "",
      gender: '',
      age: 0,
      profileImgUrl: '',
      isSubscribedToTrainer: false,
      isVerifiedEmail: false,
      pendingEmail: '');
  UserData userData = UserData();
  bool isLogin = false;
  bool isAdmin = false;
  bool isGymOwner = false;
  bool isPublisher = false;
  bool isCaptain = false;
  String verificationId = "";
  String credentialsName = "";
  String credentialsEmail = "";
  TimeOfDay? drinkAlarm;

  User get user => _user;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSnapshot;

  void _setUser(User user) {
    _user = user;
    if (user.isBanned) {
      Fluttertoast.showToast(msg: "You are banned");
      CacheHelper.putBoolean(key: 'isLogin', value: false);
      ToAndFinish(const LoginScreen());
    }
    isAdmin = user.role == 'admin' ? true : false;
    isCaptain = user.role == 'captain' ? true : false;
    isGymOwner = (user.gymId != null && user.gymId!.isNotEmpty) ? true : false;
    isPublisher = (user.isPublisher != null) ? user.isPublisher! : false;
    CacheHelper.putBoolean(key: 'isLogin', value: true);
    isLogin = CacheHelper.getBoolean(key: "isLogin");
    log("*************************************");
    log("isCaptain :$isCaptain , isGymOwner : $isGymOwner ,isPublisher : $isPublisher  ");
    log("*************************************");
    notifyListeners();
  }

  String? getCurrentUserId() {
    return auth.FirebaseAuth.instance.currentUser?.uid;
  }

  initiate() async {
    debugPrint('----- initiate -------');
    isLogin = CacheHelper.getBoolean(key: "isLogin");
    await _userSnapshot?.cancel();
    if (CacheHelper.getString(key: "id").isNotEmpty) {
      _userSnapshot = FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getString(key: "id"))
          .snapshots()
          .listen((event) {
        if (isLogin == false) {
          _userSnapshot!.cancel();
          return;
        }
        if (event.exists) {
          String alarmData = CacheHelper.getString(key: 'drinkAlarm');
          if (alarmData.isNotEmpty) {
            Map<String, dynamic> alarm = jsonDecode(alarmData);
            drinkAlarm =
                HelperFunctions.parseTimeOfDayFromString(alarm['time']);
            waterLitres = alarm['litres'];
          }
          _setUser(User.fromMap(event.data()!, event.id));
        } else {
          Navigator.push(
            navigationKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      });

      // auth.FirebaseAuth.instance.userChanges().listen((auth.User? user) async {
      //   debugPrint("user changes");
      //   // debugPrint(user!.emailVerified.toString());
      //   if (user == null) {
      //     debugPrint('User is currently signed out!');
      //   } else {
      //     if (user.emailVerified) {
      //       if (user.email != _user.email) {
      //         await FirebaseFirestore.instance
      //             .collection('users')
      //             .doc(user.uid)
      //             .update({'email': user.email});
      //         _setUser(_user.copyWith(email: user.email));
      //         AwesomeDialog(
      //           context: navigationKey.currentContext!,
      //           dialogType: DialogType.SUCCES,
      //           animType: AnimType.BOTTOMSLIDE,
      //           title: 'تم تغيير البريد الالكتروني',
      //           desc: 'تم تغيير البريد الالكتروني الخاص بك بنجاح',
      //           btnOkOnPress: () {
      //             Navigator.push(
      //               navigationKey.currentContext!,
      //               MaterialPageRoute(
      //                 builder: (context) => LoginScreen(),
      //               ),
      //             );
      //           },
      //         ).show();
      //       }
      //       await FirebaseFirestore.instance
      //           .collection('users')
      //           .doc(user.uid)
      //           .update({'isVerifiedEmail': true});
      //       _setUser(_user.copyWith(isEmail: true));
      //     }
      //   }
      // });
    }
    _startEmailVerificationTimer();
    notifyListeners();
  }

  _startEmailVerificationTimer() {
    debugPrint("checking email  verification");
    var timer = Timer.periodic(const Duration(seconds: 5), (Timer _) async {
      if (auth.FirebaseAuth.instance.currentUser == null &&
          _user.pendingEmail.isNotEmpty &&
          _user.password.isNotEmpty) {
        await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _user.pendingEmail, password: _user.password);
      }
      if (isLogin) {
        await auth.FirebaseAuth.instance.currentUser?.reload();
        if (auth.FirebaseAuth.instance.currentUser?.emailVerified == true &&
            _user.isVerifiedEmail == false) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.FirebaseAuth.instance.currentUser!.uid)
              .update({'isVerifiedEmail': true});
        }
        if (_user.email != auth.FirebaseAuth.instance.currentUser!.email &&
            auth.FirebaseAuth.instance.currentUser!.emailVerified) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.FirebaseAuth.instance.currentUser!.uid)
              .update({
            'email': auth.FirebaseAuth.instance.currentUser!.email,
            'isVerifiedEmail': true
          });
        }
      }
    });
  }

  logIn({required String email, required String password}) async {
    showLoaderDialog(navigationKey.currentContext!);

    try {
      _setUser(await userData.logInWithEmail(
        email: email,
        password: password,
      ));

      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('name', user.name);
        prefs.setString('email', user.email);
        prefs.setString('phone', user.phone);
        prefs.setString('username', user.username);
        prefs.setString('role', user.role);
        prefs.setString('gymId', user.gymId ?? "");
        prefs.setBool('isPublisher', user.isPublisher ?? false);
        prefs.setString('id', user.uid);
        prefs.setInt('age', user.age);
        prefs.setString('gender', user.gender);
      });
      setRole();
      setIGymOwner();

      initiate();
      pop();
      ToAndFinish(const HomeScreen());
    } catch (e) {
      debugPrint(e.toString());
      try {
        catcherHandler(e as AuthCatch);
      } catch (e) {
        pop();
        Fluttertoast.showToast(msg: tr('wrong'));
      }
    }
  }

  signUp(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String username,
      required String role,
      required int age,
      required String gender}) async {
    showLoaderDialog(navigationKey.currentContext!);

    try {
      // verifyPhone(phone: "+2$phone");
      _setUser(await userData.signUp(
          name: name,
          email: email,
          phone: phone,
          password: password,
          username: username,
          age: age,
          gender: gender));
      CacheHelper.putBoolean(key: 'isLogin', value: true);

      setRole();
      setIGymOwner();
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('name', user.name);
        prefs.setString('email', user.email);
        prefs.setString('phone', user.phone);
        prefs.setString('username', user.username);
        prefs.setString('role', user.role);
        prefs.setString('gymId', user.gymId ?? "");
        prefs.setBool('isPublisher', user.isPublisher ?? false);
        prefs.setString('id', user.uid);
        prefs.setString('gender', user.gender);
        prefs.setInt('age', user.age);
      });
      initiate();
      pop();
      pop();

      ToAndFinish(const HomeScreen());
    } catch (e) {
      log("from provider $e");

      catcherHandler(e);
    }
  }

  catcherHandler(dynamic authCatch) {
    pop();
    if (authCatch == AuthCatch.existPhone) {
      Fluttertoast.showToast(msg: tr('error_already_registered_phone'));
    } else if (authCatch == AuthCatch.emailAlreadyInUse) {
      Fluttertoast.showToast(msg: tr('error_already_registered_email'));
    } else if (authCatch == AuthCatch.wrongEmailOrPass) {
      Fluttertoast.showToast(msg: tr('error_invalid_credentials'));
    } else if (authCatch == AuthCatch.weakPassword) {
      Fluttertoast.showToast(msg: tr('error_weak_password'));
    } else if (authCatch == AuthCatch.userNotFound) {
      Fluttertoast.showToast(msg: tr('error_user_not_found'));
    } else if (authCatch == AuthCatch.wrongPassword) {
      Fluttertoast.showToast(msg: tr('error_wrong_password'));
    } else if (authCatch == AuthCatch.networkError) {
      Fluttertoast.showToast(msg: tr('error_network_error'));
    } else if (authCatch == AuthCatch.emailAlreadyInUse) {
      Fluttertoast.showToast(msg: tr('error_email_already_registered'));
    } else if (authCatch == AuthCatch.invalidEmail) {
      Fluttertoast.showToast(msg: tr('error_invalid_email'));
    } else if (authCatch == AuthCatch.userDisabled) {
      Fluttertoast.showToast(msg: tr('error_user_disabled'));
    } else if (authCatch == AuthCatch.unknown) {
      Fluttertoast.showToast(msg: tr('error_unknown'));
    } else if (authCatch == AuthCatch.invalidCredential) {
      Fluttertoast.showToast(msg: tr('error_invalid_login_data'));
    } else if (authCatch == AuthCatch.invalidPhone) {
      Fluttertoast.showToast(msg: tr('error_invalid_phone_number'));
    } else if (authCatch == AuthCatch.phoneAlreadyInUse) {
      Fluttertoast.showToast(msg: tr('error_phone_number_already_registered'));
    } else if (authCatch == AuthCatch.tooManyRequests) {
      Fluttertoast.showToast(msg: tr('error_login_attempts_exceeded'));
    } else if (authCatch == AuthCatch.operationNotAllowed) {
      Fluttertoast.showToast(msg: tr('error_operation_not_allowed'));
    } else if (authCatch == AuthCatch.accountExistsWithDifferentCredential) {
      Fluttertoast.showToast(msg: tr('error_account_already_exists'));
    } else if (authCatch == AuthCatch.credentialAlreadyInUse) {
      Fluttertoast.showToast(msg: tr('error_data_already_exists'));
    } else if (authCatch == AuthCatch.invalidVerificationCode) {
      Fluttertoast.showToast(msg: tr('error_invalid_verification_code'));
    } else if (authCatch == AuthCatch.invalidVerificationId) {
      Fluttertoast.showToast(msg: tr('error_invalid_verification_code'));
    } else if (authCatch == AuthCatch.sessionExpired) {
      Fluttertoast.showToast(msg: tr('error_verification_code_expired'));
    } else if (authCatch == AuthCatch.missingVerificationCode) {
      Fluttertoast.showToast(msg: tr('error_verification_code_missing'));
    } else if (authCatch == AuthCatch.missingVerificationId) {
      Fluttertoast.showToast(msg: tr('error_verification_code_missing'));
    } else if (authCatch == AuthCatch.quotaExceeded) {
      Fluttertoast.showToast(msg: tr('error_verification_code_exceeded'));
    } else if (authCatch == AuthCatch.captchaCheckFailed) {
      Fluttertoast.showToast(msg: tr('error_captcha_verification_failed'));
    } else if (authCatch == AuthCatch.invalidAppCredential) {
      Fluttertoast.showToast(msg: tr('error_invalid_login_data'));
    } else if (authCatch == AuthCatch.existUsername) {
      Fluttertoast.showToast(
          msg: tr('error_email_already_registered_username'));
    } else if (authCatch == AuthCatch.emailIsNotVerified) {
      Fluttertoast.showToast(msg: tr('error_email_not_verified'));
    } else {
      Fluttertoast.showToast(msg: tr('error_unknown'));
    }
  }

  openNotifications() {
    To(NotificationPage());
    try {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'notification': false,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  setRole() {
    if (user.role == 'admin') {
      isAdmin = true;
      isCaptain = false;
    } else if (user.role == 'captain') {
      isCaptain = true;
      isAdmin = false;
    } else {
      isCaptain = false;
      isAdmin = false;
    }
    notifyListeners();
  }

  setIGymOwner() {
    if (user.gymId != null && user.gymId!.isNotEmpty) {
      isGymOwner = true;
    }
    notifyListeners();
  }

  setIsPublisher() {
    if (user.isPublisher != null) {
      isPublisher = true;
    }
    notifyListeners();
  }

  logOut() async {
    try {
      SharedPreferences.getInstance().then((prefs) async {
        await userData.logOut();
        _userSnapshot!.cancel();
        prefs.remove('name');
        prefs.remove('email');
        prefs.remove('phone');
        prefs.remove('username');
        prefs.remove('role');
        prefs.remove('gymId');
        prefs.remove("isPublisher");
        prefs.remove('age');
        prefs.remove('gender');

        CacheHelper.putBoolean(key: 'isLogin', value: false);
        isLogin = false;
        ToAndFinish(const LoginScreen());
        notifyListeners();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  editUserData(String name) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': name}).then((value) {
        user.name = name;
        _setUser(user);
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: tr('modified_successfully'),
          desc: tr('your_data_updated_successfully'),
          btnOkOnPress: () {
            Navigator.pop(navigationKey.currentContext!);
          },
        ).show().then((value) => ToAndFinish(const HomeScreen()));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  logInWithApple() async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      var data = await userData.logInWithApple();

      if (data.age == 0) {
        credentialsEmail = data.email;
        credentialsName = data.name;

        To(CompleteRegisterScreen(
          email: credentialsEmail,
          name: credentialsName,
          isApple: true,
        ));
        notifyListeners();
        return;
      }

      _setUser(data);
      setRole();
      setIGymOwner();

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('name', user.name);
        prefs.setString('email', user.email);
        prefs.setString('phone', user.phone);
        prefs.setString('username', user.username);
        prefs.setString('role', user.role);
        prefs.setString('gymId', user.gymId ?? "");
        prefs.setBool('isPublisher', user.isPublisher ?? false);
        prefs.setString('id', user.uid);
        prefs.setInt('age', user.age);
        prefs.setString('gender', user.gender);
        CacheHelper.putBoolean(key: 'isLogin', value: true);
      });

      initiate();
      pop();
      ToAndFinish(const HomeScreen());
    } catch (e) {
      log(e.toString());

      catcherHandler(e as AuthCatch);
    }
  }

  logInWithGoogle() async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      var data = await userData.logInWithGoogle();

      if (data.age == 0) {
        credentialsEmail = data.email;
        credentialsName = data.name;

        To(CompleteRegisterScreen(
          email: credentialsEmail,
          name: credentialsName,
        ));

        notifyListeners();
        return;
      }

      _setUser(data);
      setRole();
      setIGymOwner();

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('name', user.name);
        prefs.setString('email', user.email);
        prefs.setString('phone', user.phone);
        prefs.setString('username', user.username);
        prefs.setString('role', user.role);
        prefs.setString('gymId', user.gymId ?? "");
        prefs.setBool('isPublisher', user.isPublisher ?? false);
        prefs.setString('id', user.uid);
        prefs.setInt('age', user.age);
        prefs.setString('gender', user.gender);

        CacheHelper.putBoolean(key: 'isLogin', value: true);
      });

      initiate();
      pop();
      ToAndFinish(const HomeScreen());
    } catch (e) {
      log(e.toString());

      catcherHandler(e as AuthCatch);
    }
  }

  deleteAccount() async {
    try {
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: tr('delete_account'),
        desc: tr('account_will_be_deleted_permanently'),
        btnOkOnPress: () async {
          // re enter password to delete account
          final passwordController = TextEditingController();
          AwesomeDialog(
            context: navigationKey.currentContext!,
            dialogType: DialogType.info,
            animType: AnimType.bottomSlide,
            title: tr('enter_password'),
            desc: tr('to_confirm_account_deletion'),
            body: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: tr('password'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            btnOkOnPress: () async {
              if (passwordController.text.isEmpty) {
                Fluttertoast.showToast(msg: tr('enter_password'));
                return;
              }

              if (passwordController.text != user.password) {
                Fluttertoast.showToast(msg: tr('error_wrong_password'));
                return;
              }

              await userData.logInWithEmail(
                  email: user.email, password: user.password);

              await userData.deleteAccount();

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .delete();
              logOut();

              ToAndFinish(const LoginScreen());
            },
            btnOkColor: Colors.green,
            btnOkText: tr('verify'),
          ).show();
        },
        btnOkColor: Colors.green,
        btnOkText: tr('yes'),
        btnCancelText: tr('no'),
        btnCancelColor: Colors.red,
        btnCancelOnPress: () {},
      ).show();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  changePassword(String newPassword) async {
    try {
      log(newPassword);
      showLoaderDialog(navigationKey.currentContext!);
      await userData.logInWithEmail(email: user.email, password: user.password);
      await userData.updatePassword(newPassword);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'password': newPassword,
      });

      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('modified_successfully'),
        desc: tr('password_updated_successfully'),
        btnOkOnPress: () {
          Navigator.pop(navigationKey.currentContext!);
        },
      ).show().then((value) => To(const HomeScreen()));
    } catch (e) {
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: tr('wrong'),
        desc: tr('error_occurred_password_update'),
        btnOkOnPress: () {
          Navigator.pop(navigationKey.currentContext!);
        },
      ).show();
      debugPrint(e.toString());
      catcherHandler(e as AuthCatch);
    }
  }

  changeEmail(String newEmail) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);
      await userData.updateEmail(newEmail, user.uid, user.password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.FirebaseAuth.instance.currentUser!.uid)
          .update({
        'pendingEmail': newEmail,
      });
      _user.pendingEmail = newEmail;
    } catch (e) {
      debugPrint(e.toString());

      catcherHandler(e as AuthCatch);
    }
  }

  verifyEmail() async {
    try {
      await userData.verifyEmail();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: tr('verification_code_sent'),
        desc: tr('verification_code_sent_to_email'),
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      debugPrint(e.toString());
      catcherHandler(e as AuthCatch);
    }
  }

  verifyPhone({required String phoneNumber}) async {
    try {
      showLoaderDialog(navigationKey.currentContext!);

      // verify for unique phone number
      await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .get()
          .then((value) {
        if (user.phone == phoneNumber) {
          return;
        }
        if (value.docs.isNotEmpty) {
          throw AuthCatch.phoneAlreadyInUse;
        }
      });
      // pop();
      await userData.verifyPhone(phoneNumber);
    } catch (e) {
      debugPrint(e.toString());
      catcherHandler(e as AuthCatch);
    }
  }

  verifyPhoneCode({required String code, String? phone}) async {
    try {
      await userData.verifyCode(code, phone: phone);
      pop();

      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('verification_successful'),
        desc: tr('phone_number_verified_successfully'),
      ).show().then((value) {
        ToAndFinish(const HomeScreen());
      });
    } catch (e) {
      if (e as AuthCatch == AuthCatch.invalidCode) {
        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('invalid_verification_code'),
        ).show().then((value) => pop());
      } else if (e == AuthCatch.invalidPhone) {
        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('error_invalid_phone_number'),
        ).show().then((value) => pop());
      } else if (e == AuthCatch.phoneAlreadyInUse) {
        pop();
        AwesomeDialog(
          context: navigationKey.currentContext!,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: tr('error'),
          desc: tr('phone_number_already_used'),
        ).show().then((value) => pop());
      } else {
        catcherHandler(e);
      }
    }
  }

  forgetPassword(String email) async {
    try {
      if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
        throw AuthCatch.invalidEmail;
      }
      showLoaderDialog(navigationKey.currentContext!);
      await userData.forgetPassword(email);
      pop();
      AwesomeDialog(
        context: navigationKey.currentContext!,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: tr('reset_password_link_sent'),
        desc: tr('reset_password_link_sent_to_email'),
        btnOkOnPress: () {
          Navigator.pop(navigationKey.currentContext!);
        },
      ).show();
    } catch (e) {
      debugPrint(e.toString());
      catcherHandler(e as AuthCatch);
    }
  }

  // delete notification
  deleteNotification(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'notifications': FieldValue.arrayRemove([id])
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//! Adding, pending and removing Gym Data

  Future<void> addUserGymId(String gymid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'gymId': gymid}).then((value) {
        user.gymId = gymid;
        _setUser(user);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteUserGymId(String gymOwnerId) async {
    try {
      log('******************** User Id :$gymOwnerId ');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(gymOwnerId)
          .update({
        'gymId': FieldValue.delete(),
      }).then((value) {
        user.gymId = '';
        _setUser(user);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/proten_calculator_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/Home_screen.dart';
import 'package:tamrini/screens/setting_screens/reset_password_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import 'bottom_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController email2Controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  late final List<Widget> loginContent;
  bool agree = false;

  Gender gender = Gender.Male;

  String code = '964';

  Widget inputField(String hint, IconData iconData,
      {TextInputType? type, required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.sp, vertical: 8.sp),
      child: SizedBox(
        height: 50,
        width: 250.w,
        child: TextFormField(
          maxLines: 1,
          enableInteractiveSelection: true,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontFamily: 'cairo'),
          controller: controller,
          textAlignVertical: TextAlignVertical.bottom,
          keyboardType: type,
          obscureText: iconData == Ionicons.lock_closed_outline ? true : false,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintMaxLines: 1,
            helperMaxLines: 1,
            errorMaxLines: 1,
            border: const UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.white,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.white,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            // filled: true,
            // fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            prefixIcon: Icon(iconData, color: Colors.white38),
            suffix: iconData == Ionicons.call_outline
                ? StatefulBuilder(builder: (context, setState) {
                    return InkWell(
                      onTap: () {
                        showCountryPicker(
                          countryListTheme: CountryListThemeData(
                            searchTextStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'cairo',
                              color: Colors.black,
                            ),
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'cairo',
                              color: Colors.grey,
                            ),
                            inputDecoration: InputDecoration(
                              counterStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'cairo',
                                color: Colors.black,
                              ),

                              labelStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'cairo',
                                color: Colors.black,
                              ),
                              prefixIcon: const Icon(
                                Ionicons.search_outline,
                                color: Colors.black38,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              // filled: true,
                              // fillColor: Colors.white,

                              hintText: tr('country'),
                              // hintText: 'البلد',
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'cairo',
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          context: context,
                          showPhoneCode:
                              true, // optional. Shows phone code before the country name.
                          onSelect: (Country country) {
                            code = country.phoneCode;
                            print('Select country: ${country.phoneCode}');
                            setState(() {});
                          },
                        );
                      },
                      child: Text(
                        '+$code',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'cairo',
                          color: Colors.black,
                        ),
                      ),
                    );
                  })
                : null,
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title) {
    return Consumer<UserProvider>(builder: (context, _, child) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 30.0,
          bottom: 20,
          left: 20,
          right: 20,
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (title == tr('login')) {
              // if (title == 'تسجيل الدخول') {
              print(emailController.text);
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                _.logIn(
                    email: emailController.text.trim(),
                    password: passwordController.text);
              }
            } else {
              Fluttertoast.showToast(
                msg: context.locale.languageCode == 'ar'
                    ? 'من فضلك ادخل جميع البيانات'
                    : 'Please fill the all the fields',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            // padding: const EdgeInsets.all(8),
            backgroundColor: Colors.grey[700],
            shape: const StadiumBorder(),
            elevation: 8,
            shadowColor: Colors.black87,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(
              title,
              // maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'cairo',
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 70,
      ),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              tr('or'),
              // 'أو',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // InkWell(
          //   child: Container(
          //     // decoration: BoxDecoration(
          //     //   color: Colors.white,
          //     //   borderRadius: BorderRadius.circular(20),
          //     // ),
          //     width: 40,
          //     height: 40,
          //     child: Image.asset(
          //       'assets/images/Facebook-logo.png',
          //       width: 50,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          //   onTap: () {
          //     Provider.of<UserProvider>(context, listen: false)
          //         .logInWithFacebook();
          //   },
          // ),
          // const SizedBox(width: 30),
          InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(20),
                // ),
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/images/google.png',
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              Provider.of<UserProvider>(context, listen: false)
                  .logInWithGoogle();
            },
          ),
          Platform.isAndroid ? const SizedBox() : const SizedBox(width: 30),
          // check is android
          Platform.isAndroid
              ? const SizedBox()
              : InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        'assets/images/Apple-Logo.png',
                        fit: BoxFit.cover,
                        // width: 60,
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .logInWithApple();
                  },
                ),

          // Image.asset('assets/images/facebook.png'),
        ],
      ),
    );
  }

  Widget forgotPassword(String title) {
    return TextButton(
      onPressed: () {
        title == tr('forget_password')
            // title == 'نسيت كلمة المرور'
            ? To(const ResetPassword())
            : To(const HomeScreen());
      },
      child: Text(
        title,
        style: const TextStyle(
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.solid,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'cairo',
        ),
      ),
    );
  }

  @override
  void dispose() {
    // ChangeScreenAnimation.dispose();

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    loginContent = [
      const SizedBox(height: 20),
      inputField(tr('email'), Ionicons.mail_outline,
          // inputField('البريد الإلكتروني', Ionicons.mail_outline,
          controller: emailController),
      inputField(tr('password'), Ionicons.lock_closed_outline,
          // inputField('كلمة المرور', Ionicons.lock_closed_outline,
          controller: passwordController),
      loginButton(tr('login')),
      // loginButton('تسجيل الدخول'),
      orDivider(),
      logos(),
      Center(
          child: BottomText(
              text1: '${tr('do_not_have_account')}؟ ',
              text2: tr('create_account'))),
      // child: BottomText(text1: 'ليس لديك حساب؟ ', text2: 'إنشاء حساب')),
      forgotPassword(tr('forget_password')),
      // forgotPassword('نسيت كلمة المرور'),
      forgotPassword(tr('continue_without_registration')),
      // forgotPassword('المتابعه بدون تسجيل'),
      const SizedBox(height: 20)
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      // controller: ScrollController(keepScrollOffset: true),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade700.withOpacity(0.7)),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: loginContent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

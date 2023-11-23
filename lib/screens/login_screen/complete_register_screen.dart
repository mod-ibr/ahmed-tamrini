import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/proten_calculator_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/login_screen/login_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class CompleteRegisterScreen extends StatefulWidget {
  final String email;
  final String name;
  final bool isApple;

  const CompleteRegisterScreen(
      {Key? key, required this.email, required this.name, this.isApple = false})
      : super(key: key);

  @override
  _CompleteRegisterScreenState createState() => _CompleteRegisterScreenState();
}

class _CompleteRegisterScreenState extends State<CompleteRegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Gender gender = Gender.Male;

  String code = '964';

  var agree = false;
  @override
  void initState() {
    emailController.text = widget.email;
    nameController.text = widget.name;
    if (widget.isApple) {
      passwordController.text = '!@#%^&*';
      confirmPasswordController.text = '!@#%^&*';
    }

    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await ToAndFinish(const LoginScreen())) ?? false;
  }

  Widget inputField(String hint, IconData iconData,
      {TextInputType? type, required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.sp, vertical: 8.sp),
      child: SizedBox(
        height: 50,
        width: 250.w,
        child: TextFormField(
          enabled: hint == tr('email') ? false : true,
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
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: Icon(iconData, color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/login1.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20, top: 200),
                child: SizedBox(
                  // height: 1.sh,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700.withOpacity(0.7)),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            inputField(tr('full_name'), Ionicons.person_outline,
                                controller: nameController),
                            inputField(tr('username'), Ionicons.person_outline,
                                controller: userNameController),
                            inputField(tr('email'), Ionicons.mail_outline,
                                controller: emailController),
                            inputField(tr('phone'), Ionicons.call_outline,
                                type: TextInputType.phone,
                                controller: phoneController),
                            !widget.isApple
                                ? inputField(tr('password'),
                                    Ionicons.lock_closed_outline,
                                    controller: passwordController)
                                : const SizedBox(),
                            !widget.isApple
                                ? inputField(tr('confirm_password'),
                                    Ionicons.lock_closed_outline,
                                    controller: confirmPasswordController)
                                : const SizedBox(),
                            inputField(tr('age'), Ionicons.calendar_outline,
                                type: TextInputType.phone,
                                controller: ageController),
                            StatefulBuilder(builder: (context, setState) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: Gender.Male,
                                          groupValue: gender,
                                          onChanged: (Gender? value) {
                                            setState(() {
                                              gender = value!;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            tr('male'),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Row(
                                      children: [
                                        Radio(
                                          value: Gender.Female,
                                          groupValue: gender,
                                          onChanged: (Gender? value) {
                                            setState(() {
                                              gender = value!;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            tr('female'),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                            //agree to terms and conditions
                            StatefulBuilder(builder: (context, setState) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 10),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: agree,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              agree = value!;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${tr('agree_on')} ',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  launchUrl(
                                                    Uri.parse(
                                                        'https://www.privacypolicygenerator.info/live.php?token=MsmKdi4pne1dYTITIsaOPEXQh0zwVN1t'),
                                                  );
                                                },
                                                child: Text(
                                                  tr('terms_conditions'),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     launchUrl(
                                              //       Uri.parse(
                                              //           'https://www.privacypolicygenerator.info/live.php?token=MsmKdi4pne1dYTITIsaOPEXQh0zwVN1t'),
                                              //     );
                                              //   },
                                              //   child: const Text(
                                              //     ' وسياسة الخصوصية',
                                              //     style: TextStyle(
                                              //       fontSize: 12,
                                              //       fontWeight: FontWeight.w600,
                                              //       color: Colors.white,
                                              //       decoration: TextDecoration.underline,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                            // const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // maximumSize: const Size(170.0, 90.0),
                                    // minimumSize: const Size(170.0, 60.0),
                                    backgroundColor: Colors.grey.shade700,
                                    // primary: Colors.black,
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () {
                                    if (emailController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty &&
                                        nameController.text.isNotEmpty &&
                                        phoneController.text.isNotEmpty &&
                                        confirmPasswordController
                                            .text.isNotEmpty &&
                                        userNameController.text.isNotEmpty &&
                                        ageController.text.isNotEmpty) {
                                      if (passwordController.text ==
                                          confirmPasswordController.text) {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .signUp(
                                          email: emailController.text.trim(),
                                          password: passwordController.text,
                                          name: nameController.text,
                                          phone:
                                              '+$code-${phoneController.text}',
                                          username: userNameController.text,
                                          age: int.parse(ageController.text),
                                          gender: gender.name,
                                          role: "user",
                                        );
                                      } else if (passwordController.text ==
                                              confirmPasswordController.text &&
                                          !agree) {
                                        Fluttertoast.showToast(
                                          msg: context.locale.languageCode ==
                                                  'ar'
                                              ? 'من فضلك قم بالموافقة على الشروط والاحكام'
                                              : 'Please agree to the terms and conditions',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        Get.snackbar(
                                          tr('error'),
                                          context.locale.languageCode == 'ar'
                                              ? 'كلمة المرور غير متطابقة'
                                              : 'Password mismatch',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        tr('error'),
                                        context.locale.languageCode == 'ar'
                                            ? 'الرجاء ملئ جميع الحقول'
                                            : 'Please fill in all fields',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                  child: Text(
                                      context.locale.languageCode == 'ar'
                                          ? 'إكمال التسجيل'
                                          : 'Complete registration',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0))),
                            ),
                            // const SizedBox(height: 30.0),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     TextButton(
                            //       onPressed: () {},
                            //       child: Text(
                            //         'تسجيل',
                            //         style: TextStyle(color: Colors.black),
                            //       ),
                            //     ),
                            //     TextButton(
                            //       onPressed: () {
                            //         Navigator.pushNamed(context, 'login');
                            //       },
                            //       child: Text(
                            //         'LOGIN',
                            //         style: TextStyle(color: Colors.black),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/user_provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/login1.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.only(
              //         top: 60.0,
              //       ),
              //       child: const Text(
              //         'إعادة تعيين\n كلمة المرور',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 40.0,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                  ),
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
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 36.sp, vertical: 8.sp),
                              child: SizedBox(
                                height: 50,
                                width: 250.w,
                                child: TextFormField(
                                  controller: emailController,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'cairo'),
                                  decoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.white54),
                                    prefixIcon: const Icon(Icons.email_outlined,
                                        color: Colors.white),
                                    // fillColor: Colors.grey.shade100,
                                    // filled: true,
                                    hintText: tr('enter_email'),
                                    // hintText: 'ادخل البريد الالكتروني',
                                    border: const UnderlineInputBorder(
                                      // borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                      ),
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      // borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    maximumSize: const Size(170.0, 90.0),
                                    minimumSize: const Size(170.0, 60.0),
                                    backgroundColor: Colors.grey[700],
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () {
                                    if (emailController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          context.locale.languageCode == 'ar'
                                              ? 'الرجاء ادخال البريد الالكتروني'
                                              : 'Please enter your email',
                                        ),
                                      ));
                                      return;
                                    }
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .forgetPassword(
                                            emailController.text.trim());
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        tr('reset'),
                                        // Text('إعادة تعيين ',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                      const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
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
            ],
          ),
        ),
      ),
    );
  }
}

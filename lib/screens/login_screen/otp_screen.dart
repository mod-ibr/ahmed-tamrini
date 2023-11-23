import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class OtpPage extends StatefulWidget {
  final String? phone;

  const OtpPage({Key? key, this.phone}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: const TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, loginStore, __) {
        return Scaffold(
          // key: loginStore.otpScaffoldKey,
          appBar: globalAppBar(
            context.locale.languageCode == 'ar'
                ? 'تأكيد الهاتف'
                : 'Confirm phone',
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                    context.locale.languageCode == 'ar'
                                        ? 'أدخل رمز التحقق الذي تم إرساله إلى رقم هاتفك المحمول'
                                        : 'Enter the verification code sent to your mobile number',
                                    style: const TextStyle(
                                        // color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500))),
                            OtpTextField(
                              numberOfFields: 6,
                              borderColor: kSecondaryColor!,

                              //set to true to show as box or false to show as dash
                              showFieldAsBox: true,
                              //runs when a code is typed in
                              onCodeChanged: (String code) {
                                //handle validation or checks here
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) {
                                text = verificationCode;
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //         title: Text("Verification Code"),
                                //         content: Text(
                                //             'Code entered is $verificationCode'),
                                //       );
                                //     });
                              }, // end onSubmit
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: MaterialButton(
                          onPressed: () {
                            log("code:$text");
                            Provider.of<UserProvider>(context, listen: false)
                                .verifyPhoneCode(
                                    code: text, phone: widget.phone!);
                          },
                          color: kPrimaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14))),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  tr('verify'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: kSecondaryColor,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // NumericKeyboard(
                      //   onKeyboardTap: _onKeyboardTap,
                      //   textColor: kSecondaryColor,
                      //   rightIcon: Icon(
                      //     Icons.backspace,
                      //     color: kSecondaryColor,
                      //   ),
                      //   rightButtonFn: () {
                      //     setState(() {
                      //       text = text.substring(0, text.length - 1);
                      //     });
                      //   },
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

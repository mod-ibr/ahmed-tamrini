import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/screens/login_screen/login_screen.dart';
import 'package:tamrini/screens/login_screen/sign_up_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class BottomText extends StatefulWidget {
  final text1;
  final text2;
  const BottomText({super.key, required this.text1, required this.text2});

  @override
  State<BottomText> createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {
  @override
  void initState() {
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       To(const SignupScreen());
  //       setState(() {});
  //     }
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        // details.localPosition.value =
        //     ChangeScreenAnimation.bottomTextAnimation.value;
        // setState(() {});
      },
      onTap: () {
        widget.text1 == '${tr('do_not_have_account')}؟ '
            // widget.text1 == 'ليس لديك حساب؟ '
            ? To(const SignupScreen())
            : To(const LoginScreen());

        // if (!ChangeScreenAnimation.isPlaying) {
        //   ChangeScreenAnimation.currentScreen == Screens.welcomeBack
        //       ? ChangeScreenAnimation.reverse()
        //       : ChangeScreenAnimation.forward();
        //
        //   ChangeScreenAnimation.currentScreen =
        //       Screens.values[1 - ChangeScreenAnimation.currentScreen.index];
        // }
        // setState(() {});
      },
      behavior: HitTestBehavior.opaque,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Montserrat',
          ),
          children: [
            TextSpan(
              text: widget.text1,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: widget.text2,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

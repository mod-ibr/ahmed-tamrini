import 'package:flutter/material.dart';
import 'package:tamrini/screens/login_screen/animations/change_screen_animation.dart';

import 'login_content.dart';

class TopText extends StatefulWidget {
  const TopText({Key? key}) : super(key: key);

  @override
  State<TopText> createState() => _TopTextState();
}

class _TopTextState extends State<TopText> {
  @override
  void initState() {
    // ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     // setState(() {});
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      ChangeScreenAnimation.currentScreen == Screens.createAccount
          ? 'إنشاء\nحساب'
          : 'تسجيل\nالدخول',
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}

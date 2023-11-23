import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(tr('about_app')),
        // appBar: globalAppBar("عن التطبيق"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      context.locale.languageCode == 'ar'
                          ? "تطبيق تمريني هو تطبيق شامل للرياضيين بشكل عام ولرياضة كمال الأجسام بشكل خاص\n بحيث أنه مزود بكل الأقسام التي يحتاجها الرياضي: \n- المقالات\n- حاسبة البروتينات\n- حاسبة القيم الغذائية\n- متجر للمكملات الغذائية\n- أقسام للتمارين وكيفية أدائها وغيرها من الأقسام المفيدة\nإذا كنت تبحث عن تطبيق يكون رفيق تمرينك ويساعدك بكل شيء يخص التمرين فأنت في المكان الصحيح. تطبيق تمريني هو الحل لك."
                          : "Tamrini App is a comprehensive application for athletes in general and bodybuilders in particular.\nIt provides all the sections that athletes need:\n- Articles\n- Protein Calculator\n- Nutritional Value Calculator\n- Supplement Store\n- Exercise Sections with instructions and more.\nIf you are looking for an app that can be your exercise companion and help you with everything related to training, you are in the right place.\nTamrini App is the solution for you.",
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                  Column(
                    children: [
                      Image.asset(
                        "assets/icon/icon.png",
                        width: 100,
                        height: 100,
                      ),
                      Text(context.locale.languageCode == 'ar'
                          ? "جميع الحقوق محفوظة"
                          : "All rights preserved"),
                      // const Text("جميع الحقوق محفوظة"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Tamrini"),
                          const Text(" © "),
                          Text(DateTime.now().year.toString()),
                        ],
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tamrini/screens/exercises_screens/suggested_exercises_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class SuggestedExercises extends StatelessWidget {
  const SuggestedExercises({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('suggested_exercises')),
      // appBar: globalAppBar("التمارين المقترحة"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                To(const SuggestedExercisesScreen(homeExercises: false));
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/exercise.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                constraints: BoxConstraints(
                  minHeight: 100.h,
                  maxHeight: 200.h,
                  maxWidth: double.infinity,
                  minWidth: double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tr('exercises'),
                    // "التمارين",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                To(const SuggestedExercisesScreen(homeExercises: true));
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/homeExer1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                constraints: BoxConstraints(
                  minHeight: 100.h,
                  maxHeight: 200.h,
                  maxWidth: double.infinity,
                  minWidth: double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tr('home_exercises'),
                    // "التمارين المنزلية",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

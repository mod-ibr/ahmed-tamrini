import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/exercise_provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/home_exercise_provider.dart';
import 'package:tamrini/provider/trainer_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/exercises_screens/exercises_home_screen.dart';
import 'package:tamrini/screens/gym_screens/gyms_screen.dart';
import 'package:tamrini/screens/home_exercises_screens/home_exercises_home_screen.dart';
import 'package:tamrini/screens/login_screen/login_screen.dart';
import 'package:tamrini/screens/trainer_screens/trainer_home_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class ExerciseCategoryScreen extends StatefulWidget {
  const ExerciseCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseCategoryScreen> createState() => _ExerciseCategoryScreenState();
}

class _ExerciseCategoryScreenState extends State<ExerciseCategoryScreen> {
  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage("assets/images/gymloca2.jpg"), context);
    precacheImage(const AssetImage("assets/images/homeExer1.jpg"), context);
    precacheImage(const AssetImage("assets/images/exercise.jpg"), context);
    precacheImage(const AssetImage("assets/images/trainer.jpg"), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // searchBar(_searchController, (p0) => null),
          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Provider.of<ExerciseProvider>(context, listen: false)
                    .fetchAndSetExercise();
                To(const ExercisesHomeScreen());
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
                    tr('look_for_your_exercise'),
                    // "ابحث عن تمرينك",
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
                Provider.of<HomeExerciseProvider>(context, listen: false)
                    .fetchAndSetExercise();
                To(const HomeExercisesHomeScreen());
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
          GestureDetector(
            onTap: () {
              Provider.of<GymProvider>(context, listen: false)
                  .fetchAndSetGyms();
              To(const GymsScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gymloca2.jpg"),
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
                    tr('gyms'),
                    // "صالات الجيم",
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
                if (!Provider.of<UserProvider>(context, listen: false)
                    .isLogin) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.bottomSlide,
                    title: tr('alert'),
                    desc: tr('must_log_in'),
                    btnCancelOnPress: () {
                      // pop();
                    },
                    btnOkOnPress: () {
                      To(const LoginScreen());
                    },
                  ).show();
                } else {
                  Provider.of<TrainerProvider>(context, listen: false)
                      .fetchAndSetTrainers();
                  To(const TrainerHomeScreen());
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/trainer.jpg"),
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
                    tr('trainers'),
                    // "المدربين",
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
        ],
      ),
    );
  }
}

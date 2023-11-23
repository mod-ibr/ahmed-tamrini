import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/trainer_screens/add_course_screen2.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class AddCourseScreen extends StatelessWidget {
  DayWeekExercises dayWeekExercises = DayWeekExercises();
  Course course = Course();

  AddCourseScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('add_the_course')),
      // appBar: globalAppBar('إضافة الكورس'),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: tr('course_name'),
                      border: const OutlineInputBorder()),
                  // labelText: 'اسم الكورس', border: OutlineInputBorder()),
                  onChanged: (value) {
                    course.title = value;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: tr('period_in_weeks'),
                      // labelText: 'المده بالاسابيع',
                      border: const OutlineInputBorder()),
                  onChanged: (value) {
                    course.duration = value;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (course.title!.isNotEmpty &&
                              course.duration!.isNotEmpty
                          // day1Controller.text.isNotEmpty &&
                          // day2Controller.text.isNotEmpty &&
                          // day3Controller.text.isNotEmpty &&
                          // day4Controller.text.isNotEmpty &&
                          // day5Controller.text.isNotEmpty &&
                          // day6Controller.text.isNotEmpty &&
                          // day7Controller.text.isNotEmpty
                          ) {
                        // _.selectedTrainee?.courses!.add(course);
                        _.newCourse = course;
                        _.newCourse.dayWeekExercises = DayWeekExercises(
                          sat: [],
                          sun: [],
                          mon: [],
                          tue: [],
                          wed: [],
                          thurs: [],
                          fri: [],
                        );

                        To(AddCourseScreen2());

                        //
                      } else {}
                    } catch (e) {
                      pop();

                      Fluttertoast.showToast(
                          msg: tr('wrong'),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Text(tr('next'),
                      // child: const Text('التالي',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }
}

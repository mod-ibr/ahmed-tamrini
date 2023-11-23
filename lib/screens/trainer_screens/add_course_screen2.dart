import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/exercises_screens/exercise_Article_details_screen.dart';
import 'package:tamrini/screens/exercises_screens/exercises_home_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../model/trainee_exercise.dart';

class AddCourseScreen2 extends StatelessWidget {
  DayWeekExercises dayWeekExercises = DayWeekExercises(
      sat: [], sun: [], mon: [], tue: [], wed: [], thurs: [], fri: []);

  AddCourseScreen2({
    Key? key,
  }) : super(key: key);

  String _getCardTitle(TraineeExercise traineeExercise) {
    return '${traineeExercise.exercise!.title!} ${traineeExercise.superSetExercise != null ? (' +  ${traineeExercise.superSetExercise!.title!}') : ''}';
  }

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
                Row(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? 'يوم السبت'
                        : 'Saturday'),
                    IconButton(
                        onPressed: () {
                          To(const ExercisesHomeScreen(
                            isCourse: true,
                            dayID: 'sat',
                            // course: _.newCourse,
                          ));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _.newCourse.dayWeekExercises == null ||
                        _.newCourse.dayWeekExercises!.sat == null
                    ? Center(child: Text(tr('no_exercises')))
                    // ? const Center(child: Text('لا يوجد تمارين  '))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                To(ExerciseArticlesDetailsScreen(
                                    exercise: _.newCourse.dayWeekExercises!
                                        .sat![index].exercise!,
                                    superSetExercise: _
                                        .newCourse
                                        .dayWeekExercises!
                                        .sat![index]
                                        .superSetExercise,
                                    category: Exercise(id: "0"),
                                    isAll: true));
                              },
                              title: Text(
                                _getCardTitle(
                                  _.newCourse.dayWeekExercises!.sat![index],
                                ),
                              ),
                              // subtitle: Text(_.newCourse.dayWeekExercises!
                              //     .sat![index].exercise!.description!),
                              // isThreeLine: true,
                            ),
                          );
                        },
                        itemCount: _.newCourse.dayWeekExercises!.sat!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? 'يوم الأحد'
                        : 'Sunday'),
                    IconButton(
                        onPressed: () {
                          To(const ExercisesHomeScreen(
                            isCourse: true,
                            dayID: 'sun',
                            // course: _.newCourse,
                          ));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _.newCourse.dayWeekExercises == null ||
                        _.newCourse.dayWeekExercises!.sun == null
                    ? Center(child: Text(tr('no_exercises')))
                    // ? const Center(child: Text('لا يوجد تمارين  '))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                To(ExerciseArticlesDetailsScreen(
                                    exercise: _.newCourse.dayWeekExercises!
                                        .sun![index].exercise!,
                                    superSetExercise: _
                                        .newCourse
                                        .dayWeekExercises!
                                        .sun![index]
                                        .superSetExercise,
                                    category: Exercise(id: "0"),
                                    isAll: true));
                              },
                              title: Text(
                                _getCardTitle(
                                  _.newCourse.dayWeekExercises!.sun![index],
                                ),
                              ),
                              // subtitle: Text(_.newCourse.dayWeekExercises!
                              //     .sun![index].exercise!.description!),
                              // isThreeLine: true,
                            ),
                          );
                        },
                        itemCount: _.newCourse.dayWeekExercises!.sun!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? 'يوم الإثنين'
                        : 'Monday'),
                    IconButton(
                        onPressed: () {
                          To(const ExercisesHomeScreen(
                            isCourse: true,

                            dayID: 'mon',
                            // course: _.newCourse,
                          ));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _.newCourse.dayWeekExercises == null ||
                        _.newCourse.dayWeekExercises!.mon == null
                    ? Center(child: Text(tr('no_exercises')))
                    // ? const Center(child: Text('لا يوجد تمارين  '))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                To(ExerciseArticlesDetailsScreen(
                                    exercise: _.newCourse.dayWeekExercises!
                                        .mon![index].exercise!,
                                    superSetExercise: _
                                        .newCourse
                                        .dayWeekExercises!
                                        .mon![index]
                                        .superSetExercise,
                                    category: Exercise(id: "0"),
                                    isAll: true));
                              },
                              title: Text(
                                _getCardTitle(
                                  _.newCourse.dayWeekExercises!.mon![index],
                                ),
                              ),
                              // subtitle: Text(_.newCourse.dayWeekExercises!
                              //     .mon![index].exercise!.description!),
                              // isThreeLine: true,
                            ),
                          );
                        },
                        itemCount: _.newCourse.dayWeekExercises!.mon!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? 'يوم الثلاثاء'
                        : 'Tuesday'),
                    IconButton(
                        onPressed: () {
                          To(const ExercisesHomeScreen(
                            isCourse: true,
                            dayID: 'tue',
                            // course: _.newCourse,
                          ));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _.newCourse.dayWeekExercises == null ||
                        _.newCourse.dayWeekExercises!.tue == null
                    ? Center(child: Text(tr('no_exercises')))
                    // ? const Center(child: Text('لا يوجد تمارين  '))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                To(ExerciseArticlesDetailsScreen(
                                    exercise: _.newCourse.dayWeekExercises!
                                        .tue![index].exercise!,
                                    superSetExercise: _
                                        .newCourse
                                        .dayWeekExercises!
                                        .tue![index]
                                        .superSetExercise,
                                    category: Exercise(id: "0"),
                                    isAll: true));
                              },
                              title: Text(
                                _getCardTitle(
                                  _.newCourse.dayWeekExercises!.tue![index],
                                ),
                              ),
                              // subtitle: Text(_.newCourse.dayWeekExercises!
                              //     .tue![index].exercise!.description!),
                              // isThreeLine: true,
                            ),
                          );
                        },
                        itemCount: _.newCourse.dayWeekExercises!.tue!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? 'يوم الأربعاء'
                        : 'Wednesday'),
                    // const Text('يوم الأربعاء'),
                    IconButton(
                        onPressed: () {
                          To(const ExercisesHomeScreen(
                            isCourse: true,
                            dayID: 'wed',
                            // course: _.newCourse,
                          ));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _.newCourse.dayWeekExercises == null ||
                        _.newCourse.dayWeekExercises!.wed == null
                    ? Center(child: Text(tr('no_exercises')))
                    // ? const Center(child: Text('لا يوجد تمارين  '))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                To(ExerciseArticlesDetailsScreen(
                                    exercise: _.newCourse.dayWeekExercises!
                                        .wed![index].exercise!,
                                    superSetExercise: _
                                        .newCourse
                                        .dayWeekExercises!
                                        .wed![index]
                                        .superSetExercise,
                                    category: Exercise(id: "0"),
                                    isAll: true));
                              },
                              title: Text(
                                _getCardTitle(
                                  _.newCourse.dayWeekExercises!.wed![index],
                                ),
                              ),
                              // subtitle: Text(_.newCourse.dayWeekExercises!
                              //     .wed![index].exercise!.description!),
                              // isThreeLine: true,
                            ),
                          );
                        },
                        itemCount: _.newCourse.dayWeekExercises!.wed!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? 'يوم الخميس'
                        : 'Thursday'),
                    IconButton(
                        onPressed: () {
                          To(const ExercisesHomeScreen(
                            isCourse: true,
                            dayID: 'thurs',
                            // course: _.newCourse,
                          ));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _.newCourse.dayWeekExercises == null ||
                        _.newCourse.dayWeekExercises!.thurs == null
                    ? Center(child: Text(tr('no_exercises')))
                    // ? const Center(child: Text('لا يوجد تمارين  '))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                To(ExerciseArticlesDetailsScreen(
                                  exercise: _.newCourse.dayWeekExercises!
                                      .thurs![index].exercise!,
                                  superSetExercise: _
                                      .newCourse
                                      .dayWeekExercises!
                                      .thurs![index]
                                      .superSetExercise,
                                  category: Exercise(id: "0"),
                                  isAll: true,
                                ));
                              },
                              title: Text(
                                _getCardTitle(
                                  _.newCourse.dayWeekExercises!.thurs![index],
                                ),
                              ),
                              // subtitle: Text(_.newCourse.dayWeekExercises!
                              //     .thurs![index].exercise!.description!),
                              // isThreeLine: true,
                            ),
                          );
                        },
                        itemCount: _.newCourse.dayWeekExercises!.thurs!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(context.locale.languageCode == 'ar'
                        ? 'يوم الجمعة'
                        : 'Friday'),
                    IconButton(
                        onPressed: () {
                          To(const ExercisesHomeScreen(
                            isCourse: true,

                            dayID: 'fri',
                            // course: _.newCourse,
                          ));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _.newCourse.dayWeekExercises == null ||
                        _.newCourse.dayWeekExercises!.fri == null
                    ? Center(child: Text(tr('no_exercises')))
                    // ? const Center(child: Text('لا يوجد تمارين  '))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                To(ExerciseArticlesDetailsScreen(
                                  exercise: _.newCourse.dayWeekExercises!
                                      .fri![index].exercise!,
                                  superSetExercise: _
                                      .newCourse
                                      .dayWeekExercises!
                                      .fri![index]
                                      .superSetExercise,
                                  category: Exercise(id: "0"),
                                  isAll: true,
                                ));
                              },
                              title: Text(
                                _getCardTitle(
                                  _.newCourse.dayWeekExercises!.fri![index],
                                ),
                              ),
                              // subtitle: Text(_.newCourse.dayWeekExercises!
                              //     .fri![index].exercise!.description!),
                              // isThreeLine: true,
                            ),
                          );
                        },
                        itemCount: _.newCourse.dayWeekExercises!.fri!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                const SizedBox(height: 24),
                // TextFormField(
                //   onChanged: (value) {
                //     _.newCourse.notes = value;
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'ملاحظات',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      showLoaderDialog(context);
                      //
                      if (_.newCourse.dayWeekExercises!.mon!.isNotEmpty ||
                          _.newCourse.dayWeekExercises!.tue!.isNotEmpty ||
                          _.newCourse.dayWeekExercises!.wed!.isNotEmpty ||
                          _.newCourse.dayWeekExercises!.thurs!.isNotEmpty ||
                          _.newCourse.dayWeekExercises!.fri!.isNotEmpty ||
                          _.newCourse.dayWeekExercises!.sat!.isNotEmpty ||
                          _.newCourse.dayWeekExercises!.sun!.isNotEmpty) {
                        _.selectedTrainee!.courses!.add(_.newCourse);

                        await Provider.of<TraineeProvider>(context,
                                listen: false)
                            .saveChangedSelectedTraineeData();
                      } else {
                        pop();
                        Fluttertoast.showToast(
                            msg: context.locale.languageCode == 'ar'
                                ? "يجب اضافة تمارين لكل يوم"
                                : 'Exercises should be added to each day',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
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
                  child: Text(tr('add'),
                      // child: const Text('إضافة',
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

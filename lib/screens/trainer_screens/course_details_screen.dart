import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/exercises_screens/exercise_Article_details_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;
  const CourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar('تفاصيل الكورس'),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: const [
                      Text('يوم السبت'),
                    ],
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            To(ExerciseArticlesDetailsScreen(
                                exercise: course
                                    .dayWeekExercises!.sat![index].exercise!,
                                category: Exercise(id: "0"),
                                isAll: true));
                          },
                          title: Text(course
                              .dayWeekExercises!.sat![index].exercise!.title!),
                          subtitle: Column(
                            children: [
                              Text(
                                  course.dayWeekExercises!.sat![index].exercise!
                                      .description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                    itemCount: course.dayWeekExercises!.sat!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('يوم الأحد'),
                    ],
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            To(ExerciseArticlesDetailsScreen(
                                exercise: course
                                    .dayWeekExercises!.sun![index].exercise!,
                                category: Exercise(id: "0"),
                                isAll: true));
                          },
                          title: Text(course
                              .dayWeekExercises!.sun![index].exercise!.title!),
                          subtitle: Text(
                              course.dayWeekExercises!.sun![index].exercise!
                                  .description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          isThreeLine: true,
                        ),
                      );
                    },
                    itemCount: course.dayWeekExercises!.sun!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('يوم الإثنين'),
                    ],
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            To(ExerciseArticlesDetailsScreen(
                                exercise: course
                                    .dayWeekExercises!.mon![index].exercise!,
                                category: Exercise(id: "0"),
                                isAll: true));
                          },
                          title: Text(course
                              .dayWeekExercises!.mon![index].exercise!.title!),
                          subtitle: Text(
                              course.dayWeekExercises!.mon![index].exercise!
                                  .description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          isThreeLine: true,
                        ),
                      );
                    },
                    itemCount: course.dayWeekExercises!.mon!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('يوم الثلاثاء'),
                    ],
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            To(ExerciseArticlesDetailsScreen(
                                exercise: course
                                    .dayWeekExercises!.thurs![index].exercise!,
                                category: Exercise(id: "0"),
                                isAll: true));
                          },
                          title: Text(course.dayWeekExercises!.thurs![index]
                              .exercise!.title!),
                          subtitle: Text(
                              course.dayWeekExercises!.thurs![index].exercise!
                                  .description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          isThreeLine: true,
                        ),
                      );
                    },
                    itemCount: course.dayWeekExercises!.thurs!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('يوم الأربعاء'),
                    ],
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            To(ExerciseArticlesDetailsScreen(
                                exercise: course
                                    .dayWeekExercises!.wed![index].exercise!,
                                category: Exercise(id: "0"),
                                isAll: true));
                          },
                          title: Text(course
                              .dayWeekExercises!.wed![index].exercise!.title!),
                          subtitle: Text(
                              course.dayWeekExercises!.wed![index].exercise!
                                  .description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          isThreeLine: true,
                        ),
                      );
                    },
                    itemCount: course.dayWeekExercises!.wed!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('يوم الخميس'),
                    ],
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            To(ExerciseArticlesDetailsScreen(
                                exercise: course
                                    .dayWeekExercises!.tue![index].exercise!,
                                category: Exercise(id: "0"),
                                isAll: true));
                          },
                          title: Text(course
                              .dayWeekExercises!.tue![index].exercise!.title!),
                          subtitle: Text(
                              course.dayWeekExercises!.tue![index].exercise!
                                  .description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          isThreeLine: true,
                        ),
                      );
                    },
                    itemCount: course.dayWeekExercises!.tue!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: const [
                      Text('يوم الجمعة'),
                    ],
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            To(ExerciseArticlesDetailsScreen(
                                exercise: course
                                    .dayWeekExercises!.fri![index].exercise!,
                                category: Exercise(id: "0"),
                                isAll: true));
                          },
                          title: Text(course
                              .dayWeekExercises!.fri![index].exercise!.title!),
                          subtitle: Text(
                              course.dayWeekExercises!.fri![index].exercise!
                                  .description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          isThreeLine: true,
                        ),
                      );
                    },
                    itemCount: course.dayWeekExercises!.fri!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

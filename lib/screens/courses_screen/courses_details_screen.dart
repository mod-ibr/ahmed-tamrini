import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/exercise.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/exercises_screens/exercise_Article_details_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/loading_widget.dart';

import '../../model/trainee_exercise.dart';
import '../../model/user.dart';
import '../../utils/widgets/expansion_text.dart';
import '../trainer_screens/trainer_profile_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  const CourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  List<String> days = [];

  int selectedIndex = 0;

  getCurrentDayExercises() {
    switch (selectedIndex) {
      case 0:
        return widget.course.dayWeekExercises!.sat!;
      case 1:
        return widget.course.dayWeekExercises!.sun!;
      case 2:
        return widget.course.dayWeekExercises!.mon!;
      case 3:
        return widget.course.dayWeekExercises!.tue!;
      case 4:
        return widget.course.dayWeekExercises!.wed!;
      case 5:
        return widget.course.dayWeekExercises!.thurs!;
      case 6:
        return widget.course.dayWeekExercises!.fri!;
      default:
        return widget.course.dayWeekExercises!.sat;
    }
  }

  String _getCardTitle(TraineeExercise traineeExercise) {
    return '${traineeExercise.exercise!.title!} ${traineeExercise.superSetExercise != null ? (' +  ${traineeExercise.superSetExercise!.title!}') : ''}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    days = [
      context.locale.languageCode == 'ar' ? 'السبت' : 'Saturday',
      context.locale.languageCode == 'ar' ? 'الأحد' : 'Sunday',
      context.locale.languageCode == 'ar' ? 'الاثنين' : 'Monday',
      context.locale.languageCode == 'ar' ? 'الثلاثاء' : 'Tuesday',
      context.locale.languageCode == 'ar' ? 'الأربعاء' : 'Wednesday',
      context.locale.languageCode == 'ar' ? 'الخميس' : 'Thursday',
      context.locale.languageCode == 'ar' ? 'الجمعة' : 'Friday',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<List<TraineeExercise>?> daysExercises = [
      widget.course.dayWeekExercises!.sat!,
      widget.course.dayWeekExercises!.sun!,
      widget.course.dayWeekExercises!.mon!,
      widget.course.dayWeekExercises!.tue!,
      widget.course.dayWeekExercises!.wed!,
      widget.course.dayWeekExercises!.thurs!,
      widget.course.dayWeekExercises!.fri!,
    ];
    return Scaffold(
      appBar: globalAppBar(tr('course_details')),
      // appBar: globalAppBar('تفاصيل الكورس'),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        log(" is traineeProvider.trainer == null) : ${(_.trainer == null) ? true : false}");
        return _.isLoading
            ? const LoadingWidget()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      if (_.trainer != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.sp),
                          child: imageAvatar(
                              profileImageUrl: _.trainer!.profileImgUrl,
                              trainer: _.trainer!,
                              isCaptain:
                                  (userProvider.user.uid == _.trainer!.uid)),
                        ),
                      Column(
                        children: List.generate(
                          days.length,
                          (index) => ExpansionText(
                            title:
                                '${context.locale.languageCode == 'ar' ? 'يوم ' : ''}${days[index]}',
                            content: daysExercises[index]!.isEmpty
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                        '${tr('no_exercises')} ${context.locale.languageCode == 'ar' ? 'ليوم' : 'for'} ${days[index]}'),
                                  ))
                                : ListView.separated(
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                        onTap: () {
                                          To(
                                            ExerciseArticlesDetailsScreen(
                                              exercise: daysExercises[index]![i]
                                                  .exercise!,
                                              superSetExercise:
                                                  daysExercises[index]![i]
                                                      .superSetExercise,
                                              category: Exercise(id: "0"),
                                              isAll: true,
                                            ),
                                          );
                                        },
                                        title: Text(_getCardTitle(
                                            (daysExercises[index]![i]))),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                            endIndent: 25.w,
                                            indent: 25.w,
                                            color:
                                                kPrimaryColor.withOpacity(0.5)),
                                    itemCount: daysExercises[index]!.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Widget imageAvatar(
      {required String profileImageUrl,
      required bool isCaptain,
      required User trainer}) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xffdbdbdb),
          radius: 80.w,
          child: ClipOval(
            child: profileImageUrl.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CachedNetworkImage(
                      imageUrl: profileImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) {
                        if (url.isEmpty) {
                          return Icon(
                            Icons.person_rounded,
                            size: 20.sp,
                            color: Colors.white,
                          );
                        }
                        return Container(
                          alignment: Alignment.center,
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) => Icon(
                        Icons.person_rounded,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Icon(
                    Icons.person_rounded,
                    size: 20.sp,
                    color: Colors.white,
                  ),
          ),
        ),
        if (!isCaptain)
          Positioned(
            bottom: 0,
            right: 4,
            child:
                buildEditIcon(Theme.of(context).colorScheme.primary, trainer),
          ),
      ],
    );
  }

  Widget buildEditIcon(Color color, User trainer) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: InkWell(
            onTap: () => To(TrainerProfileScreen(
              trainer: trainer,
            )),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

class CourseDayExercisesCard extends StatelessWidget {
  final String dayLabel;
  final List<TraineeExercise> exercises;

  const CourseDayExercisesCard(
      {required this.exercises, required this.dayLabel, Key? key})
      : super(key: key);

  String _getCardTitle(TraineeExercise traineeExercise) {
    return '${traineeExercise.exercise!.title!} ${traineeExercise.superSetExercise != null ? (' +  ${traineeExercise.superSetExercise!.title!}') : ''}';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          children: [
            Text(dayLabel),
          ],
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  To(ExerciseArticlesDetailsScreen(
                      exercise: exercises[index].exercise!,
                      superSetExercise: exercises[index].superSetExercise,
                      category: Exercise(id: "0"),
                      isAll: true));
                },
                title: Text(_getCardTitle((exercises[index]))),
                subtitle: Column(
                  children: [
                    Text(exercises[index].exercise!.description!,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: '${tr('sets_number')}: '),
                              TextSpan(
                                  text: exercises[index].setsNo.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: '${tr('repetitions_number')}: '),
                              TextSpan(
                                  text: exercises[index].repeatNo.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        )
                        // Text('${course.dayWeekExercises!.sat![index].setsNo}عدد المجموعات: '),
                      ],
                    )
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
          itemCount: exercises.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

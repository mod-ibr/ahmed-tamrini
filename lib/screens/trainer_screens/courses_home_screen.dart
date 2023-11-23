import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/trainer_screens/add_course_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../courses_screen/courses_details_screen.dart';

class CoursesHomeScreen extends StatelessWidget {
  const CoursesHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: globalAppBar(tr('courses')),
        // appBar: globalAppBar('الكورسات'),
        body: Consumer<TraineeProvider>(
          builder: (context, _, child) {
            return _.isLoading
                ? Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: _.selectedTrainee!.courses == null ||
                              _.selectedTrainee!.courses!.isEmpty
                          ? [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor!,
                                    onPressed: () {
                                      To(AddCourseScreen());
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              end: 8.0),
                                          child: Icon(Icons.add_circle,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          tr('add_course'),
                                          // "اضافة كورس جديد",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              ),
                              // const Spacer(),
                              Center(child: Text(tr('no_courses'))),
                              // child: Text('لا يوجد كورسات  حاليا')),
                              // const Spacer(),
                            ]
                          : [
                              SizedBox(
                                height: 20.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor!,
                                    onPressed: () {
                                      _.exerciseProvider.fetchAndSetExercise();
                                      To(AddCourseScreen());
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              end: 8.0),
                                          child: Icon(Icons.add_circle,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          tr('add_course'),
                                          // "اضافة كورس جديد",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(height: 24),
                              ListView.builder(
                                reverse: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        log("   _.selectedTrainee!.trainerId : ${_.selectedTrainee!.trainerId!}");
                                        _.getTrainerById(
                                            _.selectedTrainee!.trainerId!);
                                        To(CourseDetailsScreen(
                                          course: _
                                              .selectedTrainee!.courses![index],
                                        ));
                                      },
                                      title: Text(_.selectedTrainee!
                                              .courses![index].title ??
                                          ''),
                                      subtitle: Text(
                                        DateFormat('yyyy-MM-dd').format(_
                                                    .selectedTrainee!
                                                    .courses![index]
                                                    .createdAt ==
                                                null
                                            ? DateTime.now()
                                            : DateTime.parse(_.selectedTrainee!
                                                .courses![index].createdAt!
                                                .toDate()
                                                .toString())),
                                      ),

                                      // subtitle: Text(_.selectedTrainee!.exercises![index].!),
                                      // isThreeLine: true,
                                    ),
                                  );
                                },
                                itemCount: _.selectedTrainee!.courses!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ],
                    ),
                  );
          },
        ));
  }
}

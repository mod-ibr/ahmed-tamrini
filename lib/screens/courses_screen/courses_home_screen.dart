import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/courses_screen/courses_details_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class CoursesHomeScreen extends StatelessWidget {
  const CoursesHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: _.traineeData == null ||
                                _.traineeData!.courses == null ||
                                _.traineeData!.courses!.isEmpty
                            ? [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Center(child: Text(tr('no_courses'))),
                                  // child: Text('لا يوجد كورسات  حاليا')),
                                ),
                              ]
                            : [
                                const SizedBox(height: 24),
                                ListView.builder(
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        onTap: () {
                                          _.getTrainerById(
                                              _.traineeData?.trainerId ?? "");
                                          To(CourseDetailsScreen(
                                            course:
                                                _.traineeData!.courses![index],
                                          ));
                                        },
                                        title: Text(_.traineeData!
                                            .courses![index].title!),
                                        subtitle: _.traineeData!.courses![index]
                                                    .createdAt !=
                                                null
                                            ? Text(
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateTime.parse(_
                                                        .traineeData!
                                                        .courses![index]
                                                        .createdAt!
                                                        .toDate()
                                                        .toString())),
                                              )
                                            : Text(''),
                                        // subtitle: Text(_.traineeData!.exercises![index].!),
                                        // isThreeLine: true,
                                      ),
                                    );
                                  },
                                  itemCount: _.traineeData!.courses!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                ),
                              ],
                      ),
                    ),
                  );
          },
        ));
  }
}

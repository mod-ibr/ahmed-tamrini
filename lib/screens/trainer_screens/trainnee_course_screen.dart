import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class TraineeCoursesScreen extends StatefulWidget {
  //final List<Course> courses ;
  const TraineeCoursesScreen({Key? key}) : super(key: key);

  @override
  State<TraineeCoursesScreen> createState() => _TraineeCoursesScreenState();
}

class _TraineeCoursesScreenState extends State<TraineeCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('courses')),
      body: Column(
        children: [
          const SizedBox(height: 24),
          MaterialButton(
              onPressed: () {
                // To(AddCourseScreen());
              },
              child: Text(context.locale.languageCode == 'ar'
                  ? "اضف كورس جديد"
                  : "Add a new course")),

          const SizedBox(height: 24),
          // courses.isEmpty
          //     ? const Text("لا يوجد كورسات ")
          //     :
          ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // To(CourseDetailsScreen(course: courses[index]));
                },
                child: Container(
                  height: 200,
                  // width: 100,
                  // color: Colors.red,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    // image: DecorationImage(
                    //   image: const AssetImage("assets/images/food.jpg"),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        context.locale.languageCode == 'ar'
                            ? "اسم الكورس"
                            : "Course Name",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      Text(DateFormat("yyyy-MM-dd").format(DateTime.now())),
                    ],
                  ),
                ),
              );
            },
            // itemCount: courses.length,
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}

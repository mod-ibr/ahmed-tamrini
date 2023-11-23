import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/trainer_screens/add_trainee_diet_screen.dart';
import 'package:tamrini/screens/trainer_screens/diet_details_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class DietHomeScreen extends StatelessWidget {
  const DietHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: globalAppBar(tr('diet')),
        // appBar: globalAppBar('النظام الغذائي'),
        body: Consumer<TraineeProvider>(
          builder: (context, _, child) {
            return _.isLoading
                ? Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: _.selectedTrainee!.food == null ||
                              _.selectedTrainee!.food!.isEmpty
                          ? [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor!,
                                    onPressed: () {
                                      _.exerciseProvider.fetchAndSetExercise();
                                      To(const AddTraineeDietScreen());
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
                                          tr('add_diet'),
                                          // "اضافة نظام غذائي جديد",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              ),
                              // const Spacer(),
                              Center(child: Text(tr('no_diets'))),
                              // const Center(child: Text('لا يوجد انظمة حاليا')),
                              // const Spacer(),
                            ]
                          : [
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    color: kSecondaryColor!,
                                    onPressed: () {
                                      _.exerciseProvider.fetchAndSetExercise();
                                      To(const AddTraineeDietScreen());
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
                                          tr('add_diet'),
                                          // "اضافة نظام غذائي جديد",
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                reverse: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        To(DietDetailsScreen(
                                            food: _.selectedTrainee!
                                                .food![index]));
                                      },
                                      title: Text(
                                        _.selectedTrainee!.food![index].title!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp),
                                      ),
                                      subtitle: Text(
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(_.selectedTrainee!
                                                .food![index].createdAt!
                                                .toDate()
                                                .toString())),
                                      ),
                                      isThreeLine: true,
                                    ),
                                  );
                                },
                                itemCount: _.selectedTrainee!.food!.length,
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

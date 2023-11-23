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
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _.isLoading
                ? Center(
                    child: Image.asset('assets/images/loading.gif',
                        height: 100.h, width: 100.w),
                  )
                : Column(
                    children: _.traineeData == null ||
                            _.traineeData!.food == null ||
                            _.traineeData!.food!.isEmpty
                        ? [
                            // const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(50),
                              child: Center(child: Text(tr('no_diets'))),
                              // Center(child: Text('لا يوجد انظمة حاليا')),
                            ),
                            // const Spacer(),
                          ]
                        : [
                            const SizedBox(height: 24),
                            _.userProvider.isCaptain
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        color: kSecondaryColor!,
                                        onPressed: () {
                                          _.exerciseProvider
                                              .fetchAndSetExercise();
                                          To(const AddTraineeDietScreen());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Icon(Icons.add_circle,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              tr('add_new_diet'),
                                              // "اضافة نظام غذائي جديد",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 10),
                            ListView.builder(
                              reverse: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      To(DietDetailsScreen(
                                          food: _.traineeData!.food![index]));
                                    },
                                    title: Text(
                                      _.traineeData!.food![index].title!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp),
                                    ),
                                    subtitle: Text(
                                      DateFormat('yyyy-MM-dd').format(
                                          DateTime.parse(_.traineeData!
                                              .food![index].createdAt!
                                              .toDate()
                                              .toString())),
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              },
                              itemCount: _.traineeData!.food!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            ),
                          ],
                  ),
          );
        },
      ),
    );
  }
}

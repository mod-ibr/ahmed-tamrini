import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/trainer_screens/add_followUp_screen.dart';
import 'package:tamrini/screens/trainer_screens/followUp_details_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({Key? key}) : super(key: key);

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: globalAppBar(tr('followup')),
      // appBar: globalAppBar("المتابعة"),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        return _.isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 100.h, width: 100.w),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: kSecondaryColor!,
                          onPressed: () {
                            To(const AddFollowUpScreen(
                              isNewSub: false,
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional.only(end: 8.0),
                                child:
                                    Icon(Icons.add_circle, color: Colors.white),
                              ),
                              Text(
                                tr('add_new_followup'),
                                // "اضافة متابعة جديدة",
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    _.traineeData?.followUpList == null ||
                            _.traineeData!.followUpList!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Center(child: Text(tr('no_notes'))),
                            // child: Center(child: Text('لا يوجد ملاحظات')),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _.traineeData?.followUpList!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  To(FollowUpDetailsScreen(
                                      followUpData:
                                          _.traineeData?.followUpList![index] ??
                                              FollowUpData()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(0, 2),
                                              blurRadius: 5)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(children: [
                                        Text(
                                            '${context.locale.languageCode == 'ar' ? 'ملاحظة بتاريخ' : 'Note in'} ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_.traineeData?.followUpList![index].createdAt!.toDate().toString() ?? ''))}'),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              );
      }),
    ));
  }
}

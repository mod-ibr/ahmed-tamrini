import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/trainer_screens/followUp_details_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({Key? key}) : super(key: key);

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    _.selectedTrainee?.followUpList == null ||
                            _.selectedTrainee!.followUpList!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Center(child: Text(tr('no_notes'))),
                            // child: Center(child: Text('لا يوجد ملاحظات')),
                          )
                        : ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: _.selectedTrainee?.followUpList!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  To(FollowUpDetailsScreen(
                                      followUpData: _.selectedTrainee
                                              ?.followUpList![index] ??
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
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(children: [
                                        Text(
                                            '${context.locale.languageCode == 'ar' ? 'ملاحظة بتاريخ' : 'Note in'} ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_.selectedTrainee?.followUpList![index].createdAt!.toDate().toString() ?? ''))}'),
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
    );
  }
}

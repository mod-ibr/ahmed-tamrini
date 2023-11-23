import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/trainer_screens/trainee_profile_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class PendingTraineesScreen extends StatelessWidget {
  const PendingTraineesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('pending_subscribers')),
      // appBar: globalAppBar("الاشتراكات المعلقة"),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        return _.isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 100.h, width: 100.w),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _.pendingTrainees.isEmpty
                    ? [
                        const Spacer(),
                        Center(child: Text(tr('no_pending_subscribers'))),
                        // const Center(child: Text("لا يوجد اشتراكات معلقة")),
                        const Spacer(),
                      ]
                    : [
                        const SizedBox(height: 10),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                onTap: () {
                                  _.selectTrainee(_.pendingTrainees[index]);
                                  To(const TraineeProfileScreen());
                                },
                                title: Text(_.pendingTrainees[index].name!),
                                subtitle: Text(
                                  _.pendingTrainees[index].number!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _.acceptTrainee(
                                            _.pendingTrainees[index]);
                                      },
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _.rejectTrainee(
                                            _.pendingTrainees[index]);
                                      },
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: _.pendingTrainees.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                        const SizedBox(height: 10),
                      ],
              );
      }),
    );
  }
}

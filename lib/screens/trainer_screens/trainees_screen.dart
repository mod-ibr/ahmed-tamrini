import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/trainer_screens/trainee_profile_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class TraineesScreen extends StatelessWidget {
  const TraineesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('subscribers')),
      // appBar: globalAppBar("المشتركين"),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        return _.isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 100.h, width: 100.w),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _.trainees.isEmpty
                      ? [
                          // const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(child: Text(tr('no_subscribers'))),
                            // child: Center(child: Text("لا يوجد لديك مشتركين")),
                          ),
                          // const Spacer()
                        ]
                      : [
                          const SizedBox(height: 10),
                          searchBar(
                            searchController,
                            (value) {
                              _.searchTrainees(value);
                            },
                          ),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _.selectTrainee(_.trainees[index]);

                                    To(const TraineeProfileScreen());
                                  },
                                  title: Text(_.trainees[index].name!),
                                  subtitle: Text(
                                    _.trainees[index].username!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // leading: CircleAvatar(
                                  //   radius: 30.sp,
                                  //   backgroundImage: NetworkImage(_.trainee[index]..!),
                                  // ),
                                ),
                              );
                            },
                            itemCount: _.trainees.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                          const SizedBox(height: 10),
                        ],
                ),
              );
      }),
    );
  }
}

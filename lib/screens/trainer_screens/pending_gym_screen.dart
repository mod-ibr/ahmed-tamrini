import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/gym_screens/gym_details_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class PendingGymScreen extends StatelessWidget {
  const PendingGymScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('pending_gyms')),
      // appBar: globalAppBar("الصالات المعلقة"),
      body: Consumer<GymProvider>(builder: (context, _, child) {
        return _.isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 100.h, width: 100.w),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _.pendingGyms.isEmpty
                    ? [
                        const Spacer(),
                        Center(child: Text(tr('no_pending_gyms'))),
                        // const Center(child: Text("لا يوجد صالات معلقة")),
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
                                  log('From pending Page, gym Owner Id :${_.pendingGyms[index].gymOwnerId}');
                                  To(GymDetailsScreen(
                                      gym: _.pendingGyms[index], isAll: true));
                                },
                                title: Text(_.pendingGyms[index].name,
                                    style: const TextStyle(fontSize: 25)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _.acceptGym(gym: _.pendingGyms[index]);
                                      },
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _.rejectGym(
                                            userProvider: userProvider,
                                            gym: _.pendingGyms[index]);
                                      },
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: _.pendingGyms.length,
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

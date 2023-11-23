import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/trainer_provider.dart';
import 'package:tamrini/screens/trainer_screens/trainer_profile_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class PendingTrainersScreen extends StatelessWidget {
  const PendingTrainersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('pending_trainers')),
      // appBar: globalAppBar("المدربين المعلقين"),
      body: Consumer<TrainerProvider>(builder: (context, _, child) {
        return _.isLoading
            ? Center(
                child: Image.asset('assets/images/loading.gif',
                    height: 100.h, width: 100.w),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _.pendingTrainers.isEmpty
                    ? [
                        const Spacer(),
                        Center(child: Text(tr('no_pending_trainers'))),
                        // const Center(child: Text("لا يوجد مدربين معلقين")),
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
                                  To(TrainerProfileScreen(
                                      trainer: _.pendingTrainers[index]));
                                },
                                title: Text(_.pendingTrainers[index].name),
                                subtitle: Text(
                                  _.pendingTrainers[index].description ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: imageAvatar(
                                    profileImageUrl:
                                        _.pendingTrainers[index].profileImgUrl),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _.acceptTrainer(
                                            _.pendingTrainers[index]);
                                      },
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _.rejectTrainer(
                                            _.pendingTrainers[index]);
                                      },
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: _.pendingTrainers.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                        const SizedBox(height: 10),
                      ],
              );
      }),
    );
  }

  Widget imageAvatar({required String profileImageUrl}) {
    return CircleAvatar(
      backgroundColor: const Color(0xffdbdbdb),
      radius: 22.w,
      child: ClipOval(
        child: profileImageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: profileImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) {
                  if (url.isEmpty) {
                    return Icon(
                      Icons.person_rounded,
                      size: 20.sp,
                      color: Colors.white,
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(),
                  );
                },
                errorWidget: (context, url, error) => Icon(
                  Icons.person_rounded,
                  size: 20.sp,
                  color: Colors.white,
                ),
              )
            : Icon(
                Icons.person_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
      ),
    );
  }
}

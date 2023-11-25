import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/publisherProvider.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/provider/trainer_provider.dart';
import 'package:tamrini/screens/Articles_screens/pending_publishers_screen.dart';
import 'package:tamrini/screens/chats/all_chats_screen.dart';
import 'package:tamrini/screens/exercises_screens/suggested_exercises_screen.dart';
import 'package:tamrini/screens/trainer_screens/pending_gym_screen.dart';
import 'package:tamrini/screens/trainer_screens/pending_subscribers_screen.dart';
import 'package:tamrini/screens/trainer_screens/pending_trainees_screen.dart';
import 'package:tamrini/screens/trainer_screens/pending_trainers_screen.dart';

import '../provider/user_provider.dart';
import '../utils/widgets/global Widgets.dart';
import 'chats/chat_screen.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: globalAppBar(
            context.locale.languageCode == 'ar' ? 'الإشعارات' : 'Notifications',
            isLeading: false),
        body: Consumer<UserProvider>(
          builder: (context, myType, child) {
            var myL = myType.user.notifications.reversed.toList();
            return myType.user.notifications == null ||
                    myType.user.notifications.isEmpty
                ? Center(
                    child: Text(
                      context.locale.languageCode == 'ar'
                          ? 'لا يوجد إشعارات'
                          : 'No notifications',
                    ),
                  )
                : ListView.builder(
                    itemCount: myType.user.notifications.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            log("*********** Notification :${myL[index]['title']} ");
                            switch (myL[index]['title']) {
                              case 'طلب تدريب جديد':
                                Provider.of<TraineeProvider>(context,
                                        listen: false)
                                    .fetchAndSetPendingTrainees();
                                To(const PendingTraineesScreen());
                                break;

                              case ' طلب انضمام مدرب جديد':
                                Provider.of<TrainerProvider>(context,
                                        listen: false)
                                    .fetchAndSetPendingTrainers();
                                To(const PendingTrainersScreen());

                                break;
                              case ' طلب انضمام ناشر جديد':
                                Provider.of<PublisherProvider>(context,
                                        listen: false)
                                    .fetchAndSetPendingPublishers();
                                To(const PendingPublishersScreen());

                                break;
                              case " طلب اضافة صالة جديدة":
                                Provider.of<GymProvider>(context, listen: false)
                                    .fetchAndSetPendingGyms();
                                To(const PendingGymScreen());

                                break;
                              case "طلب اقتراح تمرين جديد":
                                To(
                                  const SuggestedExercisesScreen(
                                    homeExercises: false,
                                  ),
                                );

                                break;
                              case "طلب اقتراح تمرين منزلي جديد":
                                To(
                                  const SuggestedExercisesScreen(
                                    homeExercises: true,
                                  ),
                                );
                                break;
                              case 'رسالة جديدة':
                                To(const AllChatsScreen());
                                break;
                              case 'طلب انضمام جديد':
                                Provider.of<GymProvider>(context, listen: false)
                                    .fetchAndSetPendingSubscribers();
                                To(const PendingSubscribersScreen());
                                break;
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(myL[index]['title']),
                              subtitle: Text(myL[index]['body']),
                              trailing: Text(
                                DateFormat('hh:mm  yyyy-MM-dd').format(
                                    DateTime.parse(myL[index]['createsAt']
                                        .toDate()
                                        .toString())),
                                style: const TextStyle(fontSize: 12),
                              ),

                              // trailing: InkWell(
                              //     onTap: () {
                              //       myType.deleteNotification(
                              //           myType.user.notifications[index]['id']);
                              //     },
                              //     child: const Icon(Icons.delete)),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ));
  }
}

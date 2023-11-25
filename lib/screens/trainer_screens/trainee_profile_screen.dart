import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/screens/trainer_screens/courses_home_screen.dart';
import 'package:tamrini/screens/trainer_screens/diet_home_screen.dart';
import 'package:tamrini/screens/trainer_screens/followUp_screen.dart';
import 'package:tamrini/screens/trainer_screens/supplements_home_screen.dart';
import 'package:tamrini/utils/widgets/button_widget.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../model/user.dart';
import '../../provider/user_provider.dart';
import '../chats/chat_screen.dart';

class TraineeProfileScreen extends StatefulWidget {
  const TraineeProfileScreen({Key? key}) : super(key: key);

  @override
  State<TraineeProfileScreen> createState() => _TraineeProfileScreenState();
}

class _TraineeProfileScreenState extends State<TraineeProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        persistentFooterButtons: [adBanner()],
        appBar: globalAppBar(tr('trainee_file')),
        // appBar: globalAppBar("ملف المتدرب"),
        body: Consumer<TraineeProvider>(builder: (context, _, child) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 50),

              buildName(_.selectedTrainee!),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: buildUpgradeButton(
                    context.locale.languageCode == 'ar'
                        ? "تواصل مع المتدرب"
                        : "Connect with Trainee", () async {
                  Trainee trainee = _.selectedTrainee!;

                  String chatID = '';
                  await FirebaseFirestore.instance
                      .collection('chats')
                      .where(
                        'userID',
                        isEqualTo: trainee.uid,
                      )
                      .where(
                        'trainerID',
                        isEqualTo: userProvider.getCurrentUserId(),
                      )
                      .get()
                      .then(
                    (snapshot) {
                      if (snapshot.size == 0) return;
                      if (!snapshot.docs.first.exists ||
                          snapshot.docs.first.data().isEmpty) return;
                      chatID = snapshot.docs.first.id;
                    },
                  );
                  if (chatID.isEmpty) {
                    await FirebaseFirestore.instance.collection('chats').add({
                      'userID': trainee.uid,
                      'trainerID': userProvider.getCurrentUserId(),
                      'messages': [],
                    }).then((docRef) => chatID = docRef.id);
                  }
                  To(ChatScreen(chatID: chatID));
                }),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: buildUpgradeButton(tr('data_followup'), () {
                  // child: buildUpgradeButton("البيانات و المتابعة", () {
                }),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //TODO: add the buttons
                      children: [
                        buildUpgradeButton(tr('courses'), () {
                          // buildUpgradeButton("الكورسات", () {
                          setState(() {
                            To(const CoursesHomeScreen());
                          });
                        }),
                        const SizedBox(width: 24),
                        buildUpgradeButton(tr('diet'), () {
                          // buildUpgradeButton("النظام الغذائي", () {
                          setState(() {
                            To(const DietHomeScreen());
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    buildUpgradeButton(tr('nutritional_supplements'), () {
                      // buildUpgradeButton("المكملات الغذائية", () {
                      setState(() {
                        To(const SupplementsHomeScreen());
                      });
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // NumbersWidget(trainer: widget.trainee),
              // const SizedBox(height: 48),
              // buildAbout(_.selectedTrainee!),
              const SizedBox(height: 48),
            ],
          );
        }),
      ),
    );
  }

  Widget buildName(Trainee user) => Column(
        children: [
          Text(
            user.name!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),

          Text(
            user.gender!.toString(),
          ),
          const SizedBox(height: 4),

          Text(
            "${user.age!} ${tr('year')}",
          ),
          const SizedBox(height: 4),
          Text(
            user.number!.toString(),
          ),
          const SizedBox(height: 4),
          // user.dateOfSubscription == null ? Container():
          // Text(
          //   DateFormat('yyyy-MM-dd').format(DateTime.parse(
          //       user.dateOfSubscription!.toDate().toString())),
          //
          // ),
        ],
      );

  Widget buildUpgradeButton(String title, Function() onClicked) => ButtonWidget(
        text: title,
        onClicked: onClicked,
      );

// Widget buildAbout(Trainee user) {
//   TextEditingController notesController = TextEditingController();
//   notesController.text = user.notes??"" ;
//
//   return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 48),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'ملاحظات',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             minLines: 1,
//             maxLines: 50,
//             controller: notesController,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: (_) {
//
//               Trainee trainee = user..notes = _ ;
//               Provider.of<TraineeProvider>(context, listen: false).updateTrainee(trainee);
//             },
//             decoration: const InputDecoration(
//               // labelText: 'المقال',
//               border: OutlineInputBorder(),
//             ),
//           ),
//
//         ],
//       ),
//     );}
}

import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/Upload_Image_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/chats/chat_screen.dart';
import 'package:tamrini/screens/setting_screens/profile_screen.dart';
import 'package:tamrini/screens/trainer_screens/add_followUp_screen.dart';
import 'package:tamrini/screens/trainer_screens/trainer_req_screen.dart';
import 'package:tamrini/screens/trainer_screens/trainer_req_screen2.dart';
import 'package:tamrini/utils/cache_helper.dart';
import 'package:tamrini/utils/widgets/button_widget.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/numbers_widget.dart';
import 'package:tamrini/utils/widgets/profile_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../setting_screens/settings_screen.dart';
import 'gallery_screen.dart';

class TrainerProfileScreen extends StatefulWidget {
  final User trainer;

  const TrainerProfileScreen({Key? key, required this.trainer})
      : super(key: key);

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('trainer_profile')),
      // appBar: globalAppBar("ملف المدرب الشخصي"),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          //image
          Center(
            child: Consumer<UploadProvider>(
              builder: (context, uploader, child) {
                return ProfileWidget(
                  iconData: Icons.person,
                  isUser: true,
                  imagePath: (uploader.isProfileImageUpdated)
                      ? uploader.profileImageUrl
                      : widget.trainer.profileImgUrl,
                  onClicked: () {
                    log('To Profie Page');
                    To(ProfileScreen(user: widget.trainer));
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          buildName(widget.trainer),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          NumbersWidget(trainer: widget.trainer),
          const SizedBox(height: 48),
          buildAbout(widget.trainer),
          const SizedBox(height: 48),
          buildTrainerGallery(widget.trainer),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget buildName(User user) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),

        Row(
          mainAxisAlignment:
              CacheHelper.getString(key: 'id') != widget.trainer.uid &&
                      !Provider.of<UserProvider>(context, listen: false)
                          .user
                          .isSubscribedToTrainer &&
                      (!userProvider.isAdmin)
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
          children: [
            CacheHelper.getString(key: 'id') != widget.trainer.uid &&
                    (!userProvider.user.isSubscribedToTrainer &&
                        (!userProvider.isAdmin))
                ? Center(child: buildUpgradeButton(widget.trainer))
                : Container(),
            user.uid != userProvider.getCurrentUserId()
                ? ButtonWidget(
                    text: context.locale.languageCode == 'ar'
                        ? 'تواصل معي'
                        : 'Contact me',
                    onClicked: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(context.locale.languageCode == 'ar'
                                    ? 'تواصل معي'
                                    : 'Contact me'),
                                // title: const Text('تواصل معي'),
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        String chatID = '';
                                        await FirebaseFirestore.instance
                                            .collection('chats')
                                            .where(
                                              'userID',
                                              isEqualTo: userProvider
                                                  .getCurrentUserId(),
                                            )
                                            .where(
                                              'trainerID',
                                              isEqualTo: user.uid,
                                            )
                                            .get()
                                            .then(
                                          (snapshot) {
                                            if (snapshot.size == 0) return;
                                            if (!snapshot.docs.first.exists ||
                                                snapshot.docs.first
                                                    .data()
                                                    .isEmpty) return;
                                            chatID = snapshot.docs.first.id;
                                          },
                                        );
                                        if (chatID.isEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('chats')
                                              .add({
                                            'userID':
                                                userProvider.getCurrentUserId(),
                                            'trainerID': user.uid,
                                            'messages': [],
                                          }).then((docRef) =>
                                                  chatID = docRef.id);
                                        }
                                        To(ChatScreen(chatID: chatID));
                                      },
                                      child: const Icon(
                                        Ionicons.chatbox,
                                        color: Colors.blue,
                                        size: 34,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        if (user.contacts![0].contains("+")) {
                                          launchUrl(Uri.parse(
                                              "tel:${user.contacts![0]}"));
                                        }
                                        launchUrl(Uri.parse(user.contacts![0]));
                                      },
                                      child: const Icon(
                                        Ionicons.call,
                                        color: Colors.blue,
                                        size: 34,
                                      ),
                                    ),
                                    user.contacts![1].isEmpty
                                        ? const SizedBox()
                                        : const SizedBox(width: 16),
                                    user.contacts![1].isEmpty
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              launchUrl(
                                                  Uri.parse(user.contacts![1]));
                                            },
                                            child: const Icon(
                                              Ionicons.logo_facebook,
                                              color: Colors.blue,
                                              size: 40,
                                            ),
                                          ),
                                    user.contacts![2].isEmpty
                                        ? const SizedBox()
                                        : const SizedBox(width: 16),
                                    user.contacts![2].isEmpty
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              launchUrl(
                                                  Uri.parse(user.contacts![2]));
                                            },
                                            child: const Icon(
                                              Ionicons.logo_twitter,
                                              color: Colors.blue,
                                              size: 40,
                                            ),
                                          ),
                                    user.contacts![3].isEmpty
                                        ? const SizedBox()
                                        : const SizedBox(width: 16),
                                    user.contacts![3].isEmpty
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              launchUrl(
                                                  Uri.parse(user.contacts![3]));
                                            },
                                            child: const Icon(
                                              Ionicons.logo_instagram,
                                              color: Colors.pink,
                                              size: 40,
                                            ),
                                          ),
                                  ],
                                ),
                              ));
                    },
                  )
                : ButtonWidget(
                    text: context.locale.languageCode == 'ar'
                        ? 'تعديل بيانات المدرب'
                        : 'Update Trainer Data',
                    onClicked: () {
                      To(TrainerRequestScreen2(user: user));
                    },
                  ),
          ],
        ),
        // for (var i = 0; i < user.contacts!.length; i++)
        //   InkWell(
        //     onTap: () {
        //       launchUrl(Uri.parse(user.contacts![i]));
        //     },
        //     child: Text(
        //       user.contacts![i],
        //       style: const TextStyle(color: Colors.blue),
        //     ),
        //   ),
      ],
    );
  }

  Widget buildUpgradeButton(
    User trainer,
  ) =>
      ButtonWidget(
        text: context.locale.languageCode == 'ar' ? 'اشتراك' : 'Subscribe',
        onClicked: () {
          debugPrint('clicked');
          if (!Provider.of<UserProvider>(context, listen: false)
                  .user
                  .isVerifiedPhoneNumber &&
              !Provider.of<UserProvider>(context, listen: false)
                  .user
                  .isVerifiedEmail) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: tr('error'),
              desc: tr('confirm_email_n_phone'),
              btnOkOnPress: () {
                To(const SettingsScreen());
              },
            ).show();
            return;
          }
          To(AddFollowUpScreen(isNewSub: true, trainer: trainer));
          // Provider.of<TrainerProvider>(context, listen: false)
          //     .subscribeToTrainer(widget.trainer);
        },
      );

  Widget buildAbout(User trainer) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.locale.languageCode == 'ar'
                  ? 'الانجازات'
                  : 'Achievements',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              trainer.description ?? '',
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Widget buildTrainerGallery(User trainer) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => To(GalleryScreen(
                trainer: trainer,
              )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.locale.languageCode == 'ar'
                        ? 'معرض الأعمال'
                        : 'Business Exhibition',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    context.locale.languageCode == 'ar'
                        ? Ionicons.arrow_back_circle_outline
                        : Ionicons.arrow_forward_circle_outline,
                    color: Colors.blue,
                    size: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void _showPicker(
      {required BuildContext context,
      required double width,
      required User user,
      required UploadProvider uploader}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                    leading: const Icon(Icons.video_collection),
                    title: Text(context.locale.languageCode == 'ar'
                        ? 'صورة من المعرض'
                        : 'Image from gallery'),
                    onTap: () {
                      allPhotos.clear();
                      uploader.oneImgFromGallery().then((value) {
                        AwesomeDialog(
                                context: navigationKey.currentContext!,
                                dialogType: DialogType.question,
                                animType: AnimType.bottomSlide,
                                title: context.locale.languageCode == 'ar'
                                    ? 'حفظ التغيرات'
                                    : 'Save changes',
                                body:
                                    buildImage(context: context, width: width),
                                btnOkOnPress: () async {
                                  print('SAVE and Upload the Image');

                                  await uploader.uploadProfileImage(
                                      currentProfileImageUrl:
                                          user.profileImgUrl,
                                      userId: user.uid);
                                },
                                btnCancelOnPress: () {
                                  print('Cancel the changes');
                                },
                                btnOkText: tr('save'),
                                btnCancelText: tr('cancel'))
                            .show();
                      });
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(
                    context.locale.languageCode == 'ar' ? 'كاميرا' : 'Camera',
                  ),
                  onTap: () {
                    allPhotos.clear();
                    uploader.imgFromCamera().then((value) {
                      AwesomeDialog(
                              context: navigationKey.currentContext!,
                              dialogType: DialogType.question,
                              animType: AnimType.bottomSlide,
                              title: context.locale.languageCode == 'ar'
                                  ? 'حفظ التغيرات'
                                  : 'Save changes',
                              body: buildImage(context: context, width: width),
                              btnOkOnPress: () async {
                                print('SAVE and Upload the Image');

                                await uploader.uploadProfileImage(
                                    currentProfileImageUrl: user.profileImgUrl,
                                    userId: user.uid);
                              },
                              btnCancelOnPress: () {
                                print('Cancel the changes');
                              },
                              btnOkText: tr('save'),
                              btnCancelText: tr('cancel'))
                          .show();
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget buildImage({required BuildContext context, required double width}) {
    return CircleAvatar(
      backgroundColor: const Color(0xffdbdbdb),
      radius: width * 0.2,
      child: ClipOval(
          child: Image.file(
        allPhotos[0],
        fit: BoxFit.cover,
        height: width * 0.4,
        width: width * 0.4,
      )),
    );
  }
}

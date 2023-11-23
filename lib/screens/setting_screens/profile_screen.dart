import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/gym.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/gym_screens/gym_details_screen.dart';
import 'package:tamrini/screens/setting_screens/edit_profile_screen.dart';
import 'package:tamrini/screens/setting_screens/publisher_profile_screen.dart';
import 'package:tamrini/screens/trainer_screens/trainer_profile_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/widgets/button_widget.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../provider/Upload_Image_provider.dart';
import '../../provider/trainer_provider.dart';
import '../../utils/cache_helper.dart';
import '../../utils/widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('profile')),
      // appBar: globalAppBar("الملف الشخصي"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 24),

              Center(
                child: Consumer<UploadProvider>(
                  builder: (context, uploader, child) {
                    return ProfileWidget(
                      isUser: (widget.user.uid == uploader.getCurrentUid()),
                      imagePath: (uploader.isProfileImageUpdated)
                          ? uploader.profileImageUrl
                          : widget.user.profileImgUrl,
                      onClicked: () {
                        Provider.of<TrainerProvider>(context, listen: false)
                            .user;

                        CacheHelper.getString(key: 'id') == widget.user.uid
                            ? _showPicker(
                                context: context,
                                width: width,
                                user: widget.user,
                                uploader: uploader)
                            : null;
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              buildName(widget.user, userProvider),
              const SizedBox(height: 24),

              // Center(child: buildUpgradeButton()),
              // const SizedBox(height: 24),
              // NumbersWidget(trainer: widget.user),
              userRoles(widget.user),

              const SizedBox(height: 48),
              if (widget.user.uid == userProvider.getCurrentUid())
                InkWell(
                  onTap: () {
                    To(EditProfileScreen(user: widget.user));
                  },
                  child: Text(
                    context.locale.languageCode == 'ar'
                        ? "تعديل البيانات"
                        : "Edit data",
                    // "تعديل البيانات",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 48),
              if (widget.user.uid == userProvider.getCurrentUid())
                InkWell(
                    onTap: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .deleteAccount();
                    },
                    child: Text(
                      context.locale.languageCode == 'ar'
                          ? "حذف حسابي وبياناتي"
                          : "Delete my account & data",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    )),
              // buildAbout(widget.user),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(User user, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
        ),
        const SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(5.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kSecondaryColor,
          ),
          child: Text(
            (user.role == 'admin')
                ? context.locale.languageCode == 'ar'
                    ? "مسؤول"
                    : "Admin"
                : (user.role == 'captain')
                    ? context.locale.languageCode == 'ar'
                        ? "مدرب"
                        : "Trainer"
                    : context.locale.languageCode == 'ar'
                        ? "مستخدم"
                        : "User",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
        ),
        const SizedBox(height: 4),
        if (user.uid ==
            Provider.of<UserProvider>(context, listen: false).getCurrentUid())
          Column(
            children: [
              Text(
                user.username,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.gender,
                style:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 15.sp),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  user.isVerifiedEmail
                      ? const Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.error_outline_outlined,
                          color: Colors.red,
                        ),
                  Text(
                    user.email,
                  ),
                  Visibility(
                    visible: (widget.user.uid == userProvider.getCurrentUid()),
                    child: !user.isVerifiedEmail
                        ? MaterialButton(
                            onPressed: () {
                              Provider.of<UserProvider>(context, listen: false)
                                  .verifyEmail();
                            },
                            color: kSecondaryColor,
                            textColor: Colors.white,
                            minWidth: 10,
                            height: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(tr('activate')))
                        // child: const Text("تفعيل"))
                        : const SizedBox(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                user.phone,
              ),
            ],
          )
      ],
    );
  }

  Widget buildUpgradeButton() {
    return ButtonWidget(
      text: tr('change_password'),
      // text: 'تغيير كلمة المرور',
      onClicked: () {},
    );
  }

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

  // Widget buildAbout(Trainer user) => Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 48),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'الانجازات',
  //         style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 16),
  //       Text(
  //         user.description!,
  //         style: TextStyle(fontSize: 16.sp, height: 1.4),
  //       ),
  //     ],
  //   ),
  // );

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

  Widget userRoles(User user) {
    return Column(
      children: <Widget>[
        if (user.role == "captain")
          ProfileListItem(
            onTap: () {
              To((TrainerProfileScreen(trainer: user)));
            },
            text: context.locale.languageCode == 'ar'
                ? 'معلومات المدرب'
                : "Trainer's information",
            icon: Icons.sports_gymnastics,
          ),
        if (user.gymId != null && user.gymId!.isNotEmpty)
          ProfileListItem(
            icon: Icons.fitness_center,
            onTap: () async {
              Gym? gym = await Provider.of<GymProvider>(context, listen: false)
                  .getGymByOwnerId(user.uid);
              if (gym != null) To(GymDetailsScreen(gym: gym, isAll: false));
            },
            text: context.locale.languageCode == 'ar'
                ? 'معلومات صالة الجيم'
                : "Gym's information",
          ),
        if (user.isPublisher != null && user.isPublisher!)
          ProfileListItem(
            icon: Icons.article,
            onTap: () => To(PublisherProfileScreen(user: user)),
            text: context.locale.languageCode == 'ar'
                ? 'معلومات الناشر'
                : "Publisher's information",
          ),
      ],
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  const ProfileListItem({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ).copyWith(
          bottom: 20,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: kPrimaryColor)),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 25,
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              context.locale.languageCode == 'ar'
                  ? Icons.arrow_back_ios_new
                  : Icons.arrow_forward_ios,
              // textDirection: TextDirection.ltr,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/user.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/Articles_screens/add_publisher_screen.dart';
import 'package:tamrini/screens/setting_screens/profile_screen.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/profile_widget.dart';

import '../../provider/Upload_Image_provider.dart';

class PublisherProfileScreen extends StatefulWidget {
  final User user;

  const PublisherProfileScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<PublisherProfileScreen> createState() => _PublisherProfileScreenState();
}

class _PublisherProfileScreenState extends State<PublisherProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(context.locale.languageCode == 'ar'
          ? "الملف الشخصي للناشر"
          : "Publisher's profile"),
      // appBar: globalAppBar("الملف الشخصي للناشر"),
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
              //image
              Center(
                  child: ProfileWidget(
                iconData: Icons.person,
                isUser: true,
                imagePath: widget.user.profileImgUrl,
                onClicked: () {
                  log('To Profie Page');
                  To(ProfileScreen(user: widget.user));
                },
              )

                  //  imageAvatar(profileImageUrl: widget.user.profileImgUrl),
                  ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: buildName(widget.user, userProvider),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Widget imageAvatar({required String profileImageUrl}) {
  //   return CircleAvatar(
  //     backgroundColor: const Color(0xffdbdbdb),
  //     radius: 100.w,
  //     child: ClipOval(
  //       child: profileImageUrl.isNotEmpty
  //           ? CachedNetworkImage(
  //               imageUrl: profileImageUrl,
  //               fit: BoxFit.cover,
  //               width: double.infinity,
  //               height: double.infinity,
  //               placeholder: (context, url) {
  //                 if (url.isEmpty) {
  //                   return Icon(
  //                     Icons.person_rounded,
  //                     size: 20.sp,
  //                     color: Colors.white,
  //                   );
  //                 }
  //                 return Container(
  //                   alignment: Alignment.center,
  //                   width: 18.w,
  //                   height: 18.w,
  //                   child: const CircularProgressIndicator(),
  //                 );
  //               },
  //               errorWidget: (context, url, error) => Icon(
  //                 Icons.person_rounded,
  //                 size: 20.sp,
  //                 color: Colors.white,
  //               ),
  //             )
  //           : Icon(
  //               Icons.person_rounded,
  //               size: 20.sp,
  //               color: Colors.white,
  //             ),
  //     ),
  //   );
  // }

  Widget buildName(User user, UserProvider userProvider) {
    return Column(
      // direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.locale.languageCode == 'ar'
                  ? "نبذة عن الناشر"
                  : "Brief about publisher",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
            ),
            if ((user.uid == userProvider.getCurrentUid()))
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
                child: IconButton(
                    onPressed: () {
                      To(AddPublisherScreen(user: user));
                    },
                    icon: const Icon(Icons.edit)),
              )
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "${user.publisherSummary}",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20.sp,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // Widget buildImage({required BuildContext context, required double width}) {
  //   return CircleAvatar(
  //     backgroundColor: const Color(0xffdbdbdb),
  //     radius: width * 0.2,
  //     child: ClipOval(
  //         child: Image.file(
  //       allPhotos[0],
  //       fit: BoxFit.cover,
  //       height: width * 0.4,
  //       width: width * 0.4,
  //     )),
  //   );
  // }
}

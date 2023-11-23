import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? profileImageUrl;
  final double width, height;

  const UserAvatar(
      {super.key,
      required this.profileImageUrl,
      required this.iconSize,
      required this.outerRadius,
      required this.innerRadius,
      required this.width,
      required this.height});

  final double iconSize, outerRadius, innerRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Image
          CircleAvatar(
            radius: width * 0.18,
            backgroundColor: const Color(0xffdbdbdb),
            child: CircleAvatar(
              radius: width * 0.175,
              backgroundColor: const Color(0xfff8f7f1),
              child: CircleAvatar(
                backgroundColor: const Color(0xffdbdbdb),
                radius: width * 0.165,
                child: ClipOval(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CachedNetworkImage(
                    imageUrl: profileImageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) {
                      if (url.isEmpty) {
                        return const Icon(
                          Icons.person_rounded,
                          size: 40,
                          color: Colors.white,
                        );
                      }
                      return Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        child: const CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // change image Button
          Container(
            padding: const EdgeInsets.only(top: 15),
            width: width * 0.6, // Adjust the width as needed
            child: GestureDetector(
              onTap: () {
                // showBottomSheet(context);
                // print('Change profile Image');
              },
              child: Text(
                context.locale.languageCode == 'ar'
                    ? "تغيير صورة الملف الشخصي"
                    : 'Change Profile Photo',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

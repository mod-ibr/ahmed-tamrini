import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tamrini/data/user_data.dart';
import 'package:tamrini/model/diet_food.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/diet_food_screens/edit_diet_food_screen.dart';
import 'package:tamrini/screens/setting_screens/profile_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/video_manager.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';
import 'package:tamrini/utils/widgets/loading_widget.dart';

import '../../model/user.dart';
import '../../utils/distripute_assets.dart';

int imgIndex = 0;

class DietFoodDetailsScreen extends StatefulWidget {
  final DietFood dietfood;
  final String type;

  const DietFoodDetailsScreen(
      {super.key, required this.dietfood, required this.type});

  @override
  State<DietFoodDetailsScreen> createState() => _DietFoodDetailsScreenState();
}

class _DietFoodDetailsScreenState extends State<DietFoodDetailsScreen> {
  //VideoManager? //VideoManager;
  late final Future<User?> user;

  @override
  void initState() {
    super.initState();
    user = UserData().fetchUserByUsername(widget.dietfood.writer ?? "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> assets = [];
    assets = distributeAssets(widget.dietfood.assets as List<String>);
    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(tr('article_details')),
      // appBar: globalAppBar("تفاصيل المقال"),
      body: FutureBuilder<User?>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for user data.
            return const Center(child: LoadingWidget());
          } else if (snapshot.hasError) {
            // Handle the error if user data retrieval fails.
            return Center(
                child: Text(context.locale.languageCode == 'ar'
                    ? 'خطاء في تحميل البيانات'
                    : 'Error in loading data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Handle the case where user data is not available.
            return Center(
                child: Text(context.locale.languageCode == 'ar'
                    ? 'لا توجد بيانات'
                    : 'No data'));
          } else {
            // User data is available, continue building the UI.
            final user = snapshot.data!;
            log("DATA user name : ${user.username.toString()}");

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  // constraints:  BoxConstraints(
                  //   minHeight: MediaQuery.of(context).size.height,
                  // ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  widget.dietfood.title ?? '',
                                  maxLines: 2,
                                  // presetFontSizes: [25.sp, 20.sp, 14.sp],
                                  // maxLines: 4,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            widget.dietfood.date != null
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        intl.DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(widget.dietfood.date!
                                                .toDate()
                                                .toString())),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        widget.dietfood.assets.isEmpty
                            ? Container()
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ImageSlideshow(
                                  onPageChanged: (value) {
                                    imgIndex = value;
                                  },
                                  // options: CarouselOptions(
                                  //   height: 200.h,
                                  //   viewportFraction: 1,
                                  //   initialPage: 0,
                                  //   enableInfiniteScroll: true,
                                  //   reverse: false,
                                  //   autoPlay: true,
                                  //   autoPlayInterval: const Duration(seconds: 5),
                                  //   autoPlayAnimationDuration:
                                  //       const Duration(milliseconds: 800),
                                  //   autoPlayCurve: Curves.fastOutSlowIn,
                                  //   enlargeCenterPage: true,
                                  //   scrollDirection: Axis.horizontal,
                                  // ),
                                  children: [
                                    for (var i = 0;
                                        i < widget.dietfood.assets!.length;
                                        i++)
                                      InkWell(
                                        onTap: () {
                                          if (widget.dietfood.assets[i]
                                              .contains(RegExp(
                                                  "[^\\s]+(.*?)\\.(jpg|jpeg|png|JPG|JPEG|PNG|WEBP|webp|tiff|Tiff|TIFF|GIF|gif|bmp|BMP|svg|SVG)"))) {
                                            showDialog<dynamic>(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return OrientationBuilder(
                                                    builder:
                                                        (context, orientation) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return Scaffold(
                                                          appBar: AppBar(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFEFF2F7),
                                                            elevation: 0,
                                                            iconTheme:
                                                                const IconThemeData(
                                                                    color: Color(
                                                                        0xFF003E4F)),
                                                            centerTitle: false,
                                                            title: Text(
                                                              widget.dietfood
                                                                      .title ??
                                                                  '',
                                                              style: TextStyle(
                                                                fontSize: 20.sp,
                                                                color: const Color(
                                                                    0xff007c9d),
                                                              ),
                                                            ),
                                                          ),
                                                          body: Container(
                                                            // height: 1.sh,
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                ImageSlideshow(
                                                              initialPage:
                                                                  imgIndex,
                                                              height: 1.sh,
                                                              children: assets,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                  );
                                                });
                                          }
                                        },
                                        child: assets[i],
                                      )
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    (widget.dietfood.description),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                // height: 100.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // width: double.infinity,
                                  children: [
                                    Text(
                                      context.locale.languageCode == 'ar'
                                          ? 'بواسطة : '
                                          : 'by : ',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () async {
                                        String? username = user.username;
                                        if (username != null) {
                                          UserData userData = UserData();
                                          User? user = await userData
                                              .fetchUserByUsername(username);
                                          if (user != null) {
                                            To(ProfileScreen(user: user));
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: context.locale
                                                          .languageCode ==
                                                      'ar'
                                                  ? 'لا يمكن الوصول الى الملف الشخصي'
                                                  : "Can't Go To this User Account",
                                            );
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: context.locale.languageCode ==
                                                    'ar'
                                                ? 'لا يمكن الوصول الى الملف الشخصي'
                                                : "Can't Go To this User Account",
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          imageAvatar(
                                              profileImageUrl:
                                                  user.profileImgUrl),
                                          const SizedBox(width: 10),
                                          Text(
                                            "${widget.dietfood.writer}",
                                            style: TextStyle(
                                              fontSize: 25.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Provider.of<UserProvider>(context, listen: false)
                                      .isAdmin
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          color: kSecondaryColor!,
                                          onPressed: () {
                                            To(EditDietFoodScreen(
                                              dietFood: widget.dietfood,
                                              type: widget.type,
                                            ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                tr('edit'),
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget imageAvatar({required String profileImageUrl}) {
    return CircleAvatar(
      backgroundColor: const Color(0xffdbdbdb),
      radius: 20.w,
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

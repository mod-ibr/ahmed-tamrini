import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/gym.dart';
import 'package:tamrini/provider/gym_provider.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/gym_screens/edit_gym_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/video_manager.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/distripute_assets.dart';

int imgIndex = 0;

class GymDetailsScreen extends StatefulWidget {
  final Gym gym;
  final bool isAll;

  const GymDetailsScreen({super.key, required this.gym, required this.isAll});

  @override
  State<GymDetailsScreen> createState() => _GymDetailsScreenState();
}

class _GymDetailsScreenState extends State<GymDetailsScreen> {
  //VideoManager//////VideoManagerer;

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> assets = [];

  @override
  initState() {
    for (int i = 0; widget.gym.assets.length > i; i++) {
      assets = distributeAssets(widget.gym.assets);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('************************ Current User Id : ${Provider.of<UserProvider>(context, listen: false).getCurrentUserId()}');
    log("************** Gym Owner Id : ${widget.gym.gymOwnerId} ");
    log("*************** !widget.isAll : ${!widget.isAll}");

    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(widget.gym.name),
      body: SingleChildScrollView(
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
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            widget.gym.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: [
                            AutoSizeText(
                              widget.gym.price.toString(),
                              style: const TextStyle(
                                // fontSize: 20.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            AutoSizeText(
                              context.locale.languageCode == 'ar'
                                  ? " د.ع/شهر "
                                  : ' IQD/month ',
                              style: const TextStyle(
                                // color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  widget.gym.assets.isEmpty
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
                              for (var i = 0; i < widget.gym.assets.length; i++)
                                InkWell(
                                  onTap: () {
                                    if (widget.gym.assets[i].contains(RegExp(
                                        "[^\\s]+(.*?)\\.(jpg|jpeg|png|JPG|JPEG|PNG|WEBP|webp|tiff|Tiff|TIFF|GIF|gif|bmp|BMP|svg|SVG)"))) {
                                      showDialog<dynamic>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return OrientationBuilder(
                                              builder: (context, orientation) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
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
                                                        widget.gym.name,
                                                        style: TextStyle(
                                                          fontSize: 20.sp,
                                                          color: const Color(
                                                              0xff007c9d),
                                                        ),
                                                      ),
                                                    ),
                                                    body: Container(
                                                      // height: 1.sh,
                                                      alignment:
                                                          Alignment.center,
                                                      child: ImageSlideshow(
                                                        initialPage: imgIndex,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/distance.png',
                          width: 18.sp,
                          // color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${widget.gym.distance.toPrecision(3)}${context.locale.languageCode == 'ar' ? 'كم' : 'km'}',
                          style: TextStyle(
                            fontSize: 13.sp,
                          ),
                        ),
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
                              (widget.gym.description),
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<GymProvider>(context,
                                          listen: false)
                                      .openMap(widget.gym);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    // width: double.infinity,
                                    child: Text(
                                      context.locale.languageCode == 'ar'
                                          ? "عرض على الخريطة"
                                          : "Show on map",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 100.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ((Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .isAdmin &&
                                          !widget.isAll) ||
                                      (Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .getCurrentUserId() ==
                                              widget.gym.gymOwnerId &&
                                          !widget.isAll))
                                  ? MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      color: kSecondaryColor!,
                                      onPressed: () {
                                        To(EditGymScreen(
                                          gym: widget.gym,
                                        ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 8.0),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            tr('edit'),
                                            // "تعديل",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

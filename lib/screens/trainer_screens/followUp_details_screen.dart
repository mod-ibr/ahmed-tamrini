import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/trainee.dart';
import 'package:tamrini/provider/trainee_provider.dart';
import 'package:tamrini/utils/distripute_assets.dart';
import 'package:tamrini/utils/video_manager.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

class FollowUpDetailsScreen extends StatefulWidget {
  final FollowUpData followUpData;

  const FollowUpDetailsScreen({Key? key, required this.followUpData})
      : super(key: key);

  @override
  State<FollowUpDetailsScreen> createState() => _FollowUpDetailsScreenState();
}

class _FollowUpDetailsScreenState extends State<FollowUpDetailsScreen> {
  //VideoManager? //VideoManager;
  List<Widget> assets = [];
  int imgIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.followUpData.images != null) {
      assets = distributeAssets(widget.followUpData.images!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: globalAppBar(tr('followup_details')),
      // appBar: globalAppBar('تفاصيل المتابعة'),
      body: Consumer<TraineeProvider>(builder: (context, _, child) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(0, 2),
                      blurRadius: 5)
                ]),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                        '${context.locale.languageCode == 'ar' ? 'متابعة بتاريخ' : 'Followup in'} ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.followUpData.createdAt!.toDate().toString()))}'),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.followUpData.followUpData!.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    ' ${widget.followUpData.followUpData![index]['question']}'),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    ' ${widget.followUpData.followUpData![index]['answer']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      },
                    ),
                    const SizedBox(height: 30),
                    Divider(),
                    const SizedBox(
                      height: 30,
                    ),
                    widget.followUpData.images == null ||
                            widget.followUpData.images!.isEmpty
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
                                    i < widget.followUpData.images!.length;
                                    i++)
                                  InkWell(
                                    onTap: () {
                                      if (widget.followUpData.images![i]
                                          .contains(RegExp(
                                              "[^\\s]+(.*?)\\.(jpg|jpeg|png|JPG|JPEG|PNG|WEBP|webp|tiff|Tiff|TIFF|GIF|gif|bmp|BMP|svg|SVG)"))) {
                                        showDialog<dynamic>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return OrientationBuilder(
                                                builder:
                                                    (context, orientation) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Scaffold(
                                                      appBar: AppBar(
                                                        title: const Text(
                                                            'تفاصيل المتابعة'),
                                                      ),
                                                      persistentFooterButtons: [
                                                        adBanner()
                                                      ],
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
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

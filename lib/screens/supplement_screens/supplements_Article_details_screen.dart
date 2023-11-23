import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tamrini/model/supplement.dart';
import 'package:tamrini/provider/user_provider.dart';
import 'package:tamrini/screens/supplement_screens/edit_supplement_screen.dart';
import 'package:tamrini/utils/constants.dart';
import 'package:tamrini/utils/video_manager.dart';
import 'package:tamrini/utils/widgets/global%20Widgets.dart';

import '../../utils/distripute_assets.dart';

class SupplementArticlesDetailsScreen extends StatefulWidget {
  final SupplementData supplement;
  final Supplement? category;

  const SupplementArticlesDetailsScreen(
      {Key? key, required this.supplement, this.category})
      : super(key: key);

  @override
  State<SupplementArticlesDetailsScreen> createState() =>
      _SupplementArticlesDetailsScreenState();
}

class _SupplementArticlesDetailsScreenState
    extends State<SupplementArticlesDetailsScreen> {
  //VideoManager? videoManager;
  int _current = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> assets = [];
    if (widget.supplement.images != null) {
      assets = distributeAssets(widget.supplement.images!);
    }

    return Scaffold(
      persistentFooterButtons: [adBanner()],
      appBar: globalAppBar(widget.supplement.title ?? ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            // constraints:  BoxConstraints(
            //   minHeight: MediaQuery.of(context).size.height - 100,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.supplement.title ?? '',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  widget.supplement.images == null ||
                          widget.supplement.images!.isEmpty
                      ? Container()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: ImageSlideshow(
                            children: [
                              for (var i = 0;
                                  i < widget.supplement.images!.length;
                                  i++)
                                InkWell(
                                  onTap: () {
                                    if (widget.supplement.images![i].contains(
                                        RegExp(
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
                                                        widget.supplement
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: ImageSlideshow(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          """${(widget.supplement.description)}""",
                          style: TextStyle(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Provider.of<UserProvider>(context, listen: false).isAdmin
                      ? MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: kSecondaryColor!,
                          onPressed: () {
                            To(EditSupplementScreen(
                              supplement: widget.supplement,
                              category: widget.category!,
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsetsDirectional.only(end: 8.0),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                tr('edit'),
                                // "تعديل",
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.white),
                              ),
                            ],
                          ))
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
